local ComboBox = {}

ComboBox.dimensions = {}
local TILE_SIZE
local myMap = {}
local myPlayer = {}

function ComboBox.Load(pTileSize)
  TILE_SIZE = pTileSize
  
  ComboBox.dimensions.x = 0
  ComboBox.dimensions.y = 0
  ComboBox.dimensions.w = TILE_SIZE
  ComboBox.dimensions.h = 2 * TILE_SIZE
  
  ComboBox.opened = false
end

function ComboBox.Update(dt)
  
end

function ComboBox.Draw()
  if ComboBox.opened == true then
    love.graphics.rectangle("fill", ComboBox.dimensions.x, ComboBox.dimensions.y, ComboBox.dimensions.w, ComboBox.dimensions.h)
  end
end

return ComboBox