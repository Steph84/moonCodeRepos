io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

-- local windowWidth = 800 -- default value
-- local windowHeight = 600 -- default value
local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

local bg = {}

function love.load()
  love.window.setMode(windowWidth, windowHeight)
  bg.src = love.graphics.newImage("pictures/background.png")
  bg.w = bg.src:getWidth()
  bg.h = bg.src:getHeight()
  bg.scale = windowWidth/bg.w
  bg.x = 0
  bg.y = windowHeight - bg.h * bg.scale/2
  
  
end

function love.update(dt)

end

function love.draw()
  
  -- shading above the background picture
  love.graphics.setColor(14, 11, 17)
  love.graphics.rectangle("fill", 0, bg.y - 300, windowWidth, 100)
  love.graphics.setColor(37, 21, 25)
  love.graphics.rectangle("fill", 0, bg.y - 200, windowWidth, 100)
  love.graphics.setColor(46, 24, 24)
  love.graphics.rectangle("fill", 0, bg.y - 100, windowWidth, 100)
  
  -- 2 background pictures side to side
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(bg.src, bg.x, bg.y, 0, bg.scale/2, bg.scale/2)
  love.graphics.draw(bg.src, bg.x + bg.w * bg.scale/2, bg.y, 0, bg.scale/2, bg.scale/2)
end

function love.keypressed(key)
  
  print(key)
  
end