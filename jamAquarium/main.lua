io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

local myAquarium = require("aquarium")
local myFish = require("fish")

local fishNumber = 50
local bgMus

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Dryland")
  myAquarium.Load(windowWidth, windowHeight)
  
  myFish.Load(fishNumber, windowWidth, windowHeight)
  
  bgMus = love.audio.newSource("sounds/bgMusic.mp3", "stream")
  bgMus:setLooping(true)
  bgMus:setVolume(0.25)
  bgMus:play()
  
end

function love.update(dt)
  
  myAquarium.Update(dt, windowWidth, windowHeight)
  
  myFish.Update(dt, windowWidth, windowHeight)
  
end

function love.draw()
  myAquarium.Draw()
  
  myFish.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end