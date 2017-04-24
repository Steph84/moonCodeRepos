local Game = {}

local myCity = require("city")
local myMap = require("map")
local myControl = require("control")

local listCities = {}

local Screen = "map"

function Game.Load(pGameWindowWidth, pGameWindowHeight)
  
  myCity.Load(4, pGameWindowWidth, pGameWindowHeight)
  myMap.Load()
  
end

function Game.Update(pDt)
  
  if Screen == "map" then Screen = myMap.Update(pDt, Screen, myCity.listCities) end
  Screen = myCity.Update(pDt, Screen)
  
end

function Game.Draw(pGameWindowWidth, pGameWindowHeight)
  
  myMap.Draw()
  myCity.Draw(pGameWindowWidth, pGameWindowHeight, Screen)
  
end



return Game