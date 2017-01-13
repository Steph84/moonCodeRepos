math.randomseed(os.time()) --initialiser le random
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1100
local windowHeight = 600

local tile8 = love.graphics.newImage("pictures/titleTile8x8.png")
local tile16 = love.graphics.newImage("pictures/coloredBall_16x16.png")
local tile32 = love.graphics.newImage("pictures/titleTile32x32.png")

local list_tiles = {}

local numTiles = 2
local freeThreshold = 5
local agreThreshold = 1
local agregate = false
local glo1X = 0
local glo1Y = 0
local glo2X = 0
local glo2Y = 0

function createTile(pId, pSprite, pX, pY, pRotate)
  local tile = {}
  local tempRandVX = 0
  local tempRandVY = 0
  
  while tempRandVY == 0 do
    tempRandVY = math.random(-freeThreshold, freeThreshold)
  end
  while tempRandVX == 0 do
    tempRandVX = math.random(-freeThreshold, freeThreshold)
  end
  
  tile.id = pId
  tile.sprite = pSprite
  tile.x = pX
  tile.y = pY
  tile.rota = pRotate
  tile.vx = tempRandVX
  tile.vy = tempRandVY
  tile.vr = 0.1
  tile.h = pSprite:getHeight()
  tile.w = pSprite:getWidth()
  table.insert(list_tiles, tile)
  return tile
end

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  local i
  local tempRandW = 0
  local tempRandH = 0
  
  for i = 1, numTiles do
    createTile(i, tile16, windowWidth/2, windowHeight/2, i * 20)
    --createTile(i, tile8, windowWidth/2, windowHeight/2, i * 20)
  end
  
  list_tiles[1].targetX = 100
  list_tiles[1].targetY = 100
  list_tiles[2].targetX = 400
  list_tiles[2].targetY = 400
  
end

function love.update(dt)
  local i
  local tempRand = 0
  
  if agregate == false then
    local sum1X = 0
    local sum1Y = 0
    local sum2X = 0
    local sum2Y = 0
    
    -- behaviour of the tiles
    for i = 1, numTiles do
      -- movement through the screen
      local t = list_tiles[i]
      t.x = t.x + t.vx
      t.y = t.y + t.vy
      t.rota = t.rota + t.vr
      
      sum1X = sum1X + t.x
      sum1Y = sum1Y + t.y
      glo1X = sum1X/i
      glo1Y = sum1Y/i
      
      --[[
      if t.sprite == tile8 then
        sum1X = sum1X + t.x
        sum1Y = sum1Y + t.y
        glo1X = 2*sum1X/i
        glo1Y = 2*sum1Y/i
      end
      if t.sprite == tile16 then
        sum2X = sum2X + t.x
        sum2Y = sum2Y + t.y
        glo2X = 2*sum2X/i
        glo2Y = 2*sum2Y/i
      end
      --]]
      
      -- sides bounce
      local upBound = 0 + t.w
      local downBound = windowHeight - t.h
      local rightBound = windowWidth - t.w
      local leftBound = 0 + t.h
      if t.y > downBound then
        tempRand = math.random(-freeThreshold, -1)
        t.y = windowHeight - t.h
        t.vy = tempRand
      end
      if t.y < upBound then
        tempRand = math.random(1, freeThreshold)
        t.y = 0 + t.h
        t.vy = tempRand
      end
      if t.x > rightBound then
        tempRand = math.random(-freeThreshold, -1)
        t.x = windowWidth - t.w
        t.vx = tempRand
      end
      if t.x < leftBound then
        tempRand = math.random(1, freeThreshold)
        t.x = 0 + t.w
        t.vx = tempRand
      end
    end
  end

  if agregate == true then
    local sumX = 0
    local sumY = 0
    for i = 1, numTiles do
      -- movement through the screen
      local t = list_tiles[i]
      t.x = t.x + t.vx
      t.y = t.y + t.vy
      t.rota = t.rota + t.vr
      
      --if i == 1 then
        
        if t.x > t.targetX then
          t.vx = -2
        end
        if t.x < t.targetX then
          t.vx = 2
        end
        
        if t.y > t.targetY then
          t.vy = -2
        end
        if t.y < t.targetY then
          t.vy = 2
        end
      
      --end
      
      --[[
      sumX = sumX + t.x
      sumY = sumY + t.y
      glo1X = sumX/i
      glo1Y = sumY/i
      
      if t.x > glo1X then
        tempRand = math.random(-agreThreshold, -1)
        t.vx = tempRand
      end
      if t.x < glo1X then
        tempRand = math.random(1, agreThreshold)
        t.vx = tempRand
      end
      
      if t.y > glo1Y then
        tempRand = math.random(-agreThreshold, -1)
        t.vy = tempRand
      end
      if t.y < glo1Y then
        tempRand = math.random(1, agreThreshold)
        t.vy = tempRand
      end
      
      -- sides bounce
      local upBound = 0 + t.w
      local downBound = windowHeight - t.h
      local rightBound = windowWidth - t.w
      local leftBound = 0 + t.h
      if t.y > downBound then
        tempRand = math.random(-agreThreshold, -1)
        t.y = windowHeight - t.h
        t.vy = tempRand
      end
      if t.y < upBound then
        tempRand = math.random(1, agreThreshold)
        t.y = 0 + t.h
        t.vy = tempRand
      end
      if t.x > rightBound then
        tempRand = math.random(-agreThreshold, -1)
        t.x = windowWidth - t.w
        t.vx = tempRand
      end
      if t.x < leftBound then
        tempRand = math.random(1, agreThreshold)
        t.x = 0 + t.w
        t.vx = tempRand
      end--]]
      
    end
  end

  if love.keyboard.isDown("space") then
    agregate = true
  end
  
  if love.keyboard.isDown("return") then
    agregate = false
  end
  
  if love.keyboard.isDown("p") then
    agregate = nil
  end

end

function love.draw()
  
  love.graphics.setBackgroundColor(150, 150, 200)
  
  local i
  for i = 1, numTiles do
    local t = list_tiles[i]
    love.graphics.draw(t.sprite, t.x, t.y, t.rota, 1, 1, t.w/2, t.h/2)
  end
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.circle("fill", glo1X, glo1Y, 10, 6)
  
  love.graphics.setColor(0, 0, 255)
  love.graphics.circle("fill", glo2X, glo2Y, 10, 6)
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle("fill", windowWidth/2, windowHeight/2, 5)
  
  love.graphics.setColor(255, 255, 255)
end

function love.keypressed(key)
  
  print(key)
  
end