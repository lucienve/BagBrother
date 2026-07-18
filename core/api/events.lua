--[[
	Custom events for better item performance and location awareness.
	All Rights Reserved

	BAG_UPDATED
		deprecated and no longer fired, to avoid triggering the critical issues within CallbackHandler

	BAGS_UPDATED
	args: bags
		called whenever bag contents have been modified
		argument is a key table, where if a given bag id has changed bags[id] will be true, nil otherwise

	BANK_OPEN, BANK_CLOSE, VAULT_OPEN, VAULT_CLOSE, GUILD_OPEN, GUILD_CLOSE
		called when the player opens or closes the given storage location by interacting with the world
--]]

---@type string, BagBrotherAddon
local ADDON, Addon = ...

---@class AddonEvents : AddonModule
---@field neverBanked boolean?
---@field queue table<integer, boolean>
---@field AtBank boolean?
---@field AtVault boolean?
---@field AtGuild boolean?
local Events = Addon:NewModule('Events', 'MutexDelay-1.0')
local C = LibStub('C_Everywhere').Container


--[[ Events ]]--

---OnLoad initialization.
function Events:OnLoad()
	self.neverBanked = true
	self.queue = {}

	if C_PlayerInteractionManager then
		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW')
		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE')
	end

	if REAGENTBANK_CONTAINER then
		self:RegisterEvent('PLAYERREAGENTBANKSLOTS_CHANGED', 'QueueBag', REAGENTBANK_CONTAINER)
		self:RegisterEvent('REAGENTBANK_PURCHASED', 'QueueBag', REAGENTBANK_CONTAINER)
	end

	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('BANKFRAME_CLOSED', 'UpdateLocation', 'Bank', false)
	self:RegisterEvent('PLAYERBANKSLOTS_CHANGED', 'QueueBank')
	self:RegisterEvent('BAG_UPDATE', 'QueueBag')
	self:RegisterEvent('BAG_CLOSED', 'QueueBag')
	self:RegisterEvent('BAG_UPDATE_DELAYED', 'Delay', 0.08, 'UpdateBags')

	for _, bag in ipairs(Addon.InventoryBags) do
		self.queue[bag] = true
	end
end

---Handler for BANKFRAME_OPENED.
function Events:BANKFRAME_OPENED()
	self:UpdateLocation('Bank', true)

	if self.neverBanked then
		self.neverBanked = nil
		self:QueueBank()

		if REAGENTBANK_CONTAINER then
			self.queue[REAGENTBANK_CONTAINER] = true
		end
	end
end

---Handler for PLAYER_INTERACTION_MANAGER_FRAME_SHOW.
---@param frame number
function Events:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(frame)
	if frame == Enum.PlayerInteractionType.VoidStorageBanker then
		self:UpdateLocation('Vault', true)
	elseif frame == Enum.PlayerInteractionType.GuildBanker then
		self:UpdateLocation('Guild', true)
	end
end

---Handler for PLAYER_INTERACTION_MANAGER_FRAME_HIDE.
---@param frame number
function Events:PLAYER_INTERACTION_MANAGER_FRAME_HIDE(frame)
	if frame == Enum.PlayerInteractionType.VoidStorageBanker then
		self:UpdateLocation('Vault', false)
	elseif frame == Enum.PlayerInteractionType.GuildBanker then
		self:UpdateLocation('Guild', false)
	end
end


--[[ API ]]--

---Updates the cached state and sends open/close signal for the given location.
---@param location string
---@param state boolean
function Events:UpdateLocation(location, state)
	local key = 'At' .. location
	if self[key] ~= state then -- server can fire multiple times
		self[key] = state
		self:SendSignal(location:upper() .. (state and '_OPEN' or '_CLOSE'))
	end
end

---Fires BAGS_UPDATED and clears queue.
function Events:UpdateBags()
	self:SendSignal('BAGS_UPDATED', self.queue)
	self.queue = {}
end

---Queues all bank bags.
function Events:QueueBank()
	for i = Addon.NumBags + 1, Addon.LastBankBag do
		self.queue[i] = true
	end

	if BANK_CONTAINER then
		self:QueueBag(BANK_CONTAINER)
	end
end

---Queues a specific bag.
---@param bag integer
function Events:QueueBag(bag)
	self.queue[bag] = true
	self:Delay(0.08, 'UpdateBags')
end