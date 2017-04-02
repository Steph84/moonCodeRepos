io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

local myAquarium = require("aquarium")

local fishNumber = 50
local bgMus

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Dryland")
  myAquarium.Load(windowWidth, windowHeight, fishNumber)
  
  
  bgMus = love.audio.newSource("sounds/bgMusic.mp3", "stream")
  bgMus:setLooping(true)
  bgMus:setVolume(0.2)
  bgMus:play()
  
  
end

function love.update(dt)
  myAquarium.Update(dt, windowWidth, windowHeight)
end

function love.draw()
  myAquarium.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end