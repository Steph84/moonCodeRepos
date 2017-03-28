io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

local myAquarium = require("aquarium")
local myAnimals = require("animal")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Dryland")
  myAquarium.Load(windowWidth, windowHeight)
  myAnimals.Load()
  
end

function love.update(dt)
  myAquarium.Update(dt, windowHeight)
  myAnimals.Update(dt)
end

function love.draw()
  myAquarium.Draw()
  myAnimals.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end