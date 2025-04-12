local ShadowToggleWidget = require('widgets/shadowtogglewidget')
local shadowcreatures = { 'crawlinghorror', 'terrorbeak', 'crawlingnightmare', 'nightmarebeak' }

local buttonEnabled = GetModConfigData('buttonEnabled')

Assets = {
  Asset('ATLAS', 'images/shadowbuttonbackground.xml'),
  Asset('IMAGE', 'images/shadowbuttonbackground.tex'),
  Asset('ATLAS', 'images/shadowbuttonon.xml'),
  Asset('IMAGE', 'images/shadowbuttonon.tex'),
  Asset('ATLAS', 'images/shadowbuttonoff.xml'),
  Asset('IMAGE', 'images/shadowbuttonoff.tex'),
}

local function CheckForSkeletonHat()
  local head_item
  if GLOBAL.EQUIPSLOTS.HEAD then
    head_item = GLOBAL.ThePlayer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD)
  else
    head_item = GLOBAL.ThePlayer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HAT)
  end
  if head_item and head_item.prefab == 'skeletonhat' then
    return true
  else
    return false
  end
end

--shadows constantly change transparency, so we have to overwrite some functions so they stay invisible when they should
AddClassPostConstruct('components/transparentonsanity', function(self)
  local function PushAlpha(self, alpha, most_alpha)
    if GLOBAL.ThePlayer ~= nil and GLOBAL.ThePlayer.hasshadowsenabled == false then
      self.inst.AnimState:OverrideMultColour(1, 1, 1, 0)
      self.inst:Hide()
    else
      self.inst.AnimState:OverrideMultColour(1, 1, 1, alpha)
      if self.inst.SoundEmitter ~= nil then self.inst.SoundEmitter:OverrideVolumeMultiplier(alpha / most_alpha) end
      if self.onalphachangedfn ~= nil then self.onalphachangedfn(self.inst, alpha, most_alpha) end
    end
  end

  function self:DoUpdate(dt, force)
    self.offset = self.offset + dt
    self.target_alpha = self:CalcaulteTargetAlpha()

    if force then
      self.alpha = self.target_alpha
      PushAlpha(self, self.alpha, self.most_alpha)
    elseif self.alpha ~= self.target_alpha then
      self.alpha = self.alpha > self.target_alpha and math.max(self.target_alpha, self.alpha - dt)
        or math.min(self.target_alpha, self.alpha + dt)
      PushAlpha(self, self.alpha, self.most_alpha)
    end
  end
end)

AddClassPostConstruct('widgets/controls', function(self)
  GLOBAL.ThePlayer.hasshadowsenabled = true
  if buttonEnabled then
    self.shadowtogglewidget = self:AddChild(ShadowToggleWidget(self.owner))
    self.shadowtogglewidget:MoveToBack()

    GLOBAL.ThePlayer:ListenForEvent('TurnOnShadows', function() self.shadowtogglewidget.buttonOverlay:Show() end)
    GLOBAL.ThePlayer:ListenForEvent('TurnOffShadows', function() -- REQUIRE HELMET
      self.shadowtogglewidget.buttonOverlay:Hide()
    end)
  end
end)

local function InGame() return GLOBAL.ThePlayer and GLOBAL.ThePlayer.HUD and not GLOBAL.ThePlayer.HUD:HasInputFocus() end

if GetModConfigData('keybind') and GetModConfigData('keybind') > 0 then -- viktor code :3
  GLOBAL.TheInput:AddKeyDownHandler(GetModConfigData('keybind'), function()
    if InGame() and GLOBAL.TheWorld then
      GLOBAL.ThePlayer.hasshadowsenabled = not GLOBAL.ThePlayer.hasshadowsenabled
      if GLOBAL.ThePlayer.hasshadowsenabled == true then GLOBAL.ThePlayer:PushEvent('TurnOnShadows') end
      if GLOBAL.ThePlayer.hasshadowsenabled == false then GLOBAL.ThePlayer:PushEvent('TurnOffShadows') end
      if GLOBAL.ThePlayer and GLOBAL.ThePlayer.components and GLOBAL.ThePlayer.components.talker then
        GLOBAL.ThePlayer.components.talker:Say(
          'BHT: Shadows ' .. (GLOBAL.ThePlayer.hasshadowsenabled and 'Enabled' or 'Disabled')
        )
      end
    end
  end)
end

for i, prefab in ipairs(shadowcreatures) do
  AddPrefabPostInit(prefab, function(inst)
    inst:DoTaskInTime(0, function() --shadows might be initialized before the player
      if GLOBAL.ThePlayer.hasshadowsenabled == false then
        inst.AnimState:OverrideMultColour(1, 1, 1, 0)
        inst:Hide()
      end
      GLOBAL.ThePlayer:ListenForEvent('TurnOnShadows', function()
        inst.AnimState:OverrideMultColour(1, 1, 1, 0.4)
        inst:Show()
      end)
      GLOBAL.ThePlayer:ListenForEvent('TurnOffShadows', function()
        inst.AnimState:OverrideMultColour(1, 1, 1, 0)
        inst:Hide()
      end)
    end)
  end)
end
