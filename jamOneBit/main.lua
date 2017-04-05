 -- initialiser le random
math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

local actualScreen = "game"
local tempScreen = "title"
local myTitle = require("title")
local myGame = require("game")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("RPG clicker")
  
  myTitle.Load(windowWidth)
  myGame.Load()
  
  
end

function love.update(dt)
  if actualScreen == "title" then
    tempScreen = myTitle.Update(dt)
    if tempScreen ~= "title" then actualScreen = tempScreen end
  end
  if actualScreen == "game" then
      --tempScreen = myGame.Update(dt)
  end
end

function love.draw()
  if actualScreen == "title" then myTitle.Draw(windowWidth) end
  
  if actualScreen == "game" then 
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 611, windowWidth, 64)
    love.graphics.setColor(255, 255, 255)
    myGame.Draw()
  end
  
end

function love.keypressed(key)
  
  print(key)
  
end