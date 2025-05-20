local lc = GLOBAL.LOC.GetLocaleCode() -- Translation
modimport('lang/' .. (GLOBAL.kleifileexists(MODROOT .. 'lang/' .. lc .. '.lua') and lc or 'en'))
modimport('tuning') -- Constant and Configuration
local T = TUNING.SHADOW_CREATURE_TOGGLE
local U = require('shadow_toggle_util') -- Utility

-- Shadow Creatures: Hide and Mute
for _, prefab in ipairs(T.SHADOW_CREATURES) do
  AddPrefabPostInit(prefab, U.HookShadowCreature)
end

-- Keep Hidden "Sanity Monsters" Totally Transparent and Muted
AddClassPostConstruct('components/transparentonsanity', function(self)
  local OldCalculateTargetAlpha = self.CalcaulteTargetAlpha -- yes, reserve typo to override.
  self.CalcaulteTargetAlpha = function(self) return U.IsHidden(self.inst) and 0 or OldCalculateTargetAlpha(self) end
end)

-- Keep Hidden Shadow Creatures from Targeted by Force Attack
AddClassPostConstruct('components/combat_replica', function(self)
  local OldIsAlly = self.IsAlly
  self.IsAlly = function(self, guy, ...) return U.IsHidden(guy) and true or OldIsAlly(self, guy, ...) end
end)

-- Add Button Widget
Assets = {
  Asset('IMAGE', 'images/background.tex'),
  Asset('ATLAS', 'images/background.xml'),
  Asset('IMAGE', 'images/shadow_off.tex'),
  Asset('ATLAS', 'images/shadow_off.xml'),
  Asset('IMAGE', 'images/shadow_on.tex'),
  Asset('ATLAS', 'images/shadow_on.xml'),
}
local ShadowToggleWidget = require('widgets/shadow_toggle_widget')
AddClassPostConstruct('widgets/controls', function(self) self:AddChild(ShadowToggleWidget()) end)

-- Toggle Key
modimport('keybind') -- refine key binding UI
local Input = GLOBAL.TheInput
local handler = nil -- key event handler
function KeyBind(_, key)
  if handler then handler:Remove() end -- disable old binding, re-add handler if new key assigned.
  local function f(_key, down) return (_key == key and down) and U.ToggleShadowCreature(true) end
  handler = key and (key >= 1000 and Input:AddMouseButtonHandler(f) or Input:AddKeyHandler(f))
end
