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

local myGame = require("game")

function love.load()
  
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("CivCity")
  
  myGame.Load(gameWindowWidth, gameWindowHeight)
  
end

function love.update(dt)
  myGame.Update(dt)

end

function love.draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", 0, 0, gameWindowWidth/2, gameWindowHeight/2)
  love.graphics.rectangle("line", gameWindowWidth/2, gameWindowHeight/2, gameWindowWidth/2, gameWindowHeight/2)
  
  myGame.Draw(gameWindowWidth, gameWindowHeight)
  
end

function love.keypressed(key)
  
  print(key)
  
end