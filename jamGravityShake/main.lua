io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local Drop = require("drop")
local Splash = require("splash")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  Drop.Load(windowWidth, windowHeight)
  Splash.Load()
  
end

function love.update(dt)
  Drop.Update(dt, windowWidth, windowHeight)
  Splash.Update(dt)
end

function love.draw()
  Drop.Draw()
  Splash.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end