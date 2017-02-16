io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local Drop = require("drop")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  Drop.Load(windowWidth, windowHeight)
  
end

function love.update(dt)
  Drop.Update(dt, windowWidth, windowHeight)
end

function love.draw()
  Drop.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end