local Hero = {}

local windowWidth, windowHeight
local myMap = require("map")

function Hero.Load(pWindowWidth, pWindowHeight, oMap)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  myMap.Load(windowWidth, windowHeight)
  
  Hero.pic = love.graphics.newImage("pictures/char01Stand.png")
  Hero.x = 200
  Hero.y = 500
  Hero.w = Hero.pic:getWidth()
  Hero.h = Hero.pic:getHeight()
  
end

function Hero.Update(dt)
  myMap.Update(dt, Hero.x)
  
  Hero.xFeet = Hero.x + (Hero.w/2)
  Hero.yFeet = Hero.y + Hero.h
  Hero.linFeet = math.ceil(Hero.yFeet / myMap.TILE_SIZE)
  Hero.colFeet = math.ceil(Hero.xFeet / myMap.TILE_SIZE)
  
  if myMap.grid[Hero.linFeet][Hero.colFeet].texture ~= "ground" then
    Hero.y = Hero.y + 9.81 * dt * 10
  end
  
  if love.keyboard.isDown("left") and Hero.x > 0 then
    Hero.x = Hero.x - 1000 * dt
  end
  if love.keyboard.isDown("right") and Hero.x < windowWidth*0.6 then
    Hero.x = Hero.x + 100 * dt
  end
  
end

function Hero.Draw()
  myMap.Draw()
  love.graphics.draw(Hero.pic, Hero.x, Hero.y)
  love.graphics.print(Hero.linFeet, 500, 500)
  love.graphics.print(Hero.colFeet, 500, 550)
  love.graphics.circle("fill", Hero.xFeet, Hero.yFeet, 2)
  love.graphics.circle("fill", Hero.x, Hero.y + Hero.h/2, 2)
  love.graphics.circle("fill", Hero.xFeet, Hero.y, 2)
  love.graphics.circle("fill", Hero.x + Hero.w, Hero.y + Hero.h/2, 2)

end


return Hero