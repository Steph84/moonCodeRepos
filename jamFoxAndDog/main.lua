io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1000
local windowHeight
local bgW, bgH

Fox = require("fox")
Dog = require("dog")

local rectDepth = 50
local ratio = 1

function love.load()
  bgPic = love.graphics.newImage("pictures/background.png")
  bgW = bgPic:getWidth()
  bgH = bgPic:getHeight()
  
  ratio = bgW/windowWidth
  windowHeight = bgH/ratio
  
  love.window.setMode(windowWidth, windowHeight)
  Fox.Load(windowHeight, windowWidth, rectDepth)
  Dog.Load(windowHeight, rectDepth)
  
end

function love.update(dt)
  Fox.Update(dt, windowWidth, windowHeight)
  Dog.Update(dt, windowWidth)
end

function love.draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(bgPic, 0, 0, 0, 1/ratio, 1/ratio)
  Fox.Draw()
  Dog.Draw()
  
end
