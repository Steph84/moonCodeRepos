math.randomseed(os.time()) --initialiser le random
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300
local windowHeight = 675

local myRiver = require("river")

function love.load()
  love.window.setMode(windowWidth, windowHeight)
  myRiver.Load(windowWidth, windowHeight)
  
  
end

function love.update(dt)
  myRiver.Update(windowWidth, windowHeight)
end

function love.draw()
  myRiver.Draw()
    
end

function love.keypressed(key)
  
  print(key)
  
end