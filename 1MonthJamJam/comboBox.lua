local ComboBox = {}

ComboBox.dimensions = {}
local TILE_SIZE
local myMouse = require("mouseControl")
local myMap = {}
local myPlayer = {}

function ComboBox.Load(pMapObject, pPlayerObject)
  TILE_SIZE = pMapObject.TILE_SIZE
  
  ComboBox.dimensions.x = 0
  ComboBox.dimensions.y = 0
  ComboBox.dimensions.w = TILE_SIZE
  ComboBox.dimensions.h = 2 * TILE_SIZE
  
  ComboBox.opened = false
end

function ComboBox.Update(dt, pPlayerPosition)
  if myMouse.clicked then
    ComboBox.opened = true
    ComboBox.dimensions.x = pPlayerPosition.col * TILE_SIZE
    ComboBox.dimensions.y = pPlayerPosition.lin * TILE_SIZE
    myMouse.clicked = false
  end
end

function ComboBox.Draw()
  if ComboBox.opened == true then
    love.graphics.rectangle("fill", ComboBox.dimensions.x, ComboBox.dimensions.y, ComboBox.dimensions.w, ComboBox.dimensions.h)
  end
end

return ComboBox