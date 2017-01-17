io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth
local windowHeight = 650
local screenScale = 3

myPanel = require("panel")
myLand = require("land")

function love.load()
  standardWidth = myPanel.Load()
  love.window.setMode(screenScale * standardWidth, windowHeight)
  
  myLand.Load()
  
end

function love.update(dt)

end

function love.draw()
  myPanel.Draw(windowWidth, windowHeight, screenScale)
  myLand.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end