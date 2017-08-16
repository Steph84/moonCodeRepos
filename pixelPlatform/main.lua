math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1280 -- 32x32px sprites value (40 columns)
local windowHeight = 672 -- 32x32px sprites value (21 lines)
local TILE_SIZE = 32
local coefMap = 2
local maxEnemiesNb = coefMap * coefMap - 3 - 3

local myHero = require("hero")
local myMap = require("map")
local myCombat = require("combat")
local myEnemy = require("enemy")
local myHud = require("hud")

function love.load()
  local displayWidth, displayHeight
  displayWidth, displayHeight = love.window.getDesktopDimensions()
  windowWidth = (math.floor(displayWidth/TILE_SIZE) - 2) * TILE_SIZE
  windowHeight = (math.floor(displayHeight/TILE_SIZE) - 3) * TILE_SIZE
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("PixelPlatform")
  
  myHud.Load(windowWidth, windowHeight, TILE_SIZE)
  myHero.Load(windowWidth, windowHeight, TILE_SIZE)
  myMap.Load(windowWidth, windowHeight, TILE_SIZE, coefMap)
  myCombat.Load(windowWidth, windowHeight, TILE_SIZE)
  
  local e
  for e = 1, 2 do --maxEnemiesNb do
    local tempType = 1 --math.random(1, 2)
    myEnemy.Load(e, tempType, windowWidth, windowHeight, TILE_SIZE, myMap.size)
  end
  
end

function love.update(dt)
  myHero.Update(dt)
  myMap.Update(dt, myHero)
  myEnemy.Update(dt, myMap, myHero)
  myCombat.Update(dt)
end

function love.draw()
  myMap.Draw()
  myHero.Draw()
  myEnemy.Draw()
  myHud.Draw()
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("width : "..windowWidth.." / height : "..windowHeight, 10, 10, windowWidth, "left")
  love.graphics.printf("FPS : "..love.timer.getFPS(), 0, 10, windowWidth - 10, "right")
  love.graphics.setColor(255, 255, 255)
end