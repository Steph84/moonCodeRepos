local Fish = {}

Fish.tileSheet = {}
Fish.tileTextures = {}

local listFishes = {}

local tileWidth = 0
local tileHeight = 0

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

function createFish(pId, ppWindowWidth, ppWindowHeight)
  local item = {}
  
  item.id = pId
  item.color = math.random(1, 5)
  
  item.x = math.random(0, ppWindowWidth)
  item.y = math.random(0, ppWindowHeight)

  item.dir = 0
  while item.dir == 0 do item.dir = math.random(-1, 1) end
  
  item.vy = 0
  item.vx = item.dir *  math.random(1, 10)/10
  while item.vy == 0 do item.vy = math.random(-10, 10)/10 end
  
  item.scaleX = 0.5 * item.dir
  item.scaleY = 0.5
  
  table.insert(listFishes, item)
end


function Fish.Load(pFishNumber, pWindowWidth, pWindowHeight)
  local i
  for i = 1, pFishNumber do
    createFish(i, pWindowWidth, pWindowHeight)
  end
  
end

function Fish.Update(pDt, pWindowWidth, pWindowHeight)
  local i
  for i = #listFishes, 1, -1 do
    local f = listFishes[i]
    
    f.x = f.x + f.vx
    f.y = f.y + f.vy
    
    if f.x < 0 or f.x > pWindowWidth then
      f.vx = - f.vx
      f.dir = - f.dir
      f.scaleX = - f.scaleX
    end
    
    if f.y < 0 or f.y > pWindowHeight then f.vy = - f.vy end
    
    
    
  end
  
end

function Fish.Draw()
  local i
  for i = 1, #listFishes do
    local f = listFishes[i]
    love.graphics.draw(Fish.tileSheet, Fish.tileTextures[f.color], f.x, f.y, 0, f.scaleX, f.scaleY, tileWidth/2, tileHeight/2)
  end
end

return Fish