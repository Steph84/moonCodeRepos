io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800
local windowHeight = 600

local myMapGen = require("mapGenerator")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("my Title")
  
  myMapGen.Load(windowWidth, windowHeight)
  
end

function love.update(dt)
  myMapGen.Update(dt)
end

function love.draw()
  myMapGen.Draw()
end