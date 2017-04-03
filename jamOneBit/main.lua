 -- initialiser le random
math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

local actualScreen = "title"
local tempScreen = "title"
local myTitle = require("title")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("RPG clicker")
  
  if actualScreen == "title" then myTitle.Load(windowWidth) end
  
  
end

function love.update(dt)
  if actualScreen == "title" then
    --tempScreen = 
    myTitle.Update(dt)
    if tempScreen ~= "title" then actualScreen = tempScreen end
  end
  if actualScreen == "menu" then print("truc") end
end

function love.draw()
  if actualScreen == "title" then myTitle.Draw(windowWidth) end
  
end

function love.keypressed(key)
  
  print(key)
  
end