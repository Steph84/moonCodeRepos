io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth, windowHeight
local GameSizeCoefficient = 1
local TILE_SIZE = 32

local gameState = "menu"

local myWindowDimension = require("windowDimension")

function love.load()
  
  -- resize depending on the display dimensions
  GameSizeCoefficient = myWindowDimension.Load()
  TILE_SIZE = TILE_SIZE * GameSizeCoefficient
  
  local flags = nil
  windowWidth, windowHeight, flags = love.window.getMode( )
  
  love.window.setTitle("my Title")
  
end

function love.update(dt)
  
  
end

function love.draw()
  
  
end