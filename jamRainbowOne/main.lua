io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth
local windowHeight = 640
local screenScale = 3
local gift = {}
local bigStar = {}
local smallStar1 = {}
local smallStar2 = {}
local trigger = false
local starsAlpha = 0
local animeRate = 1
bigStar.rot = 0
smallStar1.rot = 0
smallStar2.rot = 0
local timeElpased = 30

myPanel = require("panel")
myLand = require("land")
myCharacter = require("character")

function love.load()
  standardWidth = myPanel.Load()
  windowWidth = screenScale * standardWidth -- 960
  love.window.setMode(windowWidth, windowHeight)
  myLand.Load()
  myCharacter.Load(windowHeight)
  
  gift.pic = love.graphics.newImage("pictures/Present_Purple.png")
  bigStar.pic = love.graphics.newImage("pictures/BigHitFlash5.png")
  smallStar1.pic = love.graphics.newImage("pictures/SmallHitFlash5_A1.png")
  smallStar2.pic = love.graphics.newImage("pictures/SmallHitFlash5_A2.png")
  
  gift.x = 880
  gift.y = windowHeight - 6*32
  bigStar.x = gift.x
  bigStar.y = gift.y - 50
  smallStar1.x = gift.x - 50
  smallStar1.y = gift.y - 40
  smallStar2.x = gift.x + 50
  smallStar2.y = gift.y - 40
end

function animeAlpha(pStarsAlpha)
  
  pStarsAlpha = pStarsAlpha + animeRate
  
  if pStarsAlpha > 255 then
    animeRate = -1
  end
  
  if pStarsAlpha < 0 then
    animeRate = 1
  end
  
  return pStarsAlpha
end

function love.update(dt)
  myCharacter.Update(dt, windowWidth)
  
  if myCharacter.coorX > gift.x then
    trigger = true
  end
  
  if trigger == true then
    starsAlpha = animeAlpha(starsAlpha)
    bigStar.rot = bigStar.rot + 5*dt
    smallStar1.rot = smallStar1.rot + 5*dt
    smallStar2.rot = smallStar2.rot + 5*dt
  end
  
  timeElpased = timeElpased + dt
  
end

function love.draw()
  
  love.graphics.setColor(0, 51, 102)
  love.graphics.rectangle("fill", 0, 0, windowWidth/2, windowHeight - 5*32)
  
  love.graphics.setColor(250, 178, 102)
  love.graphics.rectangle("fill", windowWidth/2, 0, windowWidth/2, windowHeight - 5*32)
  
  love.graphics.setColor(255, 255, 255)
  
  if timeElpased > 3 and timeElpased < 8 then
    love.graphics.print("In my darkest hours, I want to feel a new beginning...", 100, 200)
  end
  if timeElpased > 7 and timeElpased < 12 then
    love.graphics.print("...I want a new environnement...", 200, 250)
  end
  if timeElpased > 11 and timeElpased < 16 then
    love.graphics.print("...I want a new job...", 300, 300)
  end
  if timeElpased > 15 and timeElpased < 20 then
    love.graphics.print("...I want a new home...", 400, 250)
  end
  if timeElpased > 19 and timeElpased < 24 then
    love.graphics.print("...I want a new dynamic...", 500, 200)
  end
  if timeElpased > 23 and timeElpased < 28 then
    love.graphics.print("...I want a new life...", 600, 150)
  end
  if timeElpased > 28 and trigger == false then
    love.graphics.print("...let's see with the arrow keys -->", 600, 400)
  end
  
  myPanel.Draw(windowWidth, windowHeight, screenScale)
  myLand.Draw()
  myCharacter.Draw()
  
  love.graphics.draw(gift.pic, gift.x, gift.y, 0, 2, 2)
  
  if trigger == true then
    love.graphics.setColor(255, 255, 255, starsAlpha)
    love.graphics.draw(bigStar.pic, bigStar.x, bigStar.y, bigStar.rot, 1, 1, bigStar.pic:getWidth()/2, bigStar.pic:getHeight()/2)
    love.graphics.draw(smallStar1.pic, smallStar1.x, smallStar1.y, smallStar1.rot, 1, 1, smallStar1.pic:getWidth()/2, smallStar1.pic:getHeight()/2)
    love.graphics.draw(smallStar2.pic, smallStar2.x, smallStar2.y, smallStar2.rot, 1, 1, smallStar2.pic:getWidth()/2, smallStar2.pic:getHeight()/2)
    love.graphics.print("I can have all of this...", 200, 200, 0, 3, 3)
    love.graphics.print("...if I really want it...", 300, 400, 0, 3, 3)
  end
  
end

function love.keypressed(key)
  
  print(key)
  
end