io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

Fox = require("fox")



function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  
  
end

function love.update(dt)
  Fox.Update(dt)
end

function love.draw()
  Fox.Draw()
  
end

function love.keypressed(key)
  
  print(key)
  
end