math.randomseed(os.time()) --initialiser le random
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1000 -- default value
local windowHeight = 600 -- default value

local tile8 = love.graphics.newImage("pictures/titleTile8x8.png")
local tile32 = love.graphics.newImage("pictures/titleTile32x32.png")

local list_tiles = {}

local numTiles = 100
local sizeTile = 8

function createTile(pId, pSprite, pX, pY, pRotate)
  local tile = {}
  local tempRandVX = 0
  local tempRandVY = 0
  
  tempRandVX = math.random(-3, 3)
  tempRandVY = math.random(-3, 3)
  
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
    tempRandW = math.random(0, windowWidth)
    tempRandH = math.random(0, windowHeight)
    createTile(i, tile8, tempRandW, tempRandH, i * 20)
  end
  
end

function love.update(dt)
  local i
  local tempRand = 0
  for i = 1, numTiles do
    local t = list_tiles[i]
    t.x = t.x + t.vx
    t.y = t.y + t.vy
    t.rota = t.rota + t.vr
    
    if t.y > windowHeight - t.h then
      tempRand = math.random(-3, 3)
      t.y = windowHeight - t.h
      t.vy = 0 - t.vy
      t.vx = tempRand
    end
    
    if t.y < 0 + t.h then
      tempRand = math.random(-3, 3)
      t.y = 0 + t.h
      t.vy = 0 - t.vy
      t.vx = tempRand
    end
    
    if t.x > windowWidth - t.w then
      tempRand = math.random(-3, 3)
      t.x = windowWidth - t.w
      t.vx = 0 - t.vx
      t.vy = tempRand
    end
    
    if t.x < 0 + t.w then
      tempRand = math.random(-3, 3)
      t.x = 0 + t.w
      t.vx = 0 - t.vx
      t.vy = tempRand
    end
    
    
  end


end

function love.draw()
  --love.graphics.draw(tile8, 100, 100)
  --love.graphics.draw(tile32, 200, 200)
  local i
  for i = 1, numTiles do
    local t = list_tiles[i]
    love.graphics.draw(t.sprite, t.x, t.y, t.rota, 1, 1, t.w/2, t.h/2)
  end
  
  
end

function love.keypressed(key)
  
  print(key)
  
end