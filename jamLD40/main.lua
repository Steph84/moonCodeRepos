io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800
local windowHeight = 600
local TILE_SIZE = 32

local gameState = "menu"

local myMenu = require("menu")

function love.load()
  
  -- to adapt the window size to the display size
  local displayWidth, displayHeight
  displayWidth, displayHeight = love.window.getDesktopDimensions()
  windowWidth = (math.floor(displayWidth/TILE_SIZE) - 2) * TILE_SIZE
  windowHeight = (math.floor(displayHeight/TILE_SIZE) - 3) * TILE_SIZE
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("my Title")
  
  myMenu.Load(windowWidth, windowHeight)
  
end

function love.update(dt)
  
  if gameState == "menu" then
    myMenu.Update(dt)
  end
  
end

function love.draw()
  
  if gameState == "menu" then
    myMenu.Draw()
  end
  
end