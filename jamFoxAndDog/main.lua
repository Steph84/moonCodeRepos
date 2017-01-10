io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1000 -- default value
local windowHeight = 400 -- default value

Fox = require("fox")

local rectDepth = 50


function love.load()
  love.window.setMode(windowWidth, windowHeight)
  Fox.Load(windowHeight)
  
end

function love.update(dt)
  Fox.Update(dt, windowWidth, windowHeight)
end

function love.draw()
  love.graphics.setColor(255, 255, 255)
  Fox.Draw(windowHeight)
  
  love.graphics.setColor(0, 100, 0)
  love.graphics.rectangle("fill", 0, windowHeight - rectDepth, windowWidth, rectDepth)
end

function love.keypressed(key)
  
  print(key)
  
end