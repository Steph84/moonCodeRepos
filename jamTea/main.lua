io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 675 -- default value

local pics = {}
pics.bg = {}

function love.load()
  pics.bg.src = love.graphics.newImage("pictures/kitchenBackground.png")
  pics.bg.w = pics.bg.src:getWidth()
  pics.bg.h = pics.bg.src:getHeight()
  local ratio = pics.bg.w/pics.bg.h
  windowWidth = windowHeight * ratio
  pics.bg.scale = pics.bg.h/windowHeight
  
  love.window.setMode(windowWidth, windowHeight)
  
  
  
end

function love.update(dt)

end

function love.draw()
  love.graphics.draw(pics.bg.src, 0, 0, 0, 1/pics.bg.scale, 1/pics.bg.scale)
  
end

function love.keypressed(key)
  
  print(key)
  
end