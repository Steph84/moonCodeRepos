math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 --1280 -- 32x32px sprites value (40 columns)
local windowHeight = 672 -- 32x32px sprites value (21 lines)

local myBackGround = require("backGround")
local myHero = require("hero")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("PixelPlatform")
  
  myBackGround.Load()
  myHero.Load(windowWidth, windowHeight, myMap)
  
end

function love.update(dt)
  myHero.Update(dt)
end

function love.draw()
  myBackGround.Draw()
  myHero.Draw()
end