local Food = {}

Food.products = {}
Food.listFood = {}

local tileWidth = 0
local tileHeight = 0
local targetX = 0
local targetY = 0
local avWidth = 0
local avHeight = 0

-- TODO attribute an Id and a libelle to each food to show in a prompt

function createFood(pId, pX, pY)
  local item = {}
  
  item.id = pId
  item.foodId = math.random(1, 4)
  item.x = pX
  item.y = pY
  item.scale = 0.8
  item.isHere = true -- allowing to remove it
  
  table.insert(Food.listFood, item)
end

function Food.Load()
  
  -- load the pictures
  Food.products[1] = love.graphics.newImage("pictures/apple.png")
  Food.products[2] = love.graphics.newImage("pictures/carrot.png")
  Food.products[3] = love.graphics.newImage("pictures/cheese.png")
  Food.products[4] = love.graphics.newImage("pictures/grapes.png")
  
  local widthSum = 0
  local heightSum = 0
  local i
  for i = 1, 4 do
    local t = Food.products[i]
    widthSum = widthSum + t:getWidth()
    heightSum = heightSum + t:getHeight()
  end
  avWidth = widthSum / 4 -- 36.25
  avHeight = heightSum / 4 -- 37
  
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    targetX = x
    targetY = y
  end
end

function Food.Update(ppDt, ppWindowWidth, ppWindowHeight)
  if targetX ~= 0 and targetY ~= 0 then
    createFood(#Food.listFood + 1, targetX, targetY)
    targetX = 0
    targetY = 0
  end
  
  local i
  for i = #Food.listFood, 1, -1 do
    local f = Food.listFood[i]
    f.y = f.y + 1
    if f.y > ppWindowHeight - 30 then f.y = ppWindowHeight - 29 end
    
    if f.isHere == false then table.remove(Food.listFood, i) end
    
  end
  
end

function Food.Draw()
  local i
  for i = 1, #Food.listFood do
    local f = Food.listFood[i]
    love.graphics.draw(Food.products[f.foodId], f.x, f.y, 0, f.scale, f.scale, avWidth/2, avHeight/2)
  end
end


return Food