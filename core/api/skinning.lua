--[[
	Methods for registering frame skins.
	See https://github.com/jaliborc/BagBrother/wiki/Skins-API for details.
	All Rights Reserved
--]]

---@type string, BagBrotherAddon
local ADDON, Addon = ...

---@class AddonSkins : AddonModule
---@field Registry table<string, AddonSkin>
---@field Default string?
local Skins = Addon:NewModule('Skins', 'MutexDelay-1.0')
---@type table<string, AddonSkin>
Skins.Registry = {}

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Meta = getmetatable(UIParent).__index
local function OnError(...)
	print('|cff33ff99' .. ADDON .. '|r ' .. L.SkinError)
	geterrorhandler()(...)
end


--[[ Public API ]]--

---Registers a new skin template.
---@param skin AddonSkin
function Skins:Register(skin)
	assert(type(skin) == 'table', '#1 argument must be a table')
	assert(type(skin.id) == 'string', 'skin.id must be a string')
	assert(type(skin.template) == 'string', 'skin.template must be a string')

	self.Registry[skin.id] = skin
	self:Delay('SendSignal', 'SKINS_LOADED')
end

---@param id string
---@return AddonSkin?
function Skins:Get(id)
	if type(id) == 'string' then
		return self.Registry[id]
	end
end

---Iterates over the registered skins sorted by ID.
---@return fun(t: table, i: integer): integer, AddonSkin
---@return table
---@return integer
function Skins:Iterate()
	local skins = GetValuesArray(self.Registry)
	sort(skins, function(a, b) return a.id < b.id end)
	return ipairs(skins)
end


--[[ Object API ]]--

---Acquires/creates a skinned frame for the given skin ID and parent.
---@param id string
---@param parent Frame
---@return Frame bg
function Skins:Acquire(id, parent)
	local skin = self:Get(id) or self:Get(self.Default)
	if not skin then
		skin = { id = 'Flat', template = '', skin = {} }
	end
	if not skin[parent] then
		local _,bg = xpcall(CreateFrame, OnError, 'Frame', nil, parent, skin.template)
		skin[parent] = setmetatable(bg or CreateFrame('Frame', nil, parent), self)
	end

	local bg = skin[parent]
	bg.skin = skin
	bg:EnableMouse(true)
	bg:SetFrameLevel(0)
	bg:ClearAllPoints()
	bg:SetPoint('BOTTOMLEFT', bg.x or 0, bg.y or 0)
	bg:SetPoint('TOPRIGHT', bg.x1 or 0, bg.y1 or 0)
	bg:Show()

	return bg
end

---Evaluates a key on the skin object.
---@param self any
---@param key string
---@param ... any
function Skins:__call(key, ...)
	xpcall(GetValueOrCallFunction, OnError, self.skin, key, self, ...)
end

---Retrieves a key from the skin object, or falls back to Skins/UIParent.
---@param self any
---@param key string
---@return any
function Skins:__index(key)
	return self.skin[key] or Skins[key] or Meta[key]
end

---Releases the skin.
---@param self any
function Skins:Release()
	self('reset')
	self:Hide()
end