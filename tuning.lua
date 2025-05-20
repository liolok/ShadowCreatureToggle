local SHADOW_CREATURES = { 'crawlinghorror', 'crawlingnightmare', 'terrorbeak', 'nightmarebeak', 'ruinsnightmare' }

local should_hide = {}
for _, prefab in ipairs(SHADOW_CREATURES) do
  should_hide[prefab] = true
end

local is_on_sanity = {}
for _, prefab in ipairs({ 'crawlinghorror', 'terrorbeak' }) do
  is_on_sanity[prefab] = true
end

TUNING.SHADOW_CREATURE_TOGGLE = {
  SHADOW_CREATURES = SHADOW_CREATURES,
  SHOULD_HIDE = should_hide,
  IS_ON_SANITY = is_on_sanity,
  SHOW_BUTTON_WIDGET = GetModConfigData('show_button_widget'),
  ADD_HIDDEN_INDICATOR = GetModConfigData('add_hidden_indicator'),
}
