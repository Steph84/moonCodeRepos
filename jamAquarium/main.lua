io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

local myAquarium = require("aquarium")
local myJellyFish = require("jellyFish")
local myFish = require("fish")

local fishNumber = 10

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Dryland")
  myAquarium.Load(windowWidth, windowHeight)
  myJellyFish.Load(windowWidth, windowHeight)
  myFish.Load(fishNumber, windowWidth, windowHeight)
  
end

function love.update(dt)
  myAquarium.Update(dt, windowHeight)
  myJellyFish.Update(dt, windowWidth, windowHeight)
  myFish.Update(dt, windowWidth, windowHeight)
  
end

function love.draw()
  myAquarium.Draw()
  myJellyFish.Draw()
  myFish.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end