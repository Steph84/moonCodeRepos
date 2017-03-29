local Food = {}

Food.tileSheet = {}
Food.tileTextures = {}

local tileWidth = 0
local tileHeight = 0
local listFood = {}
local targetX = 0
local targetY = 0

function createFood(pId, pX, pY)
  local item = {}
  
  item.id = pId
  item.x = pX
  item.y = pY
  item.scale = 1
  
  table.insert(listFood, item)
end

function Food.Load()
  
  -- load the pictures
  Food.tileSheet = love.graphics.newImage("pictures/food.png")
  local nbColumns = 6
  local nbLines = 1
  tileWidth = Food.tileSheet:getWidth()/nbColumns
  tileHeight = Food.tileSheet:getHeight()/nbLines
  
  -- get all the tiles in the tile sheet
  local l, c
  local id = 1
  Food.tileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    Food.tileTextures[id] = love.graphics.newQuad(
                              (c-1)*tileWidth,
                              (l-1)*tileHeight,
                              tileWidth,
                              tileHeight,
                              Food.tileSheet:getDimensions()
                              )
    id = id + 1
    end
  end
  
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    targetX = x
    targetY = y
  end
end

function Food.Update(ppDt)
  if targetX ~= 0 and targetY ~= 0 then
    createFood(#listFood + 1, targetX, targetY)
    targetX = 0
    targetY = 0
  end
end

function Food.Draw()
  local i
  for i = 1, #listFood do
    local f = listFood[i]
    love.graphics.draw(Food.tileSheet, Food.tileTextures[1], f.x, f.y)
  end
end


return Food