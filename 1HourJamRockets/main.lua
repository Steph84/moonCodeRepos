 math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

local rocketPic = {}

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("OneHourGameJamRockets")
  
  rocketPic.src = love.graphics.newImage("pictures/rocketV2.png")
  rocketPic.w = rocketPic.src:getWidth()
  rocketPic.h = rocketPic.src:getHeight()
  
end

function love.update(dt)

end

function love.draw()
  love.graphics.setBackgroundColor(0, 0, 100)
  
end

function love.keypressed(key)
  
  print(key)
  
end