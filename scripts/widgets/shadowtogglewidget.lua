local Widget = require('widgets/widget')
local ImageButton = require('widgets/imagebutton')
local Image = require('widgets/image')

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
  if EQUIPSLOTS.HEAD then
    head_item = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
  else
    head_item = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HAT)
  end
  if head_item and head_item.prefab == 'skeletonhat' then
    return true
  else
    return false
  end
end

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
  self.buttonOverlay = self.button:AddChild(Image('images/shadowbuttonon.xml', 'shadowbuttonon.tex'))
  self.bg:MoveToBack()
  self.button.focus_scale = { 1, 1, 1 }
  self.button.move_on_click = false

  self:StartUpdating()

  self.button:SetOnClick(function() self:OnClickButton() end)
end)

function ShadowToggleWidget:OnClickButton()
  ThePlayer.hasshadowsenabled = not ThePlayer.hasshadowsenabled
  if ThePlayer.hasshadowsenabled == true then ThePlayer:PushEvent('TurnOnShadows') end
  if ThePlayer.hasshadowsenabled == false then ThePlayer:PushEvent('TurnOffShadows') end
end

function ShadowToggleWidget:OnUpdate(dt)
  if CheckForSkeletonHat() == true then
    self.bg:Show()
  else
    self.bg:Hide()
    if ThePlayer.hasshadowsenabled == false then
      ThePlayer.hasshadowsenabled = true
      ThePlayer:PushEvent('TurnOnShadows')
      self.buttonOverlay:Show()
    end
  end

  local item = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BACK or EQUIPSLOTS.BODY)
  local is_backpack_open = item and item.replica and item.replica.container and item.replica.container._isopen
  local y = (is_backpack_open and Profile:GetIntegratedBackpack()) and 125 or 85
  self.bg:SetPosition(-280, y, 0)
end

return ShadowToggleWidget
