local Map = {}

local myControl = require("control")
local mapPic

function Map.Load()
  mapPic = love.graphics.newImage("pictures/jamLD38Map.png")
end

function Map.Update(pDt, pScreen, pListCities)
  pScreen = myControl.UpdateMap(pDt, pScreen, pListCities)
  return pScreen
end

function Map.Draw()
  love.graphics.draw(mapPic, 0, 0)
end

return Map