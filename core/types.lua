---@meta
-- core/types.lua
-- Pure metadata type definitions for BagBrother addon, parsed by LuaLS.

---@class BagBrotherAddon
---@field IsRetail boolean True if running on WoW Retail (Mainline).
---@field IsClassic boolean True if running on WoW Classic.
---@field IsModern boolean True if running on WoW Cataclysm or newer client.
---@field NumBags integer Total number of equipped bag slots.
---@field LastBankBag integer Index of the last bank bag.
---@field LastAccountBag integer Index of the last account bank bag.
---@field CurrencyLimit integer Safety tracking limit for currency.
---@field InventoryBags integer[] List of slot indexes representing player inventory bags.
---@field BankBags integer[] List of slot indexes representing bank bags.
---@field BankType integer Current bank view type (e.g. standard, reagent, etc.).
---@field Frames table Factory module for frames.
---@field GeneralOptions table Options panel module.
---@field sets table User settings/configuration table.

---Registers or fetches an addon module.
---@param name string Name of the module.
---@param ... any Optional library mixes or delay providers.
---@return table module The created/fetched module table.
function BagBrotherAddon:NewModule(name, ...) end

---Initial setup hook.
function BagBrotherAddon:OnLoad() end

---Opens the configuration options UI.
function BagBrotherAddon:ShowOptions() end
