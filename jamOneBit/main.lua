 -- initialiser le random
math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

local actualScreen = "title"
local tempScreen
local myTitle = require("title")
local myGame = require("game")
local myOver = require("over")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Tower clicker")
  
  myTitle.Load(windowWidth)
  myGame.Load(windowHeight)
  
  
end

function love.update(dt)
  if actualScreen == "title" then
    tempScreen = myTitle.Update(dt)
    if tempScreen ~= "title" then actualScreen = tempScreen end
  end
  if actualScreen == "game" then
    tempScreen = myGame.Update(dt)
    if tempScreen ~= "game" then actualScreen = tempScreen end
  end
end

function love.draw()
  if actualScreen == "title" then
    myTitle.Draw(windowWidth)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("The Castle Clicker", 450, 200, 0, 4, 4)
  end
  
  if actualScreen == "game" then 
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 611, windowWidth, 64)
    love.graphics.setColor(255, 255, 255)
    myGame.Draw()
  end
  
  if actualScreen == "gameOver" then
    myOver.Draw(windowWidth, windowHeight)
  end
end

function love.keypressed(key)
  
  print(key)
  
end