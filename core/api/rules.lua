--[[
	Methods for creating and browsing item rulesets.
	See https://github.com/Jaliborc/BagBrother/wiki/Rules-API for details.
	All Rights Reserved
--]]


---@type string, BagBrotherAddon
local ADDON, Addon = ...
local C = LibStub('C_Everywhere')

---@class Rule : AddonRules
---@field id string
---@field title string
---@field icon (string|integer)?
---@field macro string?
---@field search string?
---@field filter function?

---@class AddonRules : AddonModule
---@field Registry table<string, Rule>
---@field GetValue function
local Rules = Addon:NewModule('Rules', 'MutexDelay-1.0')
Rules.Registry = {}


--[[ Static API ]]--

---Initial setup hook. Metatables the customRules settings list.
function Rules:OnLoad()
	for i, rule in ipairs(Addon.sets.customRules) do
		setmetatable(rule, self)
	end

	self.GetValue = GetValueOrCallFunction
	self.__index = self
end

---Registers a ruleset.
---@param data Rule
function Rules:Register(data)
	assert(type(data) == 'table', 'data must be a table')
	assert(type(data.id) == 'string', 'data.id must be a string')
	assert(type(data.title) == 'string', 'data.title must be a string')
	assert(not self.Registry[data.id], 'data.id must be unique, id already registered')

	self.Registry[data.id] = setmetatable(data, self) --[[@as Rule]]
	self:Delay('SendSignal', 'RULES_CHANGED')
end

---Unregisters a ruleset.
---@param id string
function Rules:Unregister(id)
	assert(self.Registry[id], 'id not registered')

	self.Registry[id] = nil
	self:Delay('SendSignal', 'RULES_CHANGED')
end

---Gets the ruleset by ID.
---@param id string
---@return Rule?
function Rules:Get(id)
	return self.Registry[id] or Addon.sets.customRules[id]
end

---Iterates over all registered rulesets.
---@return fun(t: table, k: string): string, Rule
---@return table
---@return any
function Rules:Iterate()
	return pairs(self.Registry)
end


--[[ Object API ]]--

---Helper to construct texture markup for a rule's icon.
---@param self Rule
---@param size integer
---@param frame table
---@return string?
function Rules:GetIconMarkup(size, frame)
	local icon, isAtlas = self:GetIcon(frame)
	return isAtlas and CreateAtlasMarkup(icon, size,size) or
			icon and CreateSimpleTextureMarkup(icon, size)
end

---Retrieves the icon texture / atlas info for the rule.
---@param self Rule
---@param frame table
---@return string|integer icon, boolean isAtlas
function Rules:GetIcon(frame)
	local icon = self:GetValue('icon', frame) or QUESTION_MARK_ICON
	return icon, C.Texture.GetAtlasExists(icon)
end

---Compiles the rule macro / search / filter function.
---@param self Rule
---@return function? compiled
function Rules:Compile()
	local macro = self.macro and loadstring(format('return function(frame, bag, slot, family, info) %s end', self.macro))
	local search = self.search and function(frame, bag, slot, _, info)
		return frame:SearchItem(self.search, bag, slot, info)
	end

	return macro and macro() or search or self.filter
end