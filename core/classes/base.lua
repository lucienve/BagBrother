--[[
	Abstract class that all others derive from.
	All Rights Reserved
--]]

---@type string, BagBrotherAddon
local ADDON, Addon = ...

---@class Base : Frame, AddonModule
---@field Scripts string[]
---@field __autoScript function?
---@field Super fun(self: table, class: table): table
---@field GetFrameID fun(self: table): string
---@field GetClassName fun(self: table): string
local Base = Addon:NewModule('Base', LibStub('Poncho-2.0')(), 'MutexDelay-1.0') --[[@as Base]]

Base.Scripts = {
	'OnShow', 'OnHide',
	'OnEnter', 'OnLeave',
	'OnDragStart', 'OnReceiveDrag',
	'OnMouseDown', 'OnMouseUp', 'OnMouseWheel',
	'OnClick', 'PostClick', 'PreClick', 'OnDoubleClick', 'OnHyperlinkClick',
	'OnSizeChanged', 'OnTextChanged', 'OnEscapePressed', 'OnEnterPressed',
}

---Creates a new class inheriting from Base.
---@param name string
---@param type? string
---@param template? string|boolean
---@param global? boolean
---@return table
function Base:NewClass(name, type, template, global)
	local class = self:Super(Base):NewClass(type, (global or self:GetClassName()) and (ADDON .. name), template == true and (ADDON .. name .. 'Template') or template)
	Addon[name] = class
	return class
end

---Constructs the frame instance for the class.
---@return Frame
function Base:Construct()
	local f = self:Super(Base):Construct()
	f:Hide()

	local autoScript = rawget(self, '__autoScript')
	if not autoScript then
		local chunks = {}
		for _, event in ipairs(self.Scripts) do
			if self[event] then
				tinsert(chunks, format('f:SetScript(%q, f[%q])', event, event))
			end
		end

		autoScript = #chunks > 0 and loadstring('return function(f)\n' .. table.concat(chunks, '\n') .. '\nend')() or nop
		self.__autoScript = autoScript
	end
	
	autoScript(f)
	return f
end

---Registers a frame signal event listener.
---@param event string
---@param call? string|function
---@param ... any
function Base:RegisterFrameSignal(event, call, ...)
	self:RegisterSignal(self:GetFrameID() .. '.' .. event, call or event, ...)
end

---Unregisters a frame signal event listener.
---@param event string
function Base:UnregisterFrameSignal(event)
	self:UnregisterSignal(self:GetFrameID() .. '.' .. event)
end

---Sends a frame signal event.
---@param event string
---@param ... any
function Base:SendFrameSignal(event, ...)
	self:SendSignal(self:GetFrameID() .. '.' .. event, ...)
end

---Checks if the frame is positioned on the far right of the screen.
---@return boolean
function Base:IsFarRight()
	return self:GetRight() > (GetScreenWidth() / self:GetEffectiveScale() / 2)
end