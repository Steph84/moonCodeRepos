local Game = {}

local myCity = require("city")
local myMap = require("map")
local myControl = require("control")

local listCities = {}

local colorRed = {255, 0, 0}
local colorGreen = {0, 255, 0}
local colorBlue = {0, 0, 255}
local colorYellow = {255, 255, 0}

local Screen = "map"

function Game.Load(pGameWindowWidth, pGameWindowHeight)
  
  -- create all 4 cities
  local a = myCity.Load(1, "Atlantis")
  local b = myCity.Load(2, "Babylon")
  local c = myCity.Load(3, "Kyoto")
  local d = myCity.Load(4, "Nazca")
  
  a.X = pGameWindowWidth/4 - 32/2
  a.Y = pGameWindowHeight/4 - 32/2
  b.X = pGameWindowWidth*3/4 - 32/2
  b.Y = pGameWindowHeight/4 - 32/2
  c.X = pGameWindowWidth/4 - 32/2
  c.Y = pGameWindowHeight*3/4 - 32/2
  d.X = pGameWindowWidth*3/4 - 32/2
  d.Y = pGameWindowHeight*3/4 - 32/2
  
  a.Color = colorBlue
  b.Color = colorRed
  c.Color = colorGreen
  d.Color = colorYellow
  
  table.insert(listCities, a)
  table.insert(listCities, b)
  table.insert(listCities, c)
  table.insert(listCities, d)
  
  -- call the map
end

function Game.Update(pDt)
  -- TODO call the update functions
  -- manage the pause and the city screen
  if Screen == "map" then Screen = myControl.Update(pDt, listCities) end
  if Screen == "city" then myCity.Update(pDt) end
  
end

function Game.Draw(pGameWindowWidth, pGameWindowHeight)
  
  
  local i
  for i = 1, #listCities do
    local c = listCities[i]
    love.graphics.setColor(c.Color)
    love.graphics.rectangle("fill", c.X, c.Y, 32, 32)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(c.Name, c.X, c.Y - 20)
  end
  
  love.graphics.rectangle("fill", 0, pGameWindowHeight, pGameWindowWidth, 32)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Your city : "..listCities[1].Name, 30, pGameWindowHeight + 32/3)
  love.graphics.print("Population : "..listCities[1].Population, pGameWindowWidth/4, pGameWindowHeight + 32/3)
  love.graphics.print("Food : "..listCities[1].Food, pGameWindowWidth/2, pGameWindowHeight + 32/3)
  love.graphics.print("Treasury : "..listCities[1].Treasury, pGameWindowWidth*3/4, pGameWindowHeight + 32/3)
  
  if Screen == "city" then
    myCity.Draw(pGameWindowWidth, pGameWindowHeight)
    love.graphics.print("Residential buildings : "..listCities[1].BuildingNumber[1], 400, 210)
    love.graphics.print("Commercial buildings : "..listCities[1].BuildingNumber[2], 400, 320)
    love.graphics.print("Industrial buildings : "..listCities[1].BuildingNumber[3], 400, 430)
  end
  
end



  love.graphics.setColor(255, 255, 255)

return Game