---@meta
-- core/types.lua
-- Pure metadata type definitions and whitelisted globals for BagBrother addon, parsed by LuaLS.

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
BagBrotherAddon = {}

---Registers or fetches an addon module.
---@param name string Name of the module.
---@param ... any Optional library mixes or delay providers.
---@return table module The created/fetched module table.
function BagBrotherAddon:NewModule(name, ...) end

---Initial setup hook.
function BagBrotherAddon:OnLoad() end

---Opens the configuration options UI.
function BagBrotherAddon:ShowOptions() end

-------------------------------------------------------------------------------
-- Whitelisted Global Constants (Blizzard / Game Environment)
-------------------------------------------------------------------------------
ACCEPT = ""
ACCOUNT_QUEST_LABEL = ""
ALL = ""
ALWAYS = ""
ATTACHMENTS_MAX_RECEIVE = 0
AUCTION_TIME_LEFT2 = ""
AccountBankPanel = {}
AccumulateOp = {}
AddOnUtil = {}
AddonCompartmentFrame = {}
BACKGROUND = ""
BACKPACK_CONTAINER = 0
BACKPACK_TOOLTIP = ""
BAG_FILTER_CLEANUP = ""
BAG_FILTER_REAGENTS = ""
BANK = ""
BANK_BAG = ""
BANK_BAG_PURCHASE = ""
BANK_CONTAINER = 0
BANK_MONEY_DEPOSIT_PROMPT = ""
BANK_MONEY_WITHDRAW_PROMPT = ""
BANK_TAB_DEPOSIT_ASSIGNMENTS = ""
BANK_TAB_EXPANSION_ASSIGNMENT = ""
BANK_TAB_EXPANSION_FILTER_CURRENT = ""
BANK_TAB_EXPANSION_FILTER_LEGACY = ""
BATTLE_PET_FAVORITE = ""
BATTLE_PET_UNFAVORITE = ""
BUY_GUILDBANK_TAB = ""
BackpackTokenFrame = {}
BagBrotherGuildTabEditPopup = {}
BankFrame = {}
BankFrameItemButton_OnEnter = {}
BankFramePurchaseButton = {}
BankPanel = {}
BankPanelTabSettingsMenuMixin = {}
BattlePetToolTip_Show = {}
CANCEL = ""
CHAT_LEAVE = ""
CONFIRM_BUY_ACCOUNT_BANK_TAB = ""
CONFIRM_BUY_BANK_SLOT = ""
CONFIRM_BUY_GUILDBANK_TAB = ""
CONFIRM_BUY_REAGENTBANK_TAB = ""
COPPER_PER_GOLD = 0
COPPER_PER_SILVER = 0
CURRENCY_WEEKLY_CAP = ""
CUSTOM_CLASS_COLORS = {}
CharacterBag0Slot = {}
CharacterBag1Slot = {}
CharacterBag2Slot = {}
CharacterBag3Slot = {}
CharacterFrame = {}
CharacterReagentBag0Slot = {}
ContainerFrame1 = {}
ContainerFrame2 = {}
ContainerFrameContainer = {}
ContainerFrameItemButtonMixin = {}
ContainerFrameItemButton_OnEnter = {}
ContainerFrameUtil_ConvertFilterFlagsToList = {}
CreateSimpleTextureMarkup = {}
CursorUpdate = {}
DELETE = ""
DEPOSIT = ""
DISPLAY = ""
EDIT = ""
ENTER_MACRO_LABEL = ""
EQUIPSET_EQUIP = ""
EQUIP_CONTAINER = ""
EQUIP_CONTAINER_REAGENT = ""
ERR_GUILD_PLAYER_NOT_IN_GUILD = ""
EXPANSION_NAME0 = ""
EventUtil = {}
FONT_COLOR_CODE_CLOSE = ""
FindInTable = {}
FindValueInTableIf = {}
FlagsUtil = {}
GAMEMENU_HELP = ""
GENERAL = ""
GUILDBANK_AWARD_MONEY_SUMMARY_FORMAT = ""
GUILDBANK_BUYTAB_MONEY_FORMAT = ""
GUILDBANK_DEPOSIT = ""
GUILDBANK_DEPOSIT_FORMAT = ""
GUILDBANK_DEPOSIT_MONEY_FORMAT = ""
GUILDBANK_LOG_QUANTITY = ""
GUILDBANK_MOVE_FORMAT = ""
GUILDBANK_REPAIR_MONEY_FORMAT = ""
GUILDBANK_TAB_DEPOSIT_ONLY = ""
GUILDBANK_TAB_FULL_ACCESS = ""
GUILDBANK_TAB_LOCKED = ""
GUILDBANK_TAB_NUMBER = ""
GUILDBANK_TAB_WITHDRAW_ONLY = ""
GUILDBANK_UNLOCKTAB_FORMAT = ""
GUILDBANK_WITHDRAW = ""
GUILDBANK_WITHDRAWFORTAB_MONEY_FORMAT = ""
GUILDBANK_WITHDRAW_FORMAT = ""
GUILDBANK_WITHDRAW_MONEY_FORMAT = ""
GUILDCONTROL_DEPOSIT_ITEMS = ""
GUILD_BANK = ""
GUILD_BANK_LOG = ""
GUILD_BANK_LOG_TIME = ""
GUILD_BANK_MONEY_LOG = ""
GameTooltip_HideBattlePetTooltip = {}
GameTooltip_SetTitle = {}
GetAutoCompleteRealms = {}
GetBagSlotFlag = {}
GetBankBagSlotFlag = {}
GetCraftReagentItemLink = {}
GetDenominationsFromCopper = {}
GetKeyRingSize = {}
GetKeysArray = {}
GetMoneyTypeInfoField = {}
GetMouseFocus = {}
GetNumBankSlots = {}
GetNumVoidTransferDeposit = {}
GetNumVoidTransferWithdrawal = {}
GetOrCreateTableEntry = {}
GetOrCreateTableEntryByCallback = {}
GetPairsArray = {}
GetReagentBankCost = {}
GetTradeSkillItemLink = {}
GetTradeSkillReagentItemLink = {}
GetUnscaledFrameRect = {}
function GetValueOrCallFunction(...) end
GetValuesArray = {}
GetVoidItemInfo = {}
GetVoidTransferCost = {}
GetVoidTransferDepositInfo = {}
GetVoidTransferWithdrawalInfo = {}
GuildBankFrame_LoadUI = {}
HEARTHSTONE_ITEM_ID = 0
HELP_LABEL = ""
HIGH = ""
HONOR_POINT_TEXTURES = {}
HandleModifiedItemClick = {}
HasVehicleActionBar = {}
INVENTORY_TOOLTIP = ""
INVSLOT_AMMO = 0
INVSLOT_LAST_EQUIPPED = 0
ITEMS = ""
ITEM_ACCOUNTBOUND = ""
ITEM_QUALITY_COLORS = {}
IconDataProviderExtraType = {}
IconDataProviderMixin = {}
IconSelectorPopupFrameTemplateMixin = {}
InputScrollFrame_OnLoad = {}
IsReagentBankUnlocked = {}
IsVoidStorageReady = {}
KEYRING = ""
KEYRING_CONTAINER = 0
KeyRingButton = {}
KeyRingButtonIDToInvSlotID = {}
LAYOUT_STYLE_MODERN = 0
LE_FRAME_TUTORIAL_BAG_SLOTS_AUTHENTICATOR = 0
LE_FRAME_TUTORIAL_EQUIP_REAGENT_BAG = 0
LE_FRAME_TUTORIAL_HUD_REVAMP_BAG_CHANGES = 0
LE_FRAME_TUTORIAL_MOUNT_EQUIPMENT_SLOT_FRAME = 0
LE_FRAME_TUTORIAL_UPGRADEABLE_ITEM_IN_SLOT = 0
LFG_LIST_MORE = ""
LOW = ""
MACRO = ""
MAXIMUM = ""
MAX_BUY_GUILDBANK_TABS = 0
MAX_GUILDBANK_TABS = 0
MINIMUM = ""
MONEY = ""
MainMenuBarBackpackButton = {}
MenuTemplates = {}
NEVER = ""
NEW_CAPS = ""
NEW_ITEM_ATLAS_BY_QUALITY = {}
NO = ""
NONE = ""
NORMAL_FONT_COLOR_CODE = ""
NUM_BAG_SLOTS = 0
NUM_BANKBAGSLOTS = 0
NUM_CONTAINER_FRAMES = 0
NUM_TOTAL_EQUIPPED_BAG_SLOTS = 0
OKAY = ""
OPTIONS = ""
OpenCoinPickupFrame = {}
OpenStackSplitFrame = {}
PLAYER = ""
QUESTION_MARK_ICON = 0
RAID_CLASS_COLORS = {}
REAGENTBANK_CONTAINER = 0
REAGENT_BANK = ""
ReagentBankButtonIDToInvSlotID = {}
ReagentBankFrameUnlockInfoPurchaseButton = {}
RecentTimeDate = {}
ReloadUI = {}
RunNextFrame = {}
SEARCH = ""
SELL_PRICE = ""
SOCIAL_SHARE_TEXT = ""
SOUL_SHARDS = ""
SOUNDKIT = {}
SetItemButtonCount = {}
SetItemButtonDesaturated = {}
SetItemButtonQuality = {}
SetItemButtonTexture = {}
SetItemButtonTextureVertexColor = {}
SetItemRef = {}
SetLargeGuildTabardTextures = {}
SettingsPanel = {}
ShowInspectCursor = {}
SlashCmdList = {}
StackSplitFrame = {}
TEXTURE_ITEM_QUEST_BANG = ""
TOTAL = ""
TRANSFER = ""
ToggleCharacter = {}
TooltipDataProcessor = {}
TooltipUtil = {}
TradeSkillFrame = {}
UNKNOWN = ""
UNLOCK = ""
UnlockVoidStorage = {}
VOID_STORAGE = ""
VoidStorage_LoadUI = {}
WITHDRAW = ""
YES = ""

-------------------------------------------------------------------------------
-- Custom Codebase & Addon Integrations (Pawn, Libraries, Locals)
-------------------------------------------------------------------------------
---@type function Void Storage Check function.
function CanUseVoidStorage() end

---@type function Void Storage item click helper.
function ClickVoidStorageSlot(slot) end

---@type function Void Storage withdrawal click helper.
function ClickVoidTransferWithdrawalSlot(slot) end

---@type function Executes Void Storage transfer.
function ExecuteVoidTransfer() end

---@type function Deposit reagent bank items.
function DepositReagentBank() end

---@type function Deposit bank items.
function DepositIntoBank() end

---@type function Cooldown frame setter.
function CooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate) end

---@type function Standard Lua helper/empty function.
function nop() end

---@type table Custom deposit flags table.
depositFlags = {}

---@type function Pawn addon upgrade arrow checker.
function PawnShouldItemLinkHaveUpgradeArrow(itemLink) end

---@type function Helper to generate closures.
function GenerateClosure(func, ...) end

---@type function
function BankButtonIDToInvSlotID(slot) end

-------------------------------------------------------------------------------
-- Redefined & Overloaded Types for Libs / WoW APIs
-------------------------------------------------------------------------------
---@class AceLocale-3.0
local AceLocale = {}
---@param application string
---@param locale string
---@param isDefault? boolean
---@param silent? boolean|string
---@return table<string, any>|nil
function AceLocale:NewLocale(application, locale, isDefault, silent) end

---@class Line : ScriptRegion
local Line = {}
---@param point string
---@param relativeTo ScriptRegion|number
---@param xOffset? number
---@param yOffset? number
function Line:SetStartPoint(point, relativeTo, xOffset, yOffset) end
---@param point string
---@param relativeTo ScriptRegion|number
---@param xOffset? number
---@param yOffset? number
function Line:SetEndPoint(point, relativeTo, xOffset, yOffset) end


---@class BankPanelTabSettingsMenuTemplate : Frame, CallbackRegistryMixin
---@field selectedTabData table
local BankPanelTabSettingsMenuTemplate = {}
function BankPanelTabSettingsMenuTemplate:Update() end

---@class ScrollBoxSelectorMixin : Frame, SelectorMixin

---@class UIButtonFitToTextBehaviorMixin : Button

---@class AddonSkin
---@field id string
---@field template string
---@field skin table

---@class BankPanelTabSettingsMenuMixin
---@field Event table

---@class Button
---@field menuGenerator function

---@class CheckButton
---@field SlotHighlightTexture table
---@field icon table

---@class GameTooltip : Frame

---@overload fun(self: GameTooltip, text: string, wrapText: boolean)
---@param text string
---@param r? number
---@param g? number
---@param b? number
---@param wrap? boolean
function GameTooltip:AddLine(text, r, g, b, wrap) end
