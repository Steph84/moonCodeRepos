io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth
local windowHeight = 650
local screenScale = 3

myPanel = require("panel")

function love.load()
  standardWidth = myPanel.Load()
  
  love.window.setMode(screenScale * standardWidth, windowHeight)
  
  
end

function love.update(dt)

end

function love.draw()
  myPanel.Draw(windowWidth, windowHeight, screenScale)
    
end

function love.keypressed(key)
  
  print(key)
  
end