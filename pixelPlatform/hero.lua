local Hero = {}

local windowWidth, windowHeight
local myMap = require("map")
local myCollision = require("collisionManage")
local timeElapsed = 0

function Hero.Load(pWindowWidth, pWindowHeight, oMap)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  myMap.Load(windowWidth, windowHeight)
  Hero.pic = love.graphics.newImage("pictures/char01Stand.png") -- standing pic
  Hero.w = Hero.pic:getWidth()
  Hero.h = Hero.pic:getHeight()
  Hero.x = windowWidth/2
  Hero.y = 200
  Hero.jumpPic = love.graphics.newImage("pictures/char01Jump.png")
  Hero.fallPic = love.graphics.newImage("pictures/char01Fall.png")
  Hero.scale = 2
  
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
  Hero.xFeet = Hero.x + (Hero.w * Hero.scale)/2 - (Hero.w * Hero.scale)/2 -- the (- Hero.w/2) is for centered sprite
  Hero.yFeet = Hero.y + Hero.h * Hero.scale
  -- calculate the position of the head in pixel
  Hero.xHead = Hero.x + (Hero.w * Hero.scale)/2 - (Hero.w * Hero.scale)/2 -- the (- Hero.w/2) is for centered sprite
  Hero.yHead = Hero.y
  -- calculate the position of the feet in line and columns
  Hero.linFeet = math.ceil(Hero.yFeet / myMap.TILE_SIZE)
  Hero.colFeet = math.ceil((Hero.xFeet - myMap.myBuilding.grid[1][1].x) / myMap.TILE_SIZE)
  -- calculate the position of the head in line and columns
  Hero.linHead = math.ceil(Hero.yHead / myMap.TILE_SIZE)
  Hero.colHead = math.ceil((Hero.xHead - myMap.myBuilding.grid[1][1].x) / myMap.TILE_SIZE)
  
  local textureUnder = myMap.myBuilding.grid[Hero.linFeet][Hero.colFeet].texture
  local textureAbove = myMap.myBuilding.grid[Hero.linHead][Hero.colHead].texture
  
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
    if (love.keyboard.isDown("right") and Hero.dir == "right")
        or (love.keyboard.isDown("left") and Hero.dir == "left") then
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
  if love.keyboard.isDown("space") and (Hero.mov == "walk" or Hero.mov == "stand") then -- avoid jumping while in void
    Hero.mov = "jump"
    Hero.speed.alongY = Hero.speed.impuls -- initialize jump speed
  end
  -- manage the falling when walking and reinitialize the ground position
  if Hero.mov == "stand" or Hero.mov == "walk" then
    if textureUnder == "void" then Hero.mov = "fall" end -- fall when no more ground
    if textureUnder == "ground" then
      Hero.y = myMap.myBuilding.grid[Hero.linFeet][Hero.colFeet].y - (Hero.h * Hero.scale - 8) -- put the Hero on top of the ground
    end
  end
  
    print(Hero.y)
  -- manage the walking animation
  if Hero.mov == "walk" then Hero.picCurrent = Hero.picCurrent + (Hero.speed.animWalk * dt) end
  if math.floor(Hero.picCurrent) > #Hero.animWalk then Hero.picCurrent = 1 end
  
  -- manage the movement along x
  if ( Hero.mov == "walk" or Hero.mov == "jump" or Hero.mov == "fall" ) -- actions allow to move along x
      and ( (love.keyboard.isDown("left") or love.keyboard.isDown("right")) -- press keyboard
          and ( (Hero.x > windowWidth*(1-Hero.wall) and Hero.x < windowWidth*Hero.wall) -- hero in the center part
              or ( Hero.x > 0 and Hero.x <= windowWidth*(1-Hero.wall) and myMap.myBuilding.grid[1][1].x > -1 ) -- hero left part
              or ( (Hero.x - Hero.w) < windowWidth and Hero.x >= windowWidth*Hero.wall and myMap.myBuilding.grid[myMap.myBuilding.size.h][myMap.myBuilding.size.w].x < (windowWidth - myMap.TILE_SIZE) ) ) ) -- hero in the right part
      or ( Hero.x >= Hero.wall*windowWidth and love.keyboard.isDown("left")) -- unstuck the hero from right wall
      or ( Hero.x <= (1-Hero.wall)*windowWidth and love.keyboard.isDown("right")) -- unstuck the hero from left wall
  then
    local threShold = Hero.w/5
    if Hero.x > threShold and Hero.x < (windowWidth - threShold) 
       or ( Hero.x <= threShold and love.keyboard.isDown("right") )
       or ( Hero.x >= (windowWidth - threShold) and love.keyboard.isDown("left") )
    then Hero.x = Hero.x + Hero.speed.walk * Hero.sign end
    myMap.mov = false
  else
    myMap.mov = true
  end
  
  -- stop the map when no arrow key is pressed
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
  
  if Hero.mov == "stand" then love.graphics.draw(Hero.pic,
                                                 Hero.x, Hero.y, 0,
                                                 Hero.sign * Hero.scale, 1 * Hero.scale,
                                                 Hero.w/2, 1) end
  if Hero.mov == "jump" then love.graphics.draw(Hero.jumpPic,
                                                Hero.x, Hero.y, 0,
                                                Hero.sign * Hero.scale, 1 * Hero.scale,
                                                Hero.w/2, 1) end
  if Hero.mov == "fall" then love.graphics.draw(Hero.fallPic,
                                                Hero.x, Hero.y, 0,
                                                Hero.sign * Hero.scale, 1 * Hero.scale,
                                                Hero.w/2, 1) end
  if Hero.mov == "walk" then love.graphics.draw(Hero.anim, Hero.animWalk[math.floor(Hero.picCurrent)],
                                                Hero.x, Hero.y, 0,
                                                Hero.sign * Hero.scale, 1 * Hero.scale,
                                                Hero.w/2, 1) end
  
  love.graphics.printf("line : "..Hero.linFeet.." / column : "..Hero.colFeet, 10, 70, windowWidth, "left")
  
  love.graphics.circle("fill", Hero.xFeet, Hero.yFeet, 2)
  love.graphics.circle("fill", Hero.x - (Hero.w * Hero.scale)/2, Hero.y + (Hero.h * Hero.scale)/2, 2)
  love.graphics.circle("fill", Hero.xFeet, Hero.y, 2)
  love.graphics.circle("fill", Hero.x + (Hero.w * Hero.scale) - (Hero.w * Hero.scale)/2, Hero.y + (Hero.h * Hero.scale)/2, 2)
  
  -- standard jump
  --love.graphics.line(0, myMap.size.pixH - (32 - 1) - (4*32), windowWidth, myMap.size.pixH - (32 - 1) - (4*32))
  
end


return Hero