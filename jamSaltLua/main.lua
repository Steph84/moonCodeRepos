math.randomseed(os.time()) --initialiser le random
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300
local windowHeight = 675

local whiteColor = {255, 255, 255}
local green1Color = {128, 255, 0}
local green2Color = {0, 255, 0}
local green3Color = {0, 255, 128}
local green4Color = {0, 102, 0}
local redColor = {255, 0, 0}

local blanket = {}

local myRiver = require("river")
local myColor = require("color")

function love.load()
  love.window.setMode(windowWidth, windowHeight)
  
  -- initialize the blanket
  blanket.w = math.random(200, 400)
  blanket.h = 100
  blanket.x = math.random(50, windowWidth - blanket.w - 50)
  blanket.y = 0
  
  myRiver.Load(windowWidth, windowHeight)
  
end

function love.update(dt)
  myRiver.Update(dt, windowWidth, windowHeight)
end

function love.draw()
  love.graphics.setBackgroundColor(green4Color)
  
  -- draw the blanket
  love.graphics.setColor(redColor)
  love.graphics.rectangle("fill", blanket.x, blanket.y, blanket.w, blanket.h)
  love.graphics.setColor(whiteColor)
  love.graphics.rectangle("fill", blanket.x + 5, blanket.y + 5, blanket.w - 10, blanket.h - 10)
  
  myRiver.Draw()
    
end

function love.keypressed(key)
  
  print(key)
  
end