io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowHeight = 680
local windowWidth = windowHeight/2

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  
  
end

function love.update(dt)

end

function love.draw()
    
end

function love.keypressed(key)
  
  print(key)
  
end