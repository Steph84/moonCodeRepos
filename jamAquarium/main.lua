io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

local myAquarium = require("aquarium")
local myJellyFish = require("jellyFish")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Dryland")
  myAquarium.Load(windowWidth, windowHeight)
  myJellyFish.Load(windowWidth, windowHeight)
  
end

function love.update(dt)
  myAquarium.Update(dt, windowHeight)
  myJellyFish.Update(dt, windowWidth, windowHeight)
end

function love.draw()
  myAquarium.Draw()
  myJellyFish.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end