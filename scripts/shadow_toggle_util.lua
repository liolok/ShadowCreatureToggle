local S = STRINGS.SHADOW_CREATURE_TOGGLE
local T = TUNING.SHADOW_CREATURE_TOGGLE

-- shortcut for code like `ThePlayer and ThePlayer.replica and ThePlayer.replica.inventory`
local function Get(head, ...)
  local current = head
  for _, key in ipairs({ ... }) do
    if not current then return end
    current = current[key]
  end
  return current
end

local function IsHidden(inst) return inst and Get(ThePlayer, 'need_hide_shadow') and T.SHOULD_HIDE[inst.prefab] end

local function ToggleShadowCreature(need_tip)
  if not (ThePlayer and ThePlayer.HUD) then return end
  if ThePlayer.HUD:HasInputFocus() then return end -- typing or in some menu
  if not ThePlayer:HasTag('shadowdominance') then return end

  ThePlayer.need_hide_shadow = not ThePlayer.need_hide_shadow

  if need_tip and S then -- display tip message above player character
    local tip_msg = S.SHADOW_CREATURES .. '\n' .. (ThePlayer.need_hide_shadow and S.HIDDEN or S.SHOWN)
    local time, no_animation, force = nil, true, true
    local talker = Get(ThePlayer, 'components', 'talker')
    if talker then talker:Say(tip_msg, time, no_animation, force) end
  end

  ThePlayer:PushEvent(ThePlayer.need_hide_shadow and 'HideShadow' or 'ShowShadow')
end

local function Hide(inst)
  if inst.AnimState then inst.AnimState:OverrideMultColour(1, 1, 1, 0) end
  if inst.SoundEmitter then inst.SoundEmitter:OverrideVolumeMultiplier(0) end
end

local function Show(inst)
  if inst.AnimState then inst.AnimState:OverrideMultColour(1, 1, 1, 0.4) end
  if inst.SoundEmitter then inst.SoundEmitter:OverrideVolumeMultiplier(1) end
end

local CreateIndicator = require('shadow_hidden_indicator')
local function HookShadowCreature(inst)
  inst:DoTaskInTime(0, function() -- splorange: shadows might be initialized before the player
    inst.hidden_indicator = T.ADD_HIDDEN_INDICATOR and CreateIndicator(inst) or nil
    if T.IS_ON_SANITY[inst.prefab] or not ThePlayer then return end

    if ThePlayer.need_hide_shadow then Hide(inst) end
    ThePlayer:ListenForEvent('HideShadow', function() Hide(inst) end)
    ThePlayer:ListenForEvent('ShowShadow', function() Show(inst) end)
  end)
end

local function Save(file_name, data) return SavePersistentString(file_name, DataDumper(data, nil, true)) end
local function Load(file_name)
  local result
  TheSim:GetPersistentString(file_name, function(load_success, str)
    if not (load_success and #str > 0) then return end
    local run_success, data = RunInSandboxSafe(str)
    if run_success then result = data end
  end)
  return result
end

return {
  IsHidden = IsHidden,
  ToggleShadowCreature = ToggleShadowCreature,
  HookShadowCreature = HookShadowCreature,
  Save = Save,
  Load = Load,
}
