io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

-- local windowWidth = 800 -- default value
-- local windowHeight = 600 -- default value
local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

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