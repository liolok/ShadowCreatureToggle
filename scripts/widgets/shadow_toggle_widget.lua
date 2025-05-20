local Widget = require('widgets/widget')
local ImageButton = require('widgets/imagebutton')
local Image = require('widgets/image')

local Util = require('shadow_toggle_util')

local ShadowToggleWidget = Class(Widget, function(self)
  Widget._ctor(self, 'ShadowToggleWidget')

  self.root = self:AddChild(Widget('ROOT'))
  self.root:SetVAnchor(ANCHOR_BOTTOM)
  self.root:SetHAnchor(ANCHOR_RIGHT)
  self.root:SetPosition(-220, 50)
  self.root:MoveToBack()
  self.bg = self.root:AddChild(Image('images/background.xml', 'background.tex'))
  self.button = self.bg:AddChild(ImageButton('images/shadow_off.xml', 'shadow_off.tex'))
  self.button_overlay = self.button:AddChild(Image('images/shadow_on.xml', 'shadow_on.tex'))

  self.button.scale_on_focus = false
  self.button.move_on_click = false
  self.button:SetOnClick(Util.ToggleShadowCreature)

  self:StartUpdating()
end)

function ShadowToggleWidget:OnUpdate()
  if not (ThePlayer and TUNING.SHADOW_CREATURE_TOGGLE) then return end

  if ThePlayer:HasTag('shadowdominance') then
    if TUNING.SHADOW_CREATURE_TOGGLE.SHOW_BUTTON_WIDGET then self.root:Show() end
  else
    self.root:Hide()
    ThePlayer.need_hide_shadow = false
    ThePlayer:PushEvent('ShowShadow')
  end

  if ThePlayer.need_hide_shadow then
    self.button_overlay:Hide()
  else
    self.button_overlay:Show()
  end
end

return ShadowToggleWidget
