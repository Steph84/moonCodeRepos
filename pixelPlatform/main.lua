math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1280 -- 32x32px sprites value (40 columns)
local windowHeight = 672 -- 32x32px sprites value (21 lines)

local myMap = require("map")
local myBackGround = require("backGround")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("PixelPlatform")
  
  myBackGround.Load()
  myMap.Load(windowWidth, windowHeight)
  
end

function love.update(dt)

end

function love.draw()
  myBackGround.Draw()
  myMap.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end