math.randomseed(os.time()) --initialiser le random
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300
local windowHeight = 675

local green1Color = {128, 255, 0}
local green2Color = {0, 255, 0}
local green3Color = {0, 255, 128}
local green4Color = {0, 102, 0}

local myRiver = require("river")

function love.load()
  love.window.setMode(windowWidth, windowHeight)
  
  myRiver.Load(windowWidth, windowHeight)
  
end

function love.update(dt)
  myRiver.Update(dt, windowWidth, windowHeight)
end

function love.draw()
  love.graphics.setBackgroundColor(green4Color)
  myRiver.Draw()
    
end

function love.keypressed(key)
  
  print(key)
  
end