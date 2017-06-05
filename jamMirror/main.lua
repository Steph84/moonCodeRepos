math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth, windowHeight

local gameState = "menu"

local myParallax = require("parallaxAnimation")
local myMenu = require("menu")
local myGame = require("game")

local timeElpased = 0
local drawParallax, drawMenu = true, false

function love.load()
  
  love.window.setFullscreen(true)
  windowWidth, windowHeight = love.graphics.getDimensions()
  love.window.setTitle("Into the Mirror")
  
  myParallax.Load(windowWidth, windowHeight)
  myMenu.Load(windowWidth, windowHeight)
  myGame.load(windowWidth, windowHeight)
  
end

function love.update(dt)
  
  if gameState == "menu" then
    
    if myMenu.menuState == "title" then
      drawParallax = true
    else drawParallax = false
    end
    
    if myParallax.fullSpeed == true then
      timeElpased = timeElpased + dt
      if timeElpased > 2 then
        drawMenu = true
      end
    end
    
    if drawParallax == true then myParallax.Update(dt) end
    if drawMenu == true then myMenu.Update(dt) end
    
    if myMenu.menuState == "game" then gameState = "game" end
  end
  
  if gameState == "game" then
    gameState = myGame.Update(dt, gameState)
  end
  
end

function love.draw()
  
  if gameState == "menu" then
    if drawParallax == true then myParallax.Draw() end
    if drawMenu == true then myMenu.Draw() end
  else 
    drawMenu = false
    drawParallax = false
  end
  
  if gameState == "game" then
    myGame.Draw()
  end
  
end