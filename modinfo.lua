name = 'Bone Helm Shadow Toggle'
--The name of your mod
description = 'Allows you to turn off shadows once you equip the bone helm'
--The description that shows when you are selecting the mod from the list
author = 'splorange'
--Your name!
version = '1.1'

forumthread = ''

icon_atlas = 'modicon.xml'

icon = 'modicon.tex'

dst_compatible = true
forge_compatible = true
gorge_compatible = true

dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

all_clients_require_mod = false
server_only_mod = false
client_only_mod = true

api_version = 10
--This is the version of the game's API and should stay the same for the most part

local Keys = {
  { description = 'None --', data = -1 }, -- If players can't find the None option
  { description = 'Numpad Zero', data = 256 },
  { description = 'Numpad One', data = 257 },
  { description = 'Numpad Two', data = 258 },
  { description = 'Numpad Three', data = 259 },
  { description = 'Numpad Four', data = 260 },
  { description = 'Numpad Five', data = 261 },
  { description = 'Numpad Six', data = 262 },
  { description = 'Numpad Seven', data = 263 },
  { description = 'Numpad Eight', data = 264 },
  { description = 'Numpad Nine', data = 265 },
  { description = 'Numpad Period', data = 266 },
  { description = 'Numpad Divide', data = 267 },
  { description = 'Numpad Multiply', data = 268 },
  { description = 'Numpad Minus', data = 269 },
  { description = 'Numpad Plus', data = 270 },
  --	{description = "Numpad Enter", data = 271},
  --	{description = "Numpad Equals", data = 272},
  { description = 'Up', data = 273 },
  { description = 'Down', data = 274 },
  { description = 'Left', data = 276 },
  { description = 'Right', data = 275 },
  { description = 'Minus', data = 45 },
  { description = 'Plus', data = 43 },
  { description = 'LeftBracket', data = 91 },
  { description = 'RightBracket', data = 93 },
  { description = 'Semicolon', data = 59 },
  { description = 'Quote', data = 39 },
  { description = 'Comma', data = 44 },
  { description = 'Period', data = 46 },
  { description = 'Slash', data = 47 },
  { description = 'PageUp', data = 280 },
  { description = 'PageDown', data = 281 },
  { description = 'Home', data = 278 },
  { description = 'End', data = 279 },
  { description = 'Insert', data = 277 },
  { description = 'Delete', data = 127 },
  { description = '-- None --', data = 0 }, -- Placing none here could help others to set up their keys
  { description = 'A', data = 97 },
  { description = 'B', data = 98 },
  { description = 'C', data = 99 },
  { description = 'D', data = 100 },
  { description = 'E', data = 101 },
  { description = 'F', data = 102 },
  { description = 'G', data = 103 },
  { description = 'H', data = 104 },
  { description = 'I', data = 105 },
  { description = 'J', data = 106 },
  { description = 'K', data = 107 },
  { description = 'L', data = 108 },
  { description = 'M', data = 109 },
  { description = 'N', data = 110 },
  { description = 'O', data = 111 },
  { description = 'P', data = 112 },
  { description = 'Q', data = 113 },
  { description = 'R', data = 114 },
  { description = 'S', data = 115 },
  { description = 'T', data = 116 },
  { description = 'U', data = 117 },
  { description = 'V', data = 118 },
  { description = 'W', data = 119 },
  { description = 'X', data = 120 },
  { description = 'Y', data = 121 },
  { description = 'Z', data = 122 },
  { description = 'F1', data = 282 },
  { description = 'F2', data = 283 },
  { description = 'F3', data = 284 },
  { description = 'F4', data = 285 },
  { description = 'F5', data = 286 },
  { description = 'F6', data = 287 },
  { description = 'F7', data = 288 },
  { description = 'F8', data = 289 },
  { description = 'F9', data = 290 },
  { description = 'F10', data = 291 },
  { description = 'F11', data = 292 },
  { description = 'F12', data = 293 },
  { description = '-- None', data = -1 }, -- To avoid forcing players to click all the way back to the beginning
}

configuration_options = {
  {
    name = 'buttonEnabled',
    label = 'Button Enabled',
    options = {
      { description = 'Yes', data = true },
      { description = 'No', data = false },
    },
    default = true,
  },
  {
    name = 'keybind',
    label = 'Keybind',
    options = Keys,
    default = 0,
  },
}
