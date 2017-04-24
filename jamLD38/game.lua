local Game = {}

local myCity = require("city")
local myMap = require("map")
local myControl = require("control")

local listCities = {}

local Screen = "map"
local minDensity = 1000
local maxPnb = 0
local bestDensity = nil
local bestPnb = nil

function Game.Load(pGameWindowWidth, pGameWindowHeight)
  
  myCity.Load(4, pGameWindowWidth, pGameWindowHeight)
  myMap.Load()
  
end

function Game.Update(pDt, pGameState)
  
  if Screen == "map" then Screen = myMap.Update(pDt, Screen, myCity.listCities) end
  Screen, pGameState = myCity.Update(pDt, Screen, pGameState)
  
  return pGameState
end

function Game.Draw(pGameWindowWidth, pGameWindowHeight, pGameState)
  
  if pGameState == "game" then
    myMap.Draw()
    myCity.Draw(pGameWindowWidth, pGameWindowHeight, Screen)
  end
  
  if pGameState == "gameOver" then
    
    love.graphics.setColor(0, 0, 0)
    
    love.graphics.print("density population", 50, 450, 0, 1.5, 1.5)
    love.graphics.print("GDP per capita", 50, 550, 0, 1.5, 1.5)
    
    local id
    for id = 1, #myCity.listCities do
      local enum = myCity.listCities[id]
      local density = enum.Population/enum.Surface
      local PNB = enum.Treasury/enum.Population
      
      love.graphics.print(enum.Name, id * 250, 350, 0, 1.5, 1.5)
      love.graphics.print(density, id * 250, 450, 0, 1.5, 1.5)
      love.graphics.print(PNB, id * 250, 550, 0, 1.5, 1.5)
      
      if density < minDensity then
        bestDensity = enum.Name
        minDensity = density
      end
      if PNB > maxPnb then
        bestPnb = enum.Name
        maxPnb = PNB
      end
      
    end
      
      if bestDensity == bestPnb then
        love.graphics.print("The big Winner is "..bestDensity, pGameWindowWidth/2 - 200, 600, 0, 1.5, 1.5)
      end
      
      if bestDensity ~= bestPnb then
        love.graphics.print("We have 2 winners "..bestDensity.." and "..bestPnb, pGameWindowWidth/2 - 200, 600, 0, 1.5, 1.5)
      end
  end
  
end



return Game