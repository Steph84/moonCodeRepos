io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth
local windowHeight

local gameState = "menu"
local reload = false

local myLoadSettings = require("mainLoadSettings")
local myMenu = require("menu")

function love.load()
  
  myLoadSettings.Load()
  windowWidth = myLoadSettings.resolution[1]
  windowHeight = myLoadSettings.resolution[2]
  
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