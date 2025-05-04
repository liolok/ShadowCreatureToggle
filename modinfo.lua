local function T(en, zh, zht) return ChooseTranslationTable({ en, zh = zh, zht = zht or zh }) end

name = T('Shadow Creature Toggle', '暗影生物开关')
author = T('splorange, liolok', 'splorange、李皓奇')
local date = '2025-05-04'
version = date .. '' -- for revision in same day
description = T(
  [[(When wearing Bone Helm, or during wereforms of Shadow Aligned Woodie)
Clicking button or press key to hide these shadow creatures:
- Crawling Horror
- Crawling Nightmare
- Terrorbeak
- Nightmarebeak
- Lurking Nightmare]],
  [[（在装备骨头头盔、或者暗影阵营伍迪变身时）
点击按钮或者按键可隐藏以下暗影生物：
- 爬行恐惧
- 爬行梦魇
- 恐怖尖喙
- 梦魇尖喙
- 潜伏梦魇]]
) .. '\n󰀰 ' .. date -- Florid Postern（绚丽之门）
api_version = 10
dst_compatible = true
client_only_mod = true
icon = 'modicon.tex'
icon_atlas = 'modicon.xml'

local keyboard = { -- from STRINGS.UI.CONTROLSSCREEN.INPUTS[1] of strings.lua, need to match constants.lua too.
  { 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'Print', 'ScrolLock', 'Pause' },
  { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' },
  { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M' },
  { 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' },
  { 'Escape', 'Tab', 'CapsLock', 'LShift', 'LCtrl', 'LSuper', 'LAlt' },
  { 'Space', 'RAlt', 'RSuper', 'RCtrl', 'RShift', 'Enter', 'Backspace' },
  { 'BackQuote', 'Minus', 'Equals', 'LeftBracket', 'RightBracket' },
  { 'Backslash', 'Semicolon', 'Quote', 'Period', 'Slash' }, -- punctuation
  { 'Up', 'Down', 'Left', 'Right', 'Insert', 'Delete', 'Home', 'End', 'PageUp', 'PageDown' }, -- navigation
}
local numpad = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'Period', 'Divide', 'Multiply', 'Minus', 'Plus' }
local mouse = { '\238\132\130', '\238\132\131', '\238\132\132' } -- Middle Mouse Button, Mouse Button 4 and 5
local key_disabled = { description = T('Disabled', '禁用'), data = 'KEY_DISABLED' }
keys = { key_disabled }
for i = 1, #mouse do
  keys[#keys + 1] = { description = mouse[i], data = mouse[i] }
end
for i = 1, #keyboard do
  for j = 1, #keyboard[i] do
    local key = keyboard[i][j]
    keys[#keys + 1] = { description = key, data = 'KEY_' .. key:upper() }
  end
  keys[#keys + 1] = key_disabled
end
for i = 1, #numpad do
  local key = numpad[i]
  keys[#keys + 1] = { description = 'Numpad ' .. key, data = 'KEY_KP_' .. key:upper() }
end

configuration_options = {
  {
    name = 'show_button_widget',
    label = T('Show Button', '显示按钮'),
    hover = T(
      'Button only shows up when wearing Bone Helm or during wereforms of Shadow Aligned Woodie.',
      '按钮仅会在装备骨头头盔或者暗影阵营伍迪变身时显示'
    ),
    options = {
      { data = true, description = T('Yes', '是') },
      { data = false, description = T('No', '否') },
    },
    default = true,
  },
  {
    name = 'keybind',
    label = T('Toggle Key', '切换按键'),
    hover = T(
      'Key only works when wearing Bone Helm or during wereforms of Shadow Aligned Woodie.',
      '按键仅会在装备骨头头盔或者暗影阵营伍迪变身时有效'
    ),
    options = keys,
    default = 'KEY_DISABLED',
  },
}
