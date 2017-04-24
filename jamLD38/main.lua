 -- initialiser le random
math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1280 -- 32x32px sprites value (40 columns)
local windowHeight = 672 -- 32x32px sprites value (21 lines)
local gameWindowWidth = windowWidth
local gameWindowHeight = windowHeight - 32

local gameState = "title"
local titlePic

local myGame = require("game")

function love.load()
  
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("CivCity")
  
  titlePic = love.graphics.newImage("pictures/ville.png")
  
  myGame.Load(gameWindowWidth, gameWindowHeight)
  
  
end

function love.update(dt)
  if gameState == "title" then
    if love.keyboard.isDown("space") then
    gameState = "game"
  end
  end
  
  if gameState == "game" then
    myGame.Update(dt)
  end
end

function love.draw()
  
  if gameState == "title" then
    love.graphics.draw(titlePic, windowWidth/2 - (1024/2)*0.7, 0, 0, 0.7, 0.7)
    love.graphics.print("Kthulhu 19.47", 50, 50, 0, 2, 2)
    love.graphics.print("Press space to play", windowWidth - 250, 50, 0, 1.5, 1.5)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Ludum Dare 38", windowWidth/2 - 130, 100, 0, 2.5, 2.5)
    love.graphics.print("Theme : A Small World", windowWidth/2 - 150, 200, 0, 2, 2)
    
    
    love.graphics.setColor(255, 255, 255)
  end
  
  if gameState == "game" then
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", 0, 0, gameWindowWidth/2, gameWindowHeight/2)
    love.graphics.rectangle("line", gameWindowWidth/2, gameWindowHeight/2, gameWindowWidth/2, gameWindowHeight/2)
    
    myGame.Draw(gameWindowWidth, gameWindowHeight)
  end
  
end