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
  Hero.y = 200
  Hero.jumpPic = love.graphics.newImage("pictures/char01Jump.png")
  Hero.fallPic = love.graphics.newImage("pictures/char01Fall.png")
  
  Hero.wall = 0.7 -- threshold to stop the Hero and moving the map
  
  Hero.mov = "stand"
  Hero.dir = "right"
  Hero.sign = 1
  Hero.speed = {}
  Hero.speed.walk = 5
  Hero.speed.animWalk = 10
  Hero.speed.impuls = 7
  Hero.speed.jump = Hero.speed.impuls
  Hero.speed.fall = 0
  Hero.speed.alongY = 0
  
  Hero.animWalkSpeed = 10 -- speed to anim the walking
  Hero.isWalking = false
  Hero.picCurrent = 1 -- for walking animation
  Hero.animWalk = {}
  
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
    Hero.animWalk[id] = love.graphics.newQuad((c-1)*Hero.w,
                                              (l-1)*Hero.h,
                                              Hero.w,
                                              Hero.h,
                                              Hero.anim:getDimensions())
    id = id + 1
    end
  end
  
end

function Hero.Update(dt)
  
  myMap.Update(dt, Hero)
  
  -- calculate the position of the feet in pixel
  Hero.xFeet = Hero.x + Hero.w/2 - Hero.w/2 -- the (- Hero.w/2) is for centered sprite
  Hero.yFeet = Hero.y + Hero.h
  -- calculate the position of the head in pixel
  Hero.xHead = Hero.x + Hero.w/2 - Hero.w/2 -- the (- Hero.w/2) is for centered sprite
  Hero.yHead = Hero.y
  -- calculate the position of the feet in line and columns
  Hero.linFeet = math.ceil(Hero.yFeet / myMap.TILE_SIZE)
  Hero.colFeet = math.ceil((Hero.xFeet - myMap.grid[1][1].x) / myMap.TILE_SIZE)
  -- calculate the position of the head in line and columns
  Hero.linHead = math.ceil(Hero.yHead / myMap.TILE_SIZE)
  Hero.colHead = math.ceil((Hero.xHead - myMap.grid[1][1].x) / myMap.TILE_SIZE)
  
  local textureUnder = myMap.grid[Hero.linFeet][Hero.colFeet].texture
  local textureAbove = myMap.grid[Hero.linHead][Hero.colHead].texture
  
  -- condition for correct orientation
  if (love.keyboard.isDown("right") and Hero.dir == "left") then
    Hero.dir = "right"
    Hero.sign = 1
  elseif (love.keyboard.isDown("left") and Hero.dir == "right") then
    Hero.dir = "left"
    Hero.sign = -1
  end
  
  -- if there is ground under
  if textureUnder == "ground" then
    Hero.speed.alongY = 0
    if love.keyboard.isDown("right") and Hero.dir == "right"
    or love.keyboard.isDown("left") and Hero.dir == "left" then
      Hero.mov = "walk"
    else Hero.mov = "stand"
    end
  end
  -- if there is ground above
  if textureAbove == "ground" then
    Hero.mov = "fall"
    Hero.speed.alongY = - 0.5 -- initialize under 0 to avoid stick on the platform
  end
  -- condition for jumping
  if love.keyboard.isDown("space")
  and (Hero.mov == "walk" or Hero.mov == "stand") then -- avoid jumping while in void
    Hero.mov = "jump"
    Hero.speed.alongY = Hero.speed.impuls -- initialize jump speed
  end
  -- manage the falling when walking and reinitialize the ground position
  if Hero.mov == "stand" or Hero.mov == "walk" then
    if textureUnder == "void" then Hero.mov = "fall" end -- fall when no more ground
    if textureUnder == "ground" then
      Hero.y = myMap.grid[Hero.linFeet][Hero.colFeet].y - Hero.h + 5 -- put the Hero on top of the ground
    end
  end
  -- manage the walking animation
  if Hero.mov == "walk" then Hero.picCurrent = Hero.picCurrent + (Hero.speed.animWalk * dt) end
  if math.floor(Hero.picCurrent) > #Hero.animWalk then Hero.picCurrent = 1 end
  -- manage the movement along x
  if ( Hero.mov == "walk" or Hero.mov == "jump" or Hero.mov == "fall" ) -- actions allow to move along x
     --       hero after left threshold      map stop move to right               hero left boundary
    and ( ( (Hero.x > windowWidth*(1-Hero.wall) or ((Hero.x - Hero.w/2) > 0)) and love.keyboard.isDown("left") )
     --    hero before right threshold                 map stop move to left                              hero right boundary
    or ( (Hero.x < windowWidth*Hero.wall or ((Hero.x + Hero.w/2) < windowWidth)) and love.keyboard.isDown("right") ) ) then
      Hero.x = Hero.x + Hero.speed.walk * Hero.sign
      myMap.mov = false
  else
    myMap.mov = true
  end
  if not love.keyboard.isDown("right") and not love.keyboard.isDown("left") then myMap.mov = false end
  
  -- manage the movement along y
  if Hero.mov == "jump" or Hero.mov == "fall" then
    Hero.y = Hero.y - Hero.speed.alongY
    Hero.speed.alongY = Hero.speed.alongY - dt*9.81
  end
  -- manage the status along y
  if Hero.speed.alongY > 0 then Hero.mov = "jump"
  elseif Hero.speed.alongY < 0 then Hero.mov = "fall" end
  
end

function Hero.Draw()
  myMap.Draw()
  
  if Hero.mov == "stand" then love.graphics.draw(Hero.pic, Hero.x, Hero.y, 0, Hero.sign, 1, Hero.w/2, 1) end
  if Hero.mov == "jump" then love.graphics.draw(Hero.jumpPic, Hero.x, Hero.y, 0, Hero.sign, 1, Hero.w/2, 1) end
  if Hero.mov == "fall" then love.graphics.draw(Hero.fallPic, Hero.x, Hero.y, 0, Hero.sign, 1, Hero.w/2, 1) end

  love.graphics.printf("line : "..Hero.linFeet.." / column : "..Hero.colFeet, 10, 10, windowWidth, "left")
  
  love.graphics.circle("fill", Hero.xFeet, Hero.yFeet, 2)
  love.graphics.circle("fill", Hero.x - Hero.w/2, Hero.y + Hero.h/2, 2)
  love.graphics.circle("fill", Hero.xFeet, Hero.y, 2)
  love.graphics.circle("fill", Hero.x + Hero.w - Hero.w/2, Hero.y + Hero.h/2, 2)
  
  -- standard jump
  --love.graphics.line(0, myMap.size.pixH - (32 - 1) - (4*32), windowWidth, myMap.size.pixH - (32 - 1) - (4*32))
  
  if Hero.mov == "walk" then
    if Hero.dir == "right" then
      love.graphics.draw(Hero.anim, Hero.animWalk[math.floor(Hero.picCurrent)],Hero.x, Hero.y, 0, 1, 1, Hero.w/2, 1)
    elseif Hero.dir == "left" then
      love.graphics.draw(Hero.anim, Hero.animWalk[math.floor(Hero.picCurrent)],Hero.x, Hero.y, 0, -1, 1, Hero.w/2, 1)
    end
  end
  
end


return Hero