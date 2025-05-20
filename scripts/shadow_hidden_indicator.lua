return function(parent) -- OnEnableHelper(), prefabs/winona_battery_high.lua
  local circle = CreateEntity()
  circle.entity:SetParent(parent.entity)
  local tf = circle.entity:AddTransform()
  local as = circle.entity:AddAnimState()

  local x, y, z = parent.Transform:GetScale() -- credit: Huxi, 3161117403/scripts/prefabs/hrange.lua
  tf:SetScale(1 / x, 1 / y, 1 / z) -- fight against parent's scale, be absolute.

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
  as:SetOrientation(ANIM_ORIENTATION.OnGround)
  as:SetLayer(LAYER_BACKGROUND)
  as:SetSortOrder(1)

  if ThePlayer then
    if not ThePlayer.need_hide_shadow then circle:Hide() end
    ThePlayer:ListenForEvent('ShowShadow', function() circle:Hide() end)
    ThePlayer:ListenForEvent('HideShadow', function() circle:Show() end)
  end

  return circle
end
