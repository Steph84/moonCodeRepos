io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800
local windowHeight = 600
local TILE_SIZE = 32

local gameState = "menu"

local myMenu = require("menu")
local myWindowDimension = require("windowDimension")

function love.load()
  
  -- resize depending on the display dimensions
  myWindowDimension.Load()
  
  local flags = nil
  windowWidth, windowHeight, flags = love.window.getMode( )
  
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