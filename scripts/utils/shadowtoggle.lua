local function IsWearingSkeletonHat()
  local head_item = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD or EQUIPSLOTS.HAT)
  return head_item and head_item.prefab == 'skeletonhat'
end

local function IsShadowWereWoodie() return ThePlayer:HasTag('wereplayer') and ThePlayer:HasTag('player_shadow_aligned') end

local function TipMessage(_, msg)
  local talker = ThePlayer and ThePlayer.components and ThePlayer.components.talker
  if not talker then return end
  local time, no_animation, force = nil, true, true
  talker:Say(msg, time, no_animation, force)
end

return {
  TipMessage = TipMessage,
  IsShadowCreatureNeutral = function() return IsWearingSkeletonHat() or IsShadowWereWoodie() end,
}
