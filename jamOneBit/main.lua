 -- initialiser le random
math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("my Title")
  
  
end

function love.update(dt)

end

function love.draw()
    
end

function love.keypressed(key)
  
  print(key)
  
end