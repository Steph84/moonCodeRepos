io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth
local windowHeight = 640
local screenScale = 3

myPanel = require("panel")
myLand = require("land")
myCharacter = require("character")

function love.load()
  standardWidth = myPanel.Load()
  windowWidth = screenScale * standardWidth -- 960
  love.window.setMode(windowWidth, windowHeight)
  myLand.Load()
  myCharacter.Load()
  
end

function love.update(dt)

end

function love.draw()
  myPanel.Draw(windowWidth, windowHeight, screenScale)
  myLand.Draw()
  myCharacter.Draw()
end
