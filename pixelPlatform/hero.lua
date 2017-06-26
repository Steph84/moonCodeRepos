local Hero = {}

local windowWidth, windowHeight
local myMap = require("map")
local myCollision = require("collisionManage")

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
  
  Hero.wall = 0.7 -- threshold to stop the Hero and moving the map
  
  Hero.mov = "stand"
  Hero.dir = "right"
  Hero.speed = {}
  Hero.speed.walk = 5
  Hero.speed.animWalk = 10
  
  Hero.animWalkSpeed = 10 -- speed to anim the walking
  Hero.isWalking = false
  Hero.picCurrent = 1 -- for walking animation
  Hero.animWalk = {}
  
  Hero.gravity = 9.81 * 105
  Hero.jumpSpeed = Hero.gravity/2
  Hero.jumping = false
  Hero.falling = false
  
  -- load the animation walking tile
  Hero.anim = love.graphics.newImage("pictures/char01Walk.png")
  local nbColumns = Hero.anim:getWidth() / Hero.w
  local nbLines = Hero.anim:getHeight() / Hero.h
  
  -- extract all the frames in the animation walking tile
  local l, c
  local id = 1
  Hero.animWalk[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    Hero.animWalk[id] = love.graphics.newQuad(
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
  
  -- condition for correct orientation
  if love.keyboard.isDown("right") and Hero.dir == "left" then
    Hero.dir = "right"
  elseif love.keyboard.isDown("left") and Hero.dir == "right" then
    print("fuck it")
    Hero.dir = "left"
    print(Hero.dir)
  end
  
  -- condition for walking
  if love.keyboard.isDown("right") and Hero.dir == "right" then
    Hero.mov = "walk"
    Hero.picCurrent = Hero.picCurrent + (Hero.speed.animWalk * dt) -- using the delta time
    Hero.x = Hero.x + Hero.speed.walk
  elseif love.keyboard.isDown("left") and Hero.dir == "left" then
    Hero.mov = "walk"
    Hero.picCurrent = Hero.picCurrent + (Hero.speed.animWalk * dt) -- using the delta time
    Hero.x = Hero.x - Hero.speed.walk
  
  -- condition for standing
  elseif Hero.dir == "right" or Hero.dir == "left" then
    Hero.mov = "stand"
  end
  
  if math.floor(Hero.picCurrent) > #Hero.animWalk then Hero.picCurrent = 1 end
  
  
  -- calculate the position of the feet in pixel
  Hero.xFeet = Hero.x + (Hero.w/2)
  Hero.yFeet = Hero.y + Hero.h
  -- calculate the position of the feet in line and columns
  Hero.linFeet = math.ceil(Hero.yFeet / myMap.TILE_SIZE)
  Hero.colFeet = math.ceil((Hero.xFeet - myMap.grid[1][1].x) / myMap.TILE_SIZE)
  
  -- manage the jump
  --[[
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
    Hero.falling = false
    if Hero.y > myMap.size.pixH - Hero.h - (32 - 1) then
      Hero.y = myMap.size.pixH - Hero.h - (32 - 1)
    end
  end
  
  -- manage the left direction
  if love.keyboard.isDown("left") then
  
    if Hero.x > windowWidth*(1-Hero.wall) -- if the hero is after the left threshold
    or (myMap.grid[1][1].x > -1 and Hero.x > 10) then -- if the map stop to move
      Hero.x = Hero.x - Hero.vx * dt
    end
  end
  -- manage the right direction
  if love.keyboard.isDown("right") then
  
    if Hero.x < windowWidth*Hero.wall  -- if the hero is before the right threshold
    or (myMap.grid[1][1].x < (windowWidth - myMap.size.pixW) and (Hero.x + Hero.w) < windowWidth) then  -- if the map stop to move
      Hero.x = Hero.x + Hero.vx * dt
    end
  end
  --]]
  
  
  
  if myCollision.Collide(Hero, myMap.grid[Hero.linFeet][Hero.colFeet], myMap.grid[Hero.linFeet][Hero.colFeet].texture) then
    -- nothing
    --print("true, on the ground")
  else
    -- moving y
    --print("false, falling")
    Hero.falling = true
  end
  if Hero.falling == true then
    
  end

  
  
end

function Hero.Draw()
  myMap.Draw()
  
  if Hero.mov == "stand" then
    love.graphics.draw(Hero.pic, Hero.x, Hero.y, 0, 1, 1, Hero.w/2, 1)
  end

  love.graphics.printf("line : "..Hero.linFeet.." / column : "..Hero.colFeet, 10, 10, windowWidth, "left")
  
  love.graphics.circle("fill", Hero.xFeet, Hero.yFeet, 2)
  love.graphics.circle("fill", Hero.x, Hero.y + Hero.h/2, 2)
  love.graphics.circle("fill", Hero.xFeet, Hero.y, 2)
  love.graphics.circle("fill", Hero.x + Hero.w, Hero.y + Hero.h/2, 2)
  
  -- standard jump
  --love.graphics.line(0, myMap.size.pixH - (32 - 1) - (4*32), windowWidth, myMap.size.pixH - (32 - 1) - (4*32))
  
  
  if Hero.mov == "walk" then
    if Hero.dir == "right" then
      love.graphics.draw(Hero.anim, Hero.animWalk[math.floor(Hero.picCurrent)],Hero.x, Hero.y, 0, 1, 1, Hero.w/2, 1)
    elseif Hero.dir == "left" then
      love.graphics.draw(Hero.anim, Hero.animWalk[math.floor(Hero.picCurrent)],Hero.x, Hero.y, 0, -1, 1, Hero.w/2, 1)
    end
    print(Hero.dir)
  end
  

end


return Hero