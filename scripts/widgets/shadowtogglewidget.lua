local Widget = require('widgets/widget')
local ImageButton = require('widgets/imagebutton')
local Image = require('widgets/image')
local U = require('utils/shadowtoggle')

local ShadowToggleWidget = Class(Widget, function(self, owner)
  Widget._ctor(self, 'ShadowToggleWidget')
  self.owner = owner

  self.root = self:AddChild(Widget('ROOT'))
  self.root:SetVAnchor(ANCHOR_BOTTOM)
  self.root:SetHAnchor(ANCHOR_RIGHT)
  self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
  self.root:SetPosition(0, 0, 0)

  self.bg = self.root:AddChild(Image('images/shadowbuttonbackground.xml', 'shadowbuttonbackground.tex'))

  self.bg:SetScale(0.5, 0.5, 0.5)
  self.bg:SetPosition(0, 0) --1500,120
  self.button = self.bg:AddChild(ImageButton('images/shadowbuttonoff.xml', 'shadowbuttonoff.tex'))
  self.button_overlay = self.button:AddChild(Image('images/shadowbuttonon.xml', 'shadowbuttonon.tex'))
  self.bg:MoveToBack()
  self.button.focus_scale = { 1, 1, 1 }
  self.button.move_on_click = false

  self:StartUpdating()

  self.button:SetOnClick(function()
    ThePlayer.need_hide_shadow = not ThePlayer.need_hide_shadow
    ThePlayer:PushEvent(ThePlayer.need_hide_shadow and 'HideShadow' or 'ShowShadow')
  end)
end)

function ShadowToggleWidget:OnUpdate(dt)
  if U:IsShadowCreatureNeutral() then
    if self.should_show then self.bg:Show() end
  else
    self.bg:Hide()
    if ThePlayer.need_hide_shadow then
      ThePlayer.need_hide_shadow = false
      ThePlayer:PushEvent('ShowShadow')
    end
  end
  if ThePlayer.need_hide_shadow then
    self.button_overlay:Hide()
  else
    self.button_overlay:Show()
  end

  local item = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BACK or EQUIPSLOTS.BODY)
  local is_backpack_open = item and item.replica and item.replica.container and item.replica.container._isopen
  local y = (is_backpack_open and Profile:GetIntegratedBackpack()) and 125 or 85
  self.bg:SetPosition(-280, y, 0)
end

return ShadowToggleWidget
