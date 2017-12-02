io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth, windowHeight
local GameSizeCoefficient = 1
local FONT_SIZE = 32
local TILE_SIZE = 64

local gameState = "game"

local myMenu = require("menu")
local myWindowDimension = require("windowDimension")
local myGame = require("game")

function love.load()
  
  -- resize depending on the display dimensions
  GameSizeCoefficient = myWindowDimension.Load()
  TILE_SIZE = TILE_SIZE * GameSizeCoefficient
  
  local flags = nil
  windowWidth, windowHeight, flags = love.window.getMode( )
  
  love.window.setTitle("my Title")
  
  myMenu.Load(windowWidth, windowHeight, FONT_SIZE)
  myGame.Load(windowWidth, windowHeight, TILE_SIZE)
  
end

function love.update(dt)
  
  if gameState == "menu" then
    myMenu.Update(dt)
  end
  
  if myMenu.menuState == "game" then
    gameState = "game"
    myMenu.menuState = "void"
  end
  
  if gameState == "game" then
    myMenu.menuState = myGame.Update(dt, myMenu.menuState)
  end
  
end

function love.draw()
  
  if gameState == "menu" then
    myMenu.Draw()
  end
  
  if gameState == "game" then
    myGame.Draw()
  end
  
end