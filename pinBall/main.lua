io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowHeight = 640 -- 32 * 20
local windowWidth = 480 -- 32 * 15

local myField = require("field")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  myField.Load(windowWidth, windowHeight)
  
end

function love.update(dt)
  myField.Update(dt, windowWidth, windowHeight)
end

function love.draw()
  myField.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end