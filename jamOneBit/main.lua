 -- initialiser le random
math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

local myTitle = require("title")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("RPG clicker")
  
  myTitle.Load()
  
end

function love.update(dt)

end

function love.draw()
  myTitle.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end