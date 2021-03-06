io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1000
local windowHeight
local bgW, bgH

Fox = require("fox")
Dog = require("dog")

local rectDepth = 50
local ratio = 1
local colState = false
local currentScreen = "title"

function animalCollision(pFox, pDog)
  local F = pFox
  local D = pDog
  local dx = F.coorX - D.coorX
  local dy = F.coorY - D.coorY
  
  -- absolu of scale because of the negative scale for the flip
  if (math.abs(dx) < (F.w*math.abs(F.scX)/2 + D.w*math.abs(D.scX)/2)) then
    if (math.abs(dy) < (F.h*math.abs(F.scY)/2 + D.h*math.abs(D.scY)/2)) then
    return true
    end
  end
  return false
  
end

function love.load()
  titScreen = love.graphics.newImage("pictures/titleScreen.png")
  bgPic = love.graphics.newImage("pictures/background.png")
    
  bgMus = love.audio.newSource("sounds/bcgMusic.mp3", "stream")
  sonHit = love.audio.newSource("sounds/hitSound.wav", "static")
  
  bgMus:setLooping(true)
  bgMus:setVolume(0.25)
  bgMus:play()
    
  bgW = bgPic:getWidth()
  bgH = bgPic:getHeight()
  
  ratio = bgW/windowWidth
  windowHeight = bgH/ratio
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Fox & Dog")
  
  Fox.Load(windowHeight, windowWidth, rectDepth)
  Dog.Load(windowHeight, rectDepth)
  
end

function love.update(dt)
  
  if currentScreen == "title" then
    if love.keyboard.isDown("return") then
      currentScreen = "game"
    end
  end
  
  if currentScreen == "game" then
    Fox.Update(dt, windowWidth, windowHeight)
    Dog.Update(dt, windowWidth)
    colState = animalCollision(Fox, Dog)
    if colState == true then
      sonHit:setVolume(0.25)
      sonHit:play()
    end
  end
end

function love.draw()
  
  if currentScreen == "title" then
    love.graphics.draw(titScreen, 0, 0, 0)
  end
  
  if currentScreen == "game" then
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(bgPic, 0, 0, 0, 1/ratio, 1/ratio)
    Fox.Draw(colState)
    Dog.Draw()
  end
end

