io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800
local windowHeight = 600

local myLetter = require("letter")

local titleDrawing = false

function love.load()
  love.window.setMode(windowWidth, windowHeight)
  myLetter.Load(windowWidth, windowHeight)
end

function love.update(dt)
  if love.keyboard.isDown("space") then
    titleDrawing = true
  end
  myLetter.Update(dt, windowWidth, windowHeight, titleDrawing)
end

function love.draw()
  myLetter.Draw(titleDrawing)
  love.graphics.setColor(255, 255, 255)
end

function love.keypressed(key)
  
  print(key)
  
end