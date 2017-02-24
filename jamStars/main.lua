io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local myGiant = require("giant")
local myStar = require("star")

function love.load()
  love.window.setMode(windowWidth, windowHeight)
  myGiant.Load(windowWidth, windowHeight)
  myStar.Load(windowWidth, windowHeight)
end

function love.update(dt)
  myGiant.Update(dt)
  myStar.Update(dt, windowWidth, windowHeight)
end

function love.draw()
  myGiant.Draw()
  myStar.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end