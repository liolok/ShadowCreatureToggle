Assets = {
  Asset('ATLAS', 'images/shadowbuttonbackground.xml'),
  Asset('IMAGE', 'images/shadowbuttonbackground.tex'),
  Asset('ATLAS', 'images/shadowbuttonon.xml'),
  Asset('IMAGE', 'images/shadowbuttonon.tex'),
  Asset('ATLAS', 'images/shadowbuttonoff.xml'),
  Asset('IMAGE', 'images/shadowbuttonoff.tex'),
}

local G = GLOBAL
modimport('keybind') -- refine key binding UI
modimport('languages/en') -- load translation strings with English fallback
local lang = 'languages/' .. G.LOC.GetLocaleCode()
if G.kleifileexists(MODROOT .. lang .. '.lua') then modimport(lang) end
local S = G.STRINGS.SHADOW_CREATURE_TOGGLE
local ShadowToggleWidget = require('widgets/shadowtogglewidget')
local U = require('utils/shadowtoggle')

local SHADOW_CREATURES = { 'crawlinghorror', 'crawlingnightmare', 'terrorbeak', 'nightmarebeak', 'ruinsnightmare' }
local SHOULD_HIDE = {}
for _, prefab in ipairs(SHADOW_CREATURES) do
  SHOULD_HIDE[prefab] = true
end

-- splorange: shadows constantly change transparency, so we have to overwrite some functions so they stay invisible when they should
AddClassPostConstruct('components/transparentonsanity', function(self)
  local OldCalculateTargetAlpha = self.CalcaulteTargetAlpha
  self.CalcaulteTargetAlpha = function(self) -- yes, reserve typo to override.
    local is_shadow_disabled = G.ThePlayer and G.ThePlayer.is_shadow_enabled == false
    local should_hide = self.inst.prefab and SHOULD_HIDE[self.inst.prefab]
    return (is_shadow_disabled and should_hide) and 0 or OldCalculateTargetAlpha(self)
  end
end)

AddClassPostConstruct('widgets/controls', function(self)
  G.ThePlayer.is_shadow_enabled = true
  self.shadowtogglewidget = self:AddChild(ShadowToggleWidget(self.owner))
  self.shadowtogglewidget:MoveToBack()
  self.shadowtogglewidget.should_show = GetModConfigData('show_button_widget')
end)

local function InGame() return G.ThePlayer and G.ThePlayer.HUD and not G.ThePlayer.HUD:HasInputFocus() end

local function Toggle()
  local player = G.ThePlayer
  if not (player and InGame() and G.TheWorld) then return end
  if not U:IsShadowCreatureNeutral() then return end
  player.is_shadow_enabled = not player.is_shadow_enabled
  local enabled = player.is_shadow_enabled
  if enabled == true then player:PushEvent('TurnOnShadows') end
  if enabled == false then player:PushEvent('TurnOffShadows') end
  U:TipMessage(S.SHADOW_CREATURES .. '\n' .. (enabled and S.SHOWN or S.HIDDEN))
end

local handler = nil -- config name to key event handlers

function KeyBind(_, key)
  -- disable old binding
  if handler then
    handler:Remove()
    handler = nil
  end

  -- no binding
  if not key then return end

  -- new binding
  if key >= 1000 then -- it's a mouse button
    handler = G.TheInput:AddMouseButtonHandler(function(button, down, x, y)
      if button == key and down then Toggle() end
    end)
  else -- it's a keyboard key
    handler = G.TheInput:AddKeyDownHandler(key, Toggle)
  end
end

for _, prefab in ipairs(SHADOW_CREATURES) do
  AddPrefabPostInit(prefab, function(inst)
    inst:DoTaskInTime(0, function() -- splorange: shadows might be initialized before the player
      if G.ThePlayer.is_shadow_enabled == false then
        inst.AnimState:OverrideMultColour(1, 1, 1, 0)
        inst:Hide()
      end
      G.ThePlayer:ListenForEvent('TurnOnShadows', function()
        inst.AnimState:OverrideMultColour(1, 1, 1, 0.4)
        inst:Show()
      end)
      G.ThePlayer:ListenForEvent('TurnOffShadows', function()
        inst.AnimState:OverrideMultColour(1, 1, 1, 0)
        inst:Hide()
      end)
    end)
  end)
end
