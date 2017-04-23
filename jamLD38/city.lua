local City = {}

local plusPic, moinsPic, residentialPic, commercialPic, industrialPic

plusPic = love.graphics.newImage("pictures/plusPic.png")
moinsPic = love.graphics.newImage("pictures/moinsPic.png")
residentialPic = love.graphics.newImage("pictures/residentialPic.png")
commercialPic = love.graphics.newImage("pictures/commercialPic.png")
industrialPic = love.graphics.newImage("pictures/industrialPic.png")

function City.Load(pId, pName, pColor)
  
  local item = {}
  
  item.Id = pId
  item.Name = pName
  item.Color = nil
  item.X = 0
  item.Y = 0
  item.BuildingNumber = {0, 0, 0} -- Residential, Commercial, Industrial
  item.Population = 1
  item.Food = 0
  item.Treasury = 2000

  return item
end

function City.Update(pDt)
  -- TODO all the calculation : ratio, growth
end

function City.Draw(pGameWindowWidth, pGameWindowHeight)
  
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
  
end

return City