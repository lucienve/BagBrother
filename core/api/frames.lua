--[[
	Manages frame creation and display.
	All Rights Reserved
--]]

---@type string, BagBrotherAddon
local ADDON, Addon = ...

---@class FrameRegistryEntry
---@field id string
---@field name string
---@field icon string|integer
---@field addon string|false|nil
---@field [0] table? -- Represents the created frame instance

---@class AddonFrames : AddonModule
---@field Registry FrameRegistryEntry[]
local Frames = Addon:NewModule('Frames')
Frames.Registry = {
	{id = 'inventory', name = INVENTORY_TOOLTIP, icon = 130716},
	{id = 'bank', name = BANK, icon = 'Interface/Addons/BagBrother/art/achievement-guildperk-mobilebanking', addon = ADDON..'_Bank'},
	{id = 'guild', name = GUILD_BANK, icon = 'Interface/Addons/BagBrother/art/vas-guildfactionchange', addon = GuildBankFrame_LoadUI and ADDON..'_GuildBank' or false},
	{id = 'vault', name = VOID_STORAGE, icon = 1711338, addon = VoidStorage_LoadUI and ADDON..'_VoidStorage' or false},
}


--[[ Frame Control ]]--

---Triggers UPDATE_ALL signal to update all registered frames.
function Frames:Update()
	self:SendSignal('UPDATE_ALL')
end

---Toggles the visibility of a frame by ID.
---@param id string
---@param owner? any
---@return table?
function Frames:Toggle(id, owner)
	return not self:IsShown(id) and self:Show(id, owner) or self:Hide(id)
end

---Shows a frame by ID, instantiating it if necessary.
---@param id string
---@param owner? any
---@return table?
function Frames:Show(id, owner)
	local frame = self:New(id)
	if frame then
		frame:SetOwner(owner)
		frame:Show()
	end
	return frame
end

---Hides a frame by ID.
---@param id string
---@return table
function Frames:Hide(id)
	local frame = self:Get(id)
	---@cast frame any
	if frame[0] then
		frame:Hide()
	end
	return frame
end

---Checks if a frame is shown.
---@param id string
---@return boolean
function Frames:IsShown(id)
	local frame = self:Get(id)
	---@cast frame any
	return not not (frame[0] and frame:IsShown())
end


--[[ Bag Control ]]--

---Toggles a frame associated with a bag slot.
---@param frame string
---@param bag integer
---@return table?
function Frames:ToggleBag(frame, bag)
	if self:HasBag(frame, bag) then
		return self:Toggle(frame)
	end
end

---Shows a frame associated with a bag slot.
---@param frame string
---@param bag integer
---@return table?
function Frames:ShowBag(frame, bag)
	if self:HasBag(frame, bag) then
		return self:Show(frame)
	end
end

---Hides a frame associated with a bag slot.
---@param frame string
---@param bag integer
---@return table?
function Frames:HideBag(frame, bag)
	if self:HasBag(frame, bag) then
		return self:Hide(frame)
	end
end

---Checks if the frame is enabled and has/shows the given bag.
---@param frame string
---@param bag integer
---@return boolean
function Frames:HasBag(frame, bag)
	return not (Addon.sets.displayBlizzard and Addon.player[bag].hidden) and self:IsEnabled(frame)
end


--[[ Registry ]]--

---Creates/gets the frame instance for the given ID.
---@param id string
---@return table?
function Frames:New(id)
	if self:IsEnabled(id) then
		local frame, i = self:Get(id)
		if not frame[0] and (not frame.addon or AddOnUtil.LoadAddOn(frame.addon)) then
			frame = Addon[id:gsub('^.', id.upper)]:New(frame)
	 		self.Registry[i] = frame
			return frame
		end

		return frame
 	end
end

---Gets the registry entry and its index for the given ID.
---@param id string
---@return FrameRegistryEntry, integer
function Frames:Get(id)
	local i, frame = FindInTableIf(self.Registry, function(frame) return frame.id == id end)
	return frame, i --[[@as integer]]
end

---Iterates over the registered frames.
---@return fun(t: table, i: integer): integer, FrameRegistryEntry
---@return table
---@return integer
function Frames:Iterate()
	return ipairs(self.Registry)
end

---Checks if the frame is enabled for the current character.
---@param id string
---@return boolean
function Frames:IsEnabled(id)
	local addon = self:Get(id).addon
	if addon then
		return AddOnUtil.IsAddOnEnabledForCurrentCharacter(addon)
	else
		return addon ~= false and Addon.player.profile[id].enabled
	end
end