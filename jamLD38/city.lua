local City = {}

local plusPic, moinsPic, residentialPic, commercialPic, industrialPic

plusPic = love.graphics.newImage("pictures/plusPic.png")
moinsPic = love.graphics.newImage("pictures/moinsPic.png")
residentialPic = love.graphics.newImage("pictures/residentialPic.png")
commercialPic = love.graphics.newImage("pictures/commercialPic.png")
industrialPic = love.graphics.newImage("pictures/industrialPic.png")

local listNames = {"Atlantis", "Babylon", "Kyoto", "Nazca"}
City.listCities = {}

local colorRed = {255, 0, 0}
local colorGreen = {0, 255, 0}
local colorBlue = {0, 0, 255}
local colorYellow = {255, 255, 0}

function City.Load(pNumber, pGameWindowWidth, pGameWindowHeight)
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
  
end

function City.Update(pDt)
  -- TODO all the calculation : ratio, growth
end

function City.Draw(pGameWindowWidth, pGameWindowHeight, pScreen)
  
  local i
  for i = 1, #City.listCities do
    local c = City.listCities[i]
    love.graphics.setColor(c.Color)
    love.graphics.rectangle("fill", c.X, c.Y, 32, 32)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(c.Name, c.X, c.Y - 20)
  end
  
  love.graphics.rectangle("fill", 0, pGameWindowHeight, pGameWindowWidth, 32)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Your city : "..City.listCities[1].Name, 30, pGameWindowHeight + 32/3)
  love.graphics.print("Population : "..City.listCities[1].Population, pGameWindowWidth/4, pGameWindowHeight + 32/3)
  love.graphics.print("Food : "..City.listCities[1].Food, pGameWindowWidth/2, pGameWindowHeight + 32/3)
  love.graphics.print("Treasury : "..City.listCities[1].Treasury, pGameWindowWidth*3/4, pGameWindowHeight + 32/3)
  
  if pScreen == "city" then
  
  local cityWindowX = pGameWindowWidth*0.15
  local cityWindowY = pGameWindowHeight*0.15
  local cityWindowWidth = pGameWindowWidth*0.7
  local cityWindowHeight = pGameWindowHeight*0.7
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", pGameWindowWidth/10, pGameWindowHeight/10, pGameWindowWidth*0.8, pGameWindowHeight*0.8)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", pGameWindowWidth*0.1, pGameWindowHeight*0.1, pGameWindowWidth*0.8, pGameWindowHeight*0.8)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", pGameWindowWidth/10, pGameWindowHeight/10, pGameWindowWidth*0.8, pGameWindowHeight*0.8)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", pGameWindowWidth*0.15, pGameWindowHeight*0.15, pGameWindowWidth*0.7, pGameWindowHeight*0.7)
  
  love.graphics.print("ATLANTIS", cityWindowX + cityWindowWidth/2 - 50, cityWindowY + 50, 0, 2, 2)
  love.graphics.draw(residentialPic, cityWindowX + 50, cityWindowY + 100, 0, 2, 2)
  love.graphics.draw(commercialPic, cityWindowX + 50, cityWindowY + 200, 0, 2, 2)
  love.graphics.draw(industrialPic, cityWindowX + 50, cityWindowY + 300, 0, 2, 2)
    
  love.graphics.print("Residential buildings : "..City.listCities[1].BuildingNumber[1], 400, 210)
  love.graphics.print("Commercial buildings : "..City.listCities[1].BuildingNumber[2], 400, 320)
  love.graphics.print("Industrial buildings : "..City.listCities[1].BuildingNumber[3], 400, 430)
  end
  
end

return City