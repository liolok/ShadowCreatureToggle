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
    local need_hide = G.ThePlayer and G.ThePlayer.need_hide_shadow
    local should_hide = self.inst.prefab and SHOULD_HIDE[self.inst.prefab]
    return (need_hide and should_hide) and 0 or OldCalculateTargetAlpha(self)
  end
end)

AddClassPostConstruct('components/combat_replica', function(self)
  local OldIsAlly = self.IsAlly
  self.IsAlly = function(self, guy, ...)
    local need_hide = G.ThePlayer and G.ThePlayer.need_hide_shadow
    local should_hide = guy.prefab and SHOULD_HIDE[guy.prefab]
    return (need_hide and should_hide) and true or OldIsAlly(self, guy, ...)
  end
end)

AddClassPostConstruct('widgets/controls', function(self)
  G.ThePlayer.need_hide_shadow = false
  self.shadowtogglewidget = self:AddChild(ShadowToggleWidget(self.owner))
  self.shadowtogglewidget:MoveToBack()
  self.shadowtogglewidget.should_show = GetModConfigData('show_button_widget')
end)

local function InGame() return G.ThePlayer and G.ThePlayer.HUD and not G.ThePlayer.HUD:HasInputFocus() end

local function Toggle()
  local player = G.ThePlayer
  if not (player and InGame() and G.TheWorld) then return end
  if not U:IsShadowCreatureNeutral() then return end
  player.need_hide_shadow = not player.need_hide_shadow
  player:PushEvent(player.need_hide_shadow and 'HideShadow' or 'ShowShadow')
  U:TipMessage(S.SHADOW_CREATURES .. '\n' .. (player.need_hide_shadow and S.HIDDEN or S.SHOWN))
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

local function CreateCircle(inst) -- OnEnableHelper(), prefabs/winona_battery_high.lua
  local circle = G.CreateEntity()
  circle.entity:SetParent(inst.entity)
  local tf = circle.entity:AddTransform()
  local as = circle.entity:AddAnimState()

  local x, y, z = inst.Transform:GetScale() -- credit: Huxi, 3161117403/scripts/prefabs/hrange.lua
  tf:SetScale(1 / x, 1 / y, 1 / z) -- fight against parent's scale, be absolute.
  -- as:SetScale(radius / 9.7, radius / 9.7) -- scale by catapult texture size

  -- credit: CarlZalph, https://forums.kleientertainment.com/forums/topic/69594-solved-how-to-make-character-glow-a-certain-color/#comment-804165
  as:SetMultColour(1, 1, 1, 1) -- erase original color
  as:SetAddColour(1, 1, 1, 1)

  circle.entity:SetCanSleep(false)
  circle.persists = false
  circle:AddTag('CLASSIFIED')
  circle:AddTag('NOCLICK')
  circle:AddTag('SHADOW_CREATURE_TOGGLE')
  as:SetBank('winona_battery_placement')
  as:SetBuild('winona_battery_placement')
  as:PlayAnimation('idle')
  as:Hide('outer')
  as:SetLightOverride(1)
  as:SetOrientation(G.ANIM_ORIENTATION.OnGround)
  as:SetLayer(G.LAYER_BACKGROUND)
  as:SetSortOrder(1)

  if not G.ThePlayer.need_hide_shadow then circle:Hide() end
  G.ThePlayer:ListenForEvent('ShowShadow', function() circle:Hide() end)
  G.ThePlayer:ListenForEvent('HideShadow', function() circle:Show() end)
  return circle
end

if GetModConfigData('add_hidden_indicator') then
  for _, prefab in ipairs(SHADOW_CREATURES) do
    AddPrefabPostInit(prefab, function(inst) -- splorange: shadows might be initialized before the player
      inst:DoTaskInTime(0, function() inst.hidden_indicator = CreateCircle(inst) end)
    end)
  end
end
