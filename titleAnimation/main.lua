math.randomseed(os.time()) --initialiser le random
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1100
local windowHeight = 600

local myMenu = require("menu")
local myLetter = require("letter")

local titleDrawing = false


function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  
  myLetter.Load(windowWidth, windowHeight)
  
end

function love.update(dt)
  myLetter.Update(dt, windowWidth, windowHeight, titleDrawing)
end

function love.draw()
  love.graphics.setBackgroundColor(150, 150, 200)
  
  myLetter.Draw(titleDrawing)
  
  if titleDrawing == false then
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", windowWidth/2, windowHeight/2, 5)
  end
  love.graphics.setColor(255, 255, 255)
end

function love.keypressed(key)
  
  print(key)
  
end