--[[
	Client side bag sorting algorithm.
	All Rights Reserved
--]]

---@type string, BagBrotherAddon
local ADDON, Addon = ...

---@class SortItem : table
---@field itemID integer?
---@field stackCount integer?
---@field stackSize integer?
---@field class integer?
---@field subclass integer?
---@field equip string?
---@field level integer?
---@field iconFileID integer?
---@field set integer?
---@field family integer?
---@field sorted boolean?
---@field space SortSpace?
---@field isLocked boolean?

---@class SortSpace
---@field index integer
---@field bag integer
---@field slot integer
---@field family integer
---@field item SortItem

---@class AddonSorting : AddonModule
---@field Properties string[]
---@field target table?
local Sort = Addon:NewModule('Sorting', 'MutexDelay-1.0')
local Search = LibStub('ItemSearch-1.3')
local C = LibStub('C_Everywhere').Item

Sort.Properties = {
	'set',
	'class', 'subclass', 'equip',
	'quality',
	'iconFileID', 'level', 'itemID',
	'stackCount'
}


--[[ Process ]]--

---Starts sorting for the target frame/container.
---@param target table
function Sort:Start(target)
	self.target = target
	self:SendSignal('SORTING_STATUS', target.id)
	self:Run()
end

---Runs the sort check and loops.
function Sort:Run()
	if self:CanRun() then
		ClearCursor()
		self:Iterate()
	else
		self:Stop()
	end
end

---Performs a single iteration of the sort loop.
function Sort:Iterate()
	local spaces = self:GetSpaces()
	local families = self:GetFamilies(spaces)

	local stackable = function(item)
		return (item.stackCount or 1) < (item.stackSize or 1)
	end

	for k, target in pairs(spaces) do
		local item = target.item
		if item.itemID and stackable(item) then
			for j = k+1, #spaces do
				local from = spaces[j]
				local other = from.item

				if item.itemID == other.itemID and stackable(other) and self:Move(from, target) then
					self:Delay(0.05, 'Run')
					if self.target.IsThrottled then
						return
					end
				end
			end
		end
	end

	for _, family in ipairs(families) do
		local order, spaces = self:GetOrder(spaces, family)
		local n = min(#order, #spaces)

		self:OptimizeOrder(order, spaces, n)

		for index = 1, n do
			local goal = spaces[index]
			local item = order[index]
			item.sorted = true

			if goal.item ~= item and self:Move(item.space, goal) then
				self:Delay(0.05, 'Run')
				if self.target.IsThrottled then
					return
				end
			end
		end
	end

	if not self:Delaying('Run') then
		self:Stop()
	end
end

---Stops the sorting process.
function Sort:Stop()
	self.target = nil
	self:SendSignal('SORTING_STATUS')
end


--[[ Data Structures ]]--

---Gathers all open slots (spaces) in the target container.
---@return SortSpace[]
function Sort:GetSpaces()
	local spaces = {}

	for _, bag in pairs(self.target.Bags) do
		local cache = self.target:GetBagInfo(bag)
		local family = self.target:GetBagFamily(bag)
		local locked = cache and cache.locked or Addon.None
		
		for slot = 1, self.target:NumSlots(bag) do
			if not locked[slot] then
				local item = self.target:GetItemInfo(bag, slot)
				local id = item.itemID
				if id then
					local _, _,_, level, _,_,_, stack, equip, _, _, class, subclass = C.GetItemInfo(id) 

					item.class = Search:IsQuestItem(id) and Enum.ItemClass.Questitem or class or 14
					item.set = (item.class < Enum.ItemClass.Weapon and 0) or Search:BelongsToSet(id) and 1 or 2
					item.subclass, item.equip, item.level, item.stackSize = subclass or -1, equip, level, stack
					item.family = C.GetItemFamily(id) or 0
				elseif item == Addon.None then
					item = {}
				end

				tinsert(spaces, {index = #spaces+1, bag = bag, slot = slot, family = family, item = item})
				item.space = spaces[#spaces]
			end
		end
	end

	if self.target.profile.reverseSort then
		local n = #spaces
		for i = 1, math.floor(n / 2) do
			local k = n - i + 1
			spaces[i], spaces[k] = spaces[k], spaces[i]
			spaces[i].index, spaces[k].index = i, k
		end
	end

	return spaces
end

---Returns the list of families (bag types) found in the spaces.
---@param spaces SortSpace[]
---@return integer[]
function Sort:GetFamilies(spaces)
	local set = {}
	for _, space in ipairs(spaces) do
		set[space.family] = true
	end

	local list = {}
	for family in pairs(set) do
		tinsert(list, family)
	end

	sort(list, function(a, b) return a > b and (a ~= 0x80000 or b == 0) end)
	return list
end

---Gathers items that fit in a specific family, and slots with that family.
---@param spaces SortSpace[]
---@param family integer
---@return SortItem[] order, SortSpace[] slots
function Sort:GetOrder(spaces, family)
	local order, slots = {}, {}
	local sign = family < 0

	for _, space in ipairs(spaces) do
		local item = space.item
		if item.itemID and not item.sorted and (space.family < 0) == sign and self:FitsIn(item.itemID, family) then
			tinsert(order, space.item)
		end

		if space.family == family then
			tinsert(slots, space)
		end
	end

	sort(order, self.Rule)
	return order, slots
end

---Optimizes moving items of the same ID to minimize cursor pickups.
---@param order SortItem[]
---@param spaces SortSpace[]
---@param n integer
function Sort:OptimizeOrder(order, spaces, n)
	local groups = {}
	for i = 1, n do
		local item = order[i]
		if item.itemID then
			tinsert(GetOrCreateTableEntry(GetOrCreateTableEntry(groups, item.itemID), item.stackCount or 1), i)
		end
	end

	for id, counters in pairs(groups) do
		for _, indices in pairs(counters) do
			if #indices > 1 then
				local targetSlots = {}
				for _,i in ipairs(indices) do
					targetSlots[spaces[i]] = i
				end

				local matchedItems, matchedSlots = {}, {}
				for _,i in ipairs(indices) do
					local item = order[i]
					local j = targetSlots[item.space]
					if j and not matchedSlots[j] then
						matchedItems[i] = j
						matchedSlots[j] = i
					end
				end

				local j = 0
				for _, i in ipairs(indices) do
					if not matchedItems[i] then
						while j < #indices do
							j = j + 1

							local slot = indices[j]
							if not matchedSlots[slot] then
								matchedItems[i] = slot
								matchedSlots[slot] = i
								break
							end
						end
					end
				end

				local orderedItems = {}
				for i, j in ipairs(indices) do
					orderedItems[i] = order[j]
				end

				for i, j in ipairs(indices) do
					order[matchedItems[j]] = orderedItems[i]
				end
			end
		end
	end
end


--[[ API ]]--

---Checks if sorting can run (not in combat, target is not cached, etc.).
---@return boolean
function Sort:CanRun()
	return not InCombatLockdown() and not UnitIsDead('player') and not not self.target and not self.target:IsCached()
end

---Checks if the item ID fits into a given bag family type.
---@param id integer
---@param family integer
---@return boolean
function Sort:FitsIn(id, family)
	if family == 9 then
		return C.GetItemFamily(id) == 256
	elseif family == 0x80000 then
		return select(17, C.GetItemInfo(id))
	end
	
	return family <= 0 or (bit.band(C.GetItemFamily(id), family) > 0 and select(9, C.GetItemInfo(id)) ~= 'INVTYPE_BAG')
end

---Sort comparison rule.
---@param a SortItem
---@param b SortItem
---@return boolean
function Sort.Rule(a, b)
	for _,prop in pairs(Sort.Properties) do
		if a[prop] ~= b[prop] then
			return a[prop] > b[prop]
		end
	end

	if a.space.family ~= b.space.family then
		return a.space.family > b.space.family
	end
	return a.space.index < b.space.index
end

---Moves an item from one space to another.
---@param from SortSpace
---@param to SortSpace
---@return boolean locked
function Sort:Move(from, to)
	local locked = from.item.isLocked or to.item.isLocked
	if locked or (to.item.itemID and not self:FitsIn(to.item.itemID, from.family)) then
		return not not locked
	end

	ClearCursor()
	self.target.PickupItem(from.bag, from.slot)
	self.target.PickupItem(to.bag, to.slot)

	from.item.isLocked = true
	to.item.isLocked = true
	return true
end
