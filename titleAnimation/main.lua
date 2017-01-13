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
local freeThreshold = 4
local agreThreshold = 1
local agregate = false
local gloX = 0
local gloY = 0

function createTile(pId, pSprite, pX, pY, pRotate)
  local tile = {}
  local tempRandVX = 0
  local tempRandVY = 0
  
  tempRandVX = math.random(-freeThreshold, freeThreshold)
  tempRandVY = math.random(-freeThreshold, freeThreshold)
  if tempRandVX == 0 and tempRandVY == 0 then
    while tempRandVY == tempRandVX do
      tempRandVY = math.random(-freeThreshold, freeThreshold)
    end
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
  end
  
end

function love.update(dt)
  local i
  local tempRand = 0
  
  if agregate == false then
    local sumX = 0
    local sumY = 0
    -- behaviour of the tiles
    for i = 1, numTiles do
      -- movement through the screen
      local t = list_tiles[i]
      t.x = t.x + t.vx
      t.y = t.y + t.vy
      t.rota = t.rota + t.vr
      
      sumX = sumX + t.x
      sumY = sumY + t.y
      gloX = sumX/i
      gloY = sumY/i
      
      -- sides bounce
      local upBound = 0 + t.w
      local downBound = windowHeight - t.h
      local rightBound = windowWidth - t.w
      local leftBound = 0 + t.h
      if t.y > downBound then
        tempRand = math.random(-freeThreshold, freeThreshold)
        t.y = windowHeight - t.h
        t.vy = 0 - t.vy
        t.vx = tempRand
      end
      if t.y < upBound then
        tempRand = math.random(-freeThreshold, freeThreshold)
        t.y = 0 + t.h
        t.vy = 0 - t.vy
        t.vx = tempRand
      end
      if t.x > rightBound then
        tempRand = math.random(-freeThreshold, freeThreshold)
        t.x = windowWidth - t.w
        t.vx = 0 - t.vx
        t.vy = tempRand
      end
      if t.x < leftBound then
        tempRand = math.random(-freeThreshold, freeThreshold)
        t.x = 0 + t.w
        t.vx = 0 - t.vx
        t.vy = tempRand
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
      
      sumX = sumX + t.x
      sumY = sumY + t.y
      gloX = sumX/i
      gloY = sumY/i
      
      if t.x > gloX then
        tempRand = math.random(-agreThreshold, -1)
        t.vx = tempRand
      end
      if t.x < gloX then
        tempRand = math.random(1, agreThreshold)
        t.vx = tempRand
      end
      
      if t.y > gloY then
        tempRand = math.random(-agreThreshold, -1)
        t.vy = tempRand
      end
      if t.y < gloY then
        tempRand = math.random(1, agreThreshold)
        t.vy = tempRand
      end
      
      
      -- sides bounce
      local upBound = 0 + t.w
      local downBound = windowHeight - t.h
      local rightBound = windowWidth - t.w
      local leftBound = 0 + t.h
      if t.y > downBound then
        tempRand = math.random(-agreThreshold, agreThreshold)
        t.y = windowHeight - t.h
        t.vy = 0 - t.vy
        --t.vx = 0 - t.vx
      end
      if t.y < upBound then
        tempRand = math.random(-agreThreshold, agreThreshold)
        t.y = 0 + t.h
        t.vy = 0 - t.vy
        --t.vx = 0 - t.vx
      end
      if t.x > rightBound then
        tempRand = math.random(-agreThreshold, agreThreshold)
        t.x = windowWidth - t.w
        t.vx = 0 - t.vx
        --t.vy = 0 - t.vy
      end
      if t.x < leftBound then
        tempRand = math.random(-agreThreshold, agreThreshold)
        t.x = 0 + t.w
        t.vx = 0 - t.vx
        --t.vy = 0 - t.vy
      end
      
      
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
  love.graphics.circle("fill", gloX, gloY, 10, 6)
  
end

function love.keypressed(key)
  
  print(key)
  
end