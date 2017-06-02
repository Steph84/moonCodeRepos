math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1280 -- 32x32px sprites value (40 columns)
local windowHeight = 672 -- 32x32px sprites value (21 lines)

local myParallax = require("parallaxAnimation")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("my Title")
  
  myParallax.Load(windowWidth, windowHeight)
  
end

function love.update(dt)
  myParallax.Update(dt)
end

function love.draw()
  myParallax.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end