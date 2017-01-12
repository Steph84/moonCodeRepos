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

local numTiles = 200
local sizeTile = 8
local threshold = 4
local agregate = false
local agreRightBound
local agreLeftBound

function createTile(pId, pSprite, pX, pY, pRotate)
  local tile = {}
  local tempRandVX = 0
  local tempRandVY = 0
  local tempRand00 = 0
  
  tempRandVX = math.random(-threshold, threshold)
  tempRandVY = math.random(-threshold, threshold)
  if tempRandVX == 0 and tempRandVY == 0 then
    print("truc")
    while tempRandVY == tempRandVX do
      tempRandVY = math.random(-threshold, threshold)
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
  
  agreRightBound = windowWidth - (windowWidth-400)/2
  agreLeftBound = (windowWidth-400)/2
  
end

function love.update(dt)
  local i
  local tempRand = 0
  
  if agregate == false then
    -- behaviour of the tiles
    for i = 1, numTiles do
      -- movement through the screen
      local t = list_tiles[i]
      t.x = t.x + t.vx
      t.y = t.y + t.vy
      t.rota = t.rota + t.vr
      
      -- sides bounce
      local upBound = 0 + t.w
      local downBound = windowHeight - t.h
      local rightBound = windowWidth - t.w
      local leftBound = 0 + t.h
      if t.y > downBound then
        tempRand = math.random(-threshold, threshold)
        t.y = windowHeight - t.h
        t.vy = 0 - t.vy
        t.vx = tempRand
      end
      if t.y < upBound then
        tempRand = math.random(-threshold, threshold)
        t.y = 0 + t.h
        t.vy = 0 - t.vy
        t.vx = tempRand
      end
      if t.x > rightBound then
        tempRand = math.random(-threshold, threshold)
        t.x = windowWidth - t.w
        t.vx = 0 - t.vx
        t.vy = tempRand
      end
      if t.x < leftBound then
        tempRand = math.random(-threshold, threshold)
        t.x = 0 + t.w
        t.vx = 0 - t.vx
        t.vy = tempRand
      end
    end
  end

  if agregate == true then
    for i = 1, numTiles do
      -- movement through the screen
      local t = list_tiles[i]
      t.x = t.x + t.vx
      t.y = t.y + t.vy
      
      if t.x > agreRightBound then
        tempRand = math.random(-threshold, threshold)
        t.x = agreRightBound
        t.vx = 0 - t.vx
        t.vy = tempRand
      end
      if t.x < agreLeftBound then
        tempRand = math.random(-threshold, threshold)
        t.x = agreLeftBound
        t.vx = 0 - t.vx
        t.vy = tempRand
        t.y = windowWidth/2 + math.sqrt(math.pow(200, 2) - math.pow((t.x - windowHeight/2), 2))
        print(t.y)
      end
      
    end
    
  end

-- y = b +- sqrt(r² - (x - a)²)

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
  
  
end

function love.keypressed(key)
  
  print(key)
  
end