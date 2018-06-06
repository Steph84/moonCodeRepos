io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth, windowHeight
local GameSizeCoefficient = 1
local TILE_SIZE = 32

local gameState = "game"

local myWindowDimension = require("windowDimension")
local myGame = require("game")


function love.load()
  
  -- resize depending on the display dimensions
  GameSizeCoefficient = myWindowDimension.Load()
  TILE_SIZE = TILE_SIZE * GameSizeCoefficient
  
  local flags = nil
  windowWidth, windowHeight, flags = love.window.getMode( )
  
  love.window.setTitle("my Title")
  
  myGame.Load(GameSizeCoefficient, windowWidth, windowHeight)
  
end

function love.update(dt)
  if gameState == "game" then
    gameState = myGame.Update(dt, gameState)
  end
end

function love.draw()
  if gameState == "game" then
    myGame.Draw()
  end
  if gameState == "gameOver" then
    
  end
end