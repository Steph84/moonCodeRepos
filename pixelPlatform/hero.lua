local Hero = {}

local windowWidth, windowHeight
local myMap = require("map")

function Hero.Load(pWindowWidth, pWindowHeight, oMap)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  myMap.Load(windowWidth, windowHeight)
  Hero.pic = love.graphics.newImage("pictures/char01Stand.png") -- standing pic
  Hero.w = Hero.pic:getWidth()
  Hero.h = Hero.pic:getHeight()
  Hero.x = 200
  Hero.y = myMap.size.pixH - Hero.h - (32 - 1)
  Hero.vx = 100
  Hero.vy = 0
  
  Hero.wall = 0.7 -- threshold to stop the character and moving the map
  
  Hero.walkAnimSpeed = 10 -- speed to anim the walking
  Hero.isWalking = false
  Hero.picCurrent = 1 -- for walking animation
  Hero.walkAnim = {}
  
  Hero.gravity = 9.81 * 105
  Hero.jumpSpeed = Hero.gravity/2
  Hero.jumping = false
  
  -- load the animation walking tile
  Hero.anim = love.graphics.newImage("pictures/char01Walk.png")
  local nbColumns = Hero.anim:getWidth() / Hero.w
  local nbLines = Hero.anim:getHeight() / Hero.h
  
  -- extract all the frames in the animation walking tile
  local l, c
  local id = 1
  Hero.walkAnim[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    Hero.walkAnim[id] = love.graphics.newQuad(
                                              (c-1)*Hero.w,
                                              (l-1)*Hero.h,
                                              Hero.w,
                                              Hero.h,
                                              Hero.anim:getDimensions()
                                              )
    id = id + 1
    end
  end
  
end

function Hero.Update(dt)
  myMap.Update(dt, Hero)
  
  Hero.isWalking = false
  
  -- calculate the position of the feet in pixel
  Hero.xFeet = Hero.x + (Hero.w/2)
  Hero.yFeet = Hero.y + Hero.h
  -- calculate the position of the feet in line and columns
  Hero.linFeet = math.ceil(Hero.yFeet / myMap.TILE_SIZE)
  Hero.colFeet = math.ceil((Hero.xFeet - myMap.grid[1][1].x) / myMap.TILE_SIZE)
  
  -- manage the jump
  if love.keyboard.isDown("space") and Hero.jumping == false then
    Hero.vy = Hero.jumpSpeed
    Hero.jumping = true
  end
  if Hero.jumping == true then
    Hero.y = Hero.y - Hero.vy * dt
    Hero.vy = Hero.vy - Hero.gravity * dt
  end
  if myMap.grid[Hero.linFeet][Hero.colFeet].texture == "ground" then
    Hero.vy = 0
    Hero.jumping = false
    if Hero.y > myMap.size.pixH - Hero.h - (32 - 1) then
      Hero.y = myMap.size.pixH - Hero.h - (32 - 1)
    end
  end
  
  -- manage the left direction
  if love.keyboard.isDown("left") then
    Hero.isWalking = true
    if Hero.x > windowWidth*(1-Hero.wall) -- if the hero is after the left threshold
    or (myMap.grid[1][1].x > -1 and Hero.x > 10) then -- if the map stop to move
      Hero.x = Hero.x - Hero.vx * dt
    end
  end
  -- manage the right direction
  if love.keyboard.isDown("right") then
    Hero.isWalking = true
    if Hero.x < windowWidth*Hero.wall  -- if the hero is before the right threshold
    or (myMap.grid[1][1].x < (windowWidth - myMap.size.pixW) and (Hero.x + Hero.w) < windowWidth) then  -- if the map stop to move
      Hero.x = Hero.x + Hero.vx * dt
    end
  end
  
  -- animation of the hero
  Hero.picCurrent = Hero.picCurrent + (Hero.walkAnimSpeed * dt)
  if math.floor(Hero.picCurrent) > #Hero.walkAnim then Hero.picCurrent = 1 end
  
end

function Hero.Draw()
  myMap.Draw()
  
  if Hero.isWalking == false then
    love.graphics.draw(Hero.pic, Hero.x, Hero.y)
  end

  love.graphics.printf("line : "..Hero.linFeet.." / column : "..Hero.colFeet, 10, 10, windowWidth, "left")
  
  love.graphics.circle("fill", Hero.xFeet, Hero.yFeet, 2)
  love.graphics.circle("fill", Hero.x, Hero.y + Hero.h/2, 2)
  love.graphics.circle("fill", Hero.xFeet, Hero.y, 2)
  love.graphics.circle("fill", Hero.x + Hero.w, Hero.y + Hero.h/2, 2)
  
  -- standard jump
  --love.graphics.line(0, myMap.size.pixH - (32 - 1) - (4*32), windowWidth, myMap.size.pixH - (32 - 1) - (4*32))
  
  
  if Hero.isWalking == true then
    love.graphics.draw(Hero.anim, Hero.walkAnim[math.floor(Hero.picCurrent)],Hero.x, Hero.y)
  end

end


return Hero