local Fish = {}

Fish.tileSheet = {}
Fish.tileTextures = {}

local listFishes = {}

local tileWidth = 0
local tileHeight = 0

local areaTarget = 100
local speedTarget = 1

-- load the pictures
Fish.tileSheet = love.graphics.newImage("pictures/color_fish.png")
local nbColumns = 1
local nbLines = 5
tileWidth = Fish.tileSheet:getWidth()/nbColumns
tileHeight = Fish.tileSheet:getHeight()/nbLines

-- get all the tiles in the tile sheet
local l, c
local id = 1
Fish.tileTextures[0] = nil
for l = 1, nbLines do
  for c = 1, nbColumns do
  Fish.tileTextures[id] = love.graphics.newQuad(
                            (c-1)*tileWidth,
                            (l-1)*tileHeight,
                            tileWidth,
                            tileHeight,
                            Fish.tileSheet:getDimensions()
                            )
  id = id + 1
  end
end

local myFood = require("food")

function createFish(pId, ppWindowWidth, ppWindowHeight)
  local item = {}
  
  item.id = pId
  item.color = math.random(1, 5)
  
  item.x = math.random(100, ppWindowWidth - 100)
  item.y = math.random(100, ppWindowHeight - 100)

  item.dir = 0
  while item.dir == 0 do item.dir = math.random(-1, 1) end
  
  item.vy = 0
  item.vx = item.dir *  math.random(1, 10)/10
  while item.vy == 0 do item.vy = math.random(-10, 10)/10 end
  
  item.scaleX = 0.2 * item.dir
  item.scaleY = 0.2
  
  item.targetOn = false
  item.targetX = nil
  item.targetY = nil
  
  table.insert(listFishes, item)
end


function Fish.Load(pFishNumber, pWindowWidth, pWindowHeight)
  local i
  for i = 1, pFishNumber do
    createFish(i, pWindowWidth, pWindowHeight)
  end
  
  myFood.Load()
  
end

function Fish.Update(pDt, pWindowWidth, pWindowHeight)
  local i
  for i = #listFishes, 1, -1 do
    local f = listFishes[i]
    
    if f.targetOn == false then
      f.x = f.x + f.vx
      f.y = f.y + f.vy
      
      if f.x < 0 or f.x > pWindowWidth then
        f.vx = - f.vx
        f.dir = - f.dir
        f.scaleX = - f.scaleX
      end
      
      if f.y < 0 or f.y > pWindowHeight then f.vy = - f.vy end
      
      local j
      for j = #myFood.listFood, 1, -1 do
        local g = myFood.listFood[j]
        if f.x > g.x - areaTarget and f.x < g.x + areaTarget then
          if f.y > g.y - areaTarget and f.y < g.y + areaTarget then 
            f.targetX = g.x
            f.targetY = g.y
            f.targetOn = true
          end
        end
      end
    end
    
    if f.targetOn == true then
      
      f.x = f.x + f.vx
      f.y = f.y + f.vy
      
      local tempRatio = math.abs((f.targetY - f.y)/(f.targetX - f.x))
      
      -- glut to avoid the zero division : nan !!
      -- otherwise, particules simply will disapear
      if tempRatio > 2 then
        tempRatio = 2
      end
      
      -- each particule are going to their target
      if f.x > (f.targetX) then f.vx = -speedTarget end
      if f.x < (f.targetX) then f.vx = speedTarget end
      if f.y > (f.targetY) then f.vy = -speedTarget*tempRatio end
      if f.y < (f.targetY) then f.vy = speedTarget*tempRatio end
      
      if f.x < (f.targetX + 3) and
         f.x > (f.targetX - 3) and
         f.y < (f.targetY + 3) and
         f.y > (f.targetY - 3) then
           f.targetOn = false
           
      end
      
      local j
      for j = #myFood.listFood, 1, -1 do
        local g = myFood.listFood[j]
        f.targetX = g.x
        f.targetY = g.y
      end
      
      
    end
    
  end
  
  myFood.Update(pDt, pWindowWidth, pWindowHeight)
  
end

function Fish.Draw()
  local i
  for i = 1, #listFishes do
    local f = listFishes[i]
    love.graphics.draw(Fish.tileSheet, Fish.tileTextures[f.color], f.x, f.y, 0, f.scaleX, f.scaleY, tileWidth/2, tileHeight/2)
    love.graphics.print(i, f.x + 5, f.y + 5)
    love.graphics.circle("line", f.x, f.y, areaTarget)
    love.graphics.circle("fill", f.x, f.y, 10)
    if #myFood.listFood > 0 then love.graphics.circle("fill", myFood.listFood[1].x, myFood.listFood[1].y, 10) end
  end
  
  
  myFood.Draw()
  
end

return Fish