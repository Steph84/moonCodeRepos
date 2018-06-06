io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth, windowHeight
local GameSizeCoefficient = 1
local TILE_SIZE = 32

local gameState = "title"

local myWindowDimension = require("windowDimension")
local myGame = require("game")
local titleScreen = {}
local goodEnding = {}
local badEnding = {}

local bgMusic = {}

function love.load()
  
  -- resize depending on the display dimensions
  GameSizeCoefficient = myWindowDimension.Load()
  TILE_SIZE = TILE_SIZE * GameSizeCoefficient
  
  local flags = nil
  windowWidth, windowHeight, flags = love.window.getMode( )
  
  love.window.setTitle("my Title")
  
  myGame.Load(GameSizeCoefficient, windowWidth, windowHeight)
  
  -- load the background music
  bgMusic = love.audio.newSource("musics/reptileSong.wav", "stream")
  bgMusic:setLooping(false)
  bgMusic:setVolume(0.75)
  --bgMusic:play()
  myGame.duration = bgMusic:getDuration() -- in seconds
  
  titleScreen.src = love.graphics.newImage("pictures/creation.jpg")
  goodEnding.src = love.graphics.newImage("pictures/universe.jpg")
  badEnding.src = love.graphics.newImage("pictures/flatEarth.jpg")
end

function love.update(dt)
  if gameState == "game" then
    gameState = myGame.Update(dt, gameState)
  end
end

function love.draw()
  if gameState == "title" then
    -- story
    love.graphics.printf("You're God ! Yeah that's right...", 0, 100, windowWidth, "right")
    love.graphics.printf("You're creating the Universe and you're doing ok...", 0, 150, windowWidth, "right")
    love.graphics.printf("But Holy fudge ! You just made a division by zero and created a blackhole !! ", 0, 200, windowWidth, "right")
    
    -- controls
    love.graphics.printf("Ok, don't panic and shut your fudging mouth !", 0, 300, windowWidth, "right")
    love.graphics.printf("Use the arrow keys to move the blackhole.", 0, 350, windowWidth, "right")
    love.graphics.printf("In each phase, you have to make the object of the right dimension fall into the blackhole", 0, 400, windowWidth, "right")
    
    love.graphics.printf("Press enter to play", 0, 500, windowWidth, "right")
    
    love.graphics.draw(titleScreen.src, 100, 100, 0, GameSizeCoefficient * 1.5, GameSizeCoefficient * 1.5)
  elseif gameState == "game" then
    myGame.Draw()
    
  elseif gameState == "gameOver" then
    
    love.graphics.setColor(255, 255, 255) -- white
    
    love.graphics.printf("Time's up !!", 0, 100, windowWidth, "right")
    
    if myGame.score > myGame.objectNumber then
    -- good ending
      love.graphics.draw(goodEnding.src, 100, 100, 0, GameSizeCoefficient * 0.5, GameSizeCoefficient * 0.5)
      love.graphics.printf("Good Ending", 0, 200, windowWidth, "right")
      love.graphics.printf("Perfect ! Like you ;-)", 0, 300, windowWidth, "right")
    else
    -- bad ending
      love.graphics.draw(badEnding.src, 100, 100, 0, GameSizeCoefficient * 0.5, GameSizeCoefficient * 0.5)
      love.graphics.printf("Bad Ending", 0, 200, windowWidth, "right")
      love.graphics.printf("Not quite right. Try in another parallel universe maybe...", 0, 300, windowWidth, "right")
    end
  end
end

function love.keypressed(key)
  if gameState == "title" then
    if key == "return" then
      gameState = "game"
      bgMusic:play()
    end
  end
end