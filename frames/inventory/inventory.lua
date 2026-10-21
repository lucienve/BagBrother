--[[
	A specialized version of the window frame for the inventory
	All Rights Reserved
--]]

---@type string, BagBrotherAddon
local ADDON, Addon = ...
local C = LibStub('C_Everywhere').Container

local Frame = Addon.ContainerFrame:NewClass('Inventory')
Frame.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBags
Frame.ItemGroup = Addon.InventoryItemGroup
Frame.BagButton = Addon.Bag
Frame.Bags = Addon.InventoryBags
---@type CheckButton[]
Frame.MainMenuButtons = {
	MainMenuBarBackpackButton --[[@as CheckButton]],
	CharacterBag0Slot --[[@as CheckButton]], CharacterBag1Slot --[[@as CheckButton]], CharacterBag2Slot --[[@as CheckButton]], CharacterBag3Slot --[[@as CheckButton]]
}

if KeyRingButton then
	Frame.MainMenuButtons[KEYRING_CONTAINER] = KeyRingButton
elseif CharacterReagentBag0Slot then
	tinsert(Frame.MainMenuButtons, CharacterReagentBag0Slot)
end


--[[ Main Menu ]]--

function Frame:OnShow()
	self:Super(Frame):OnShow()
	self:RegisterFrameSignal('FILTERS_CHANGED', 'HighlightMainMenu')
	self:Delay('HighlightMainMenu')
end

function Frame:OnHide()
	self:Super(Frame):OnHide()
	self:Delay('HighlightMainMenu')
end

function Frame:HighlightMainMenu()
	for i, button in pairs(self.MainMenuButtons) do
		local active = self:IsShown() and self:IsShowingBag(i-1)
		if button.SlotHighlightTexture then
			button.SlotHighlightTexture:SetShown(active)
		elseif button.icon then
			button:SetChecked(active)
		elseif active then
			button:SetButtonState('PUSHED', true)
		else
			button:SetButtonState('NORMAL')
		end
	end
end


--[[ API ]]--

function Frame:GetExtraButtons()
	return {self.profile.bagToggle and self:GetWidget('BagToggle')}
end

if C.SortBags then
	function Frame:ServerSort()
		PlaySound(SOUNDKIT.UI_BAG_SORTING_01)
		C.SortBags()
		self:SendSignal('SORTING_STATUS')
	end
end