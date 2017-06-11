math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1340 -- max value
local windowHeight = 682 -- max value

local myBed = require("riverBed")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("my River Animation")
  
  myBed.Load(windowWidth, windowHeight)
  
end

function love.update(dt)

end

function love.draw()
  myBed.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end