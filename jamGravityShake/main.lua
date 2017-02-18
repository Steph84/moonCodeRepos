io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value
local alpha, beta

local Drop = require("drop")

function love.load()
  love.window.setMode(windowWidth, windowHeight)
  Drop.Load(windowWidth, windowHeight)
end

function love.update(dt)
  alpha, beta = love.mouse.getPosition()
  Drop.Update(dt, windowWidth, windowHeight, alpha, beta)
end

function love.draw()
  love.graphics.circle("line", alpha, beta, 75)
  Drop.Draw(windowHeight)
end

function love.keypressed(key)
  
  print(key)
  
end