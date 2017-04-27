io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Menu")
  
  
end

function love.update(dt)

end

function love.draw()
  local scale = 5
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setDefaultFilter("linear", "linear")
  love.graphics.printf("Coucou", 0, windowHeight/2, windowWidth/scale, "center", 0, scale, scale)
  
  
end

function love.keypressed(key)
  
  print(key)
  
end