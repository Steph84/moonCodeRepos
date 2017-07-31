io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth, windowHeight
local TILE_SIZE = 32

local gameState = "menu"

local myMenu = require("menu")
local myGame = require("game")
local myGameTrans = require("gameTrans")
local myEndAnimation = require("endAnim")

function love.load()
  
  -- determine and set the right values for the window size
  local displayWidth, displayHeight
  displayWidth, displayHeight = love.window.getDesktopDimensions()
  windowWidth = (math.floor(displayWidth/TILE_SIZE) - 2) * TILE_SIZE
  windowHeight = (math.floor(displayHeight/TILE_SIZE) - 3) * TILE_SIZE
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("LD39 - Running Out Of Power")
  
  myMenu.Load(windowWidth, windowHeight)
  myGame.Load(windowWidth, windowHeight, TILE_SIZE)
  myGameTrans.Load(windowWidth, windowHeight)
  myEndAnimation.Load(windowWidth, windowHeight)
  
end

function love.update(dt)
  
  if gameState == "menu" then
    myMenu.Update(dt)
  end
  
  if myMenu.menuState == "game" then
    gameState = "gameTrans"
    myMenu.menuState = "void"
  end
  
  if gameState == "gameTrans" then
    gameState = myGameTrans.Update(dt, gameState)
  end
  
  if gameState == "game" then
    myMenu.menuState = myGame.Update(dt, myMenu.menuState)
  end
  
  if myMenu.menuState == "win" or myMenu.menuState == "lose" then
    gameState = "endAnimation"
  end
  
  if gameState == "endAnimation" then
    myEndAnimation.Update(dt, myMenu.menuState)
  end
  
end

function love.draw()
  
  if gameState == "menu" then
    myMenu.Draw()
  end
  
  if gameState == "gameTrans" then
    myGameTrans.Draw()
  end
  
  if gameState == "game" then
    myGame.Draw()
  end
  
  if gameState == "endAnimation" then
    myEndAnimation.Draw()
  end
  
end