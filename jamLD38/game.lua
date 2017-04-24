local Game = {}

local myCity = require("city")
local myMap = require("map")
local myControl = require("control")

local listCities = {}

local Screen = "map"

function Game.Load(pGameWindowWidth, pGameWindowHeight)
  
  myCity.Load(4, pGameWindowWidth, pGameWindowHeight)
  
  -- call the map
end

function Game.Update(pDt)
  -- TODO call the update functions
  -- manage the pause and the city screen
  if Screen == "map" then Screen = myMap.Update(pDt, Screen, myCity.listCities) end
  if Screen == "city" then myCity.Update(pDt) end
  
end

function Game.Draw(pGameWindowWidth, pGameWindowHeight)
  
  myCity.Draw(pGameWindowWidth, pGameWindowHeight, Screen)
  
  
  
end



  love.graphics.setColor(255, 255, 255)

return Game