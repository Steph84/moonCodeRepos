local City = {}

local plusPic, moinsPic
local srcPic = {}

plusPic = love.graphics.newImage("pictures/plusPic.png")
moinsPic = love.graphics.newImage("pictures/moinsPic.png")

srcPic[1] = love.graphics.newImage("pictures/residentialPic.png")
srcPic[2] = love.graphics.newImage("pictures/commercialPic.png")
srcPic[3] = love.graphics.newImage("pictures/industrialPic.png")

local listNames = {"Atlantis", "Babylon", "Kyoto", "Nazca"}
City.listCities = {}
City.listButtons = {}

local colorRed = {255, 0, 0}
local colorGreen = {0, 255, 0}
local colorBlue = {0, 0, 255}
local colorYellow = {255, 255, 0}

local cityWindow = {}

local cityWindowX
local cityWindowY
local cityWindowWidth
local cityWindowHeight

local timeElapsed = 0

local cityPic

local myControl = require("control")

function City.Load(pNumber, pGameWindowWidth, pGameWindowHeight)
  
  cityWindow.cityWindowX = pGameWindowWidth*0.15
  cityWindow.cityWindowY = pGameWindowHeight*0.15
  cityWindow.cityWindowWidth = pGameWindowWidth*0.7
  cityWindow.cityWindowHeight = pGameWindowHeight*0.7
    
  local i
  for i = 1, pNumber do
    local item = {}
    
    item.Id = i
    item.Name = listNames[i]
    item.Color = nil
    item.X = 0
    item.Y = 0
    item.BuildingNumber = {0, 0, 0} -- Residential, Commercial, Industrial
    item.Population = 1
    item.Food = 0
    item.Treasury = 2000
    
    table.insert(City.listCities, item)
  end
  
  City.listCities[1].X = pGameWindowWidth/4 - 32/2
  City.listCities[1].Y = pGameWindowHeight/4 - 32/2
  City.listCities[2].X = pGameWindowWidth*3/4 - 32/2
  City.listCities[2].Y = pGameWindowHeight/4 - 32/2
  City.listCities[3].X = pGameWindowWidth/4 - 32/2
  City.listCities[3].Y = pGameWindowHeight*3/4 - 32/2
  City.listCities[4].X = pGameWindowWidth*3/4 - 32/2
  City.listCities[4].Y = pGameWindowHeight*3/4 - 32/2
  
  City.listCities[1].Color = colorBlue
  City.listCities[2].Color = colorRed
  City.listCities[3].Color = colorGreen
  City.listCities[4].Color = colorYellow
  
  local j
  for j = 1, 3 do
    local button ={}
    
    button.Id = j
    button.SrcPic = srcPic[j]
    button.X = 50
    button.Y = 100
    button.Scale = 2
    
    table.insert(City.listButtons, button)
  end
  
  cityPic = love.graphics.newImage("pictures/cityPic.png")
  
end

function City.Update(pDt, pScreen)
  timeElapsed = timeElapsed + pDt
  
  -- TODO all the calculation : ratio, growth
  if pScreen == "city" then
    pScreen = myControl.UpdateButt(pDt, City.listButtons, cityWindow, City.listCities, pScreen)
  end
  
  local k
  for k = 1, #City.listCities do
    local c = City.listCities[k]
    c.Population = c.BuildingNumber[1] * 10
    
    if timeElapsed > 2 then
      c.Treasury = c.Treasury + c.Population * 5 + c.BuildingNumber[2] * 15 + c.BuildingNumber[3] * 20
      timeElapsed = 0
    end
    
  end
  return pScreen
end

function City.Draw(pGameWindowWidth, pGameWindowHeight, pScreen)
  
  -- draw cities
  local i
  for i = 1, #City.listCities do
    local c = City.listCities[i]
    love.graphics.setColor(c.Color)
    love.graphics.draw(cityPic, c.X, c.Y, 0, 1, 1)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(c.Name, c.X, c.Y - 20)
  end
  
  -- show stat for the Atlantis city
  love.graphics.rectangle("fill", 0, pGameWindowHeight, pGameWindowWidth, 32)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Your city : "..City.listCities[1].Name, 30, pGameWindowHeight + 32/3)
  love.graphics.print("Population : "..City.listCities[1].Population, pGameWindowWidth/4, pGameWindowHeight + 32/3)
  love.graphics.print("Food : "..City.listCities[1].Food, pGameWindowWidth/2, pGameWindowHeight + 32/3)
  love.graphics.print("Treasury : "..City.listCities[1].Treasury, pGameWindowWidth*3/4, pGameWindowHeight + 32/3)
  
  -- manage the city screen
  if pScreen == "city" then
    
    -- black rectangles
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", pGameWindowWidth/10, pGameWindowHeight/10, pGameWindowWidth*0.8, pGameWindowHeight*0.8)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", pGameWindowWidth*0.1, pGameWindowHeight*0.1, pGameWindowWidth*0.8, pGameWindowHeight*0.8)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", pGameWindowWidth/10, pGameWindowHeight/10, pGameWindowWidth*0.8, pGameWindowHeight*0.8)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", pGameWindowWidth*0.15, pGameWindowHeight*0.15, pGameWindowWidth*0.7, pGameWindowHeight*0.7)
    
    -- the insides of the city screen
    love.graphics.print("ATLANTIS", cityWindow.cityWindowX + cityWindow.cityWindowWidth/2 - 50, cityWindow.cityWindowY + 50, 0, 2, 2)
    love.graphics.print("Click to add building",
                        cityWindow.cityWindowX + 50,
                        cityWindow.cityWindowY + 50)
    local pic
    for pic = 1, #City.listButtons do
      local b = City.listButtons[pic]
      love.graphics.draw(b.SrcPic, cityWindow.cityWindowX + b.X, cityWindow.cityWindowY + pic*b.Y, 0, b.Scale, b.Scale)
    end
    love.graphics.print("Residential buildings : "..City.listCities[1].BuildingNumber[1], 400, 210)
    love.graphics.print("Commercial buildings : "..City.listCities[1].BuildingNumber[2], 400, 320)
    love.graphics.print("Industrial buildings : "..City.listCities[1].BuildingNumber[3], 400, 430)
    
    love.graphics.print("Esc to exit", cityWindow.cityWindowX + cityWindow.cityWindowWidth - 20, cityWindow.cityWindowY - 20)
  end
  
  
end

return City