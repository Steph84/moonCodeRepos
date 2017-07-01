local Map = {}


Map.TILE_SIZE = 32
local windowWidth, windowHeight
Map.mov = false

Map.myBuilding = require("mapBuilding")
Map.myScrolling = require("mapScrolling")

function Map.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  Map.myBuilding.Load(windowWidth, windowHeight, Map.TILE_SIZE)
end

function Map.Update(dt, pHero)
  Map.myScrolling.Update(dt, pHero, Map)
end

function Map.Draw()
  local lin, col
  for lin = 1, Map.myBuilding.size.h do
    for col = 1, Map.myBuilding.size.w do
      local g = Map.myBuilding.grid[lin][col]
      --love.graphics.rectangle("line", g.x, g.y, 32, 32)
      --love.graphics.print(lin..", "..col, g.x + 5, g.y + 5, 0, 0.7, 0.7)
      if g.texture == "void" and g.idText ~= 3 then
      else love.graphics.draw(Map.myBuilding.TileSheet, Map.myBuilding.tileTextures[g.idText],  g.x, g.y) end
    end
  end
end

return Map