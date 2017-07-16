local Hero = {}

local windowWidth, windowHeight, TILE_SIZE
local myMap = require("map")
local myCollision = require("collisionManage")
local textureUnder, textureAbove, textureLeft, textureRight = 0, 0, 0, 0
local heroIsDead = false

function Hero.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  myMap.Load(windowWidth, windowHeight, TILE_SIZE)
  
  Hero.pic = love.graphics.newImage("pictures/char01Stand.png") -- standing pic
  Hero.w = Hero.pic:getWidth()
  Hero.h = Hero.pic:getHeight()
  Hero.x = windowWidth/5
  Hero.y = 200
  Hero.jumpPic = love.graphics.newImage("pictures/char01Jump.png")
  Hero.fallPic = love.graphics.newImage("pictures/char01Fall.png")
  Hero.pitDeathPic = love.graphics.newImage("pictures/char01PitDeath.png")
  Hero.scale = 2
  
  Hero.wall = 0.6 -- threshold to stop the Hero and moving the map
  
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
  
  if heroIsDead == false then
    -- calculate the position of the feet in pixel
    Hero.xFeet = Hero.x + (Hero.w * Hero.scale)/2 - (Hero.w * Hero.scale)/2 -- the (- Hero.w/2) is for centered sprite
    Hero.yFeet = Hero.y + Hero.h * Hero.scale
    -- calculate the position of the head in pixel
    Hero.xHead = Hero.x + (Hero.w * Hero.scale)/2 - (Hero.w * Hero.scale)/2 -- the (- Hero.w/2) is for centered sprite
    Hero.yHead = Hero.y
    -- calculate the postion of the left in pixel
    Hero.xLeft = Hero.x - (Hero.w * 0.6 * Hero.scale)/2 -- 0.6 is for match to the Hero's body and not the sprite
    Hero.yLeft = Hero.y + (Hero.h * Hero.scale)/2
    -- calculate the postion of the right in pixel
    Hero.xRight = Hero.x + (Hero.w * 0.6 * Hero.scale)/2
    Hero.yRight = Hero.y + (Hero.h * Hero.scale)/2
    
    -- upperleft corner
    Hero.xLeftHead = Hero.x - (Hero.w * 0.1 * Hero.scale)
    Hero.yLeftHead = Hero.y + (Hero.h * 0.05 * Hero.scale)
    -- upperright corner
    Hero.xRightHead = Hero.x + (Hero.w * 0.1 * Hero.scale)
    Hero.yRightHead = Hero.y + (Hero.h * 0.05 * Hero.scale)
    -- bottomleft corner
    Hero.xLeftFoot = Hero.x - (Hero.w * 0.1 * Hero.scale)
    Hero.yLeftFoot = Hero.y + Hero.h * Hero.scale
    -- bottomright corner
    Hero.xRightFoot = Hero.x + (Hero.w * 0.1 * Hero.scale)
    Hero.yRightFoot = Hero.y + Hero.h * Hero.scale
    
    -- calculate the position of the feet in line and columns
    Hero.linFeet = math.ceil(Hero.yFeet / TILE_SIZE)
    Hero.colFeet = math.ceil((Hero.xFeet - myMap.grid[1][1].x) / TILE_SIZE)
    -- calculate the position of the head in line and columns
    Hero.linHead = math.ceil(Hero.yHead / TILE_SIZE)
    Hero.colHead = math.ceil((Hero.xHead - myMap.grid[1][1].x) / TILE_SIZE)
    -- calculate the position of the left in line and columns
    Hero.linLeft = math.ceil(Hero.yLeft / TILE_SIZE)
    Hero.colLeft = math.ceil((Hero.xLeft - myMap.grid[1][1].x) / TILE_SIZE)
    if Hero.colLeft == 0 or Hero.colLeft == -1 then Hero.colLeft = 1 end -- manage the boundaries
    -- calculate the position of the right in line and columns
    Hero.linRight = math.ceil(Hero.yRight / TILE_SIZE)
    Hero.colRight = math.ceil((Hero.xRight - myMap.grid[1][1].x) / TILE_SIZE)
    if Hero.colRight == myMap.size.w + 1
    or Hero.colRight == myMap.size.w + 2 then
      Hero.colRight = myMap.size.w end -- manage the boundaries
      
    -- upperleft corner
    Hero.colLeftHead = math.ceil((Hero.xLeftHead - myMap.grid[1][1].x) / TILE_SIZE)
    Hero.linLeftHead = math.ceil(Hero.yLeftHead / TILE_SIZE)
    -- upperright corner
    Hero.colRightHead = math.ceil((Hero.xRightHead - myMap.grid[1][1].x) / TILE_SIZE)
    Hero.linRightHead = math.ceil(Hero.yRightHead / TILE_SIZE)
    -- bottomleft corner
    Hero.colLeftFoot = math.ceil((Hero.xLeftFoot - myMap.grid[1][1].x) / TILE_SIZE)
    Hero.linLeftFoot = math.ceil(Hero.yLeftFoot / TILE_SIZE)
    -- bottomright corner
    Hero.colRightFoot = math.ceil((Hero.xRightFoot - myMap.grid[1][1].x) / TILE_SIZE)
    Hero.linRightFoot = math.ceil(Hero.yRightFoot / TILE_SIZE)
    
    --textureUnder = myMap.grid[Hero.linFeet][Hero.colFeet].texture
    --textureAbove = myMap.grid[Hero.linHead][Hero.colHead].texture
    --textureLeft = myMap.grid[Hero.linLeft][Hero.colLeft].texture
    --textureRight = myMap.grid[Hero.linRight][Hero.colRight].texture
    
    if myMap.grid[Hero.linLeftFoot][Hero.colLeftFoot].texture == "void"
    and myMap.grid[Hero.linRightFoot][Hero.colRightFoot].texture == "void" then
      textureUnder = "void"
    else textureUnder = "ground" end
    
    if myMap.grid[Hero.linLeftHead][Hero.colLeftHead].texture == "void"
    and myMap.grid[Hero.linRightHead][Hero.colRightHead].texture == "void" then
      textureAbove = "void"
    else textureAbove = "ground" end
    
    if myMap.grid[Hero.linLeftHead][Hero.colLeftHead].texture == "ground"
    and myMap.grid[Hero.linLeftFoot][Hero.colLeftFoot].texture == "ground" then
      textureLeft = "ground"
    else textureLeft = "void" end
    
    if myMap.grid[Hero.linRightHead][Hero.colRightHead].texture == "ground"
    and myMap.grid[Hero.linRightFoot][Hero.colRightFoot].texture == "ground" then
      textureRight = "ground"
    else textureRight = "void" end
    
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
    if (textureAbove == "ground" or Hero.y < 5) and Hero.mov == "jump" then
      Hero.mov = "fall"
      Hero.speed.alongY = - 0.5 -- initialize under 0 to avoid stick on the platform
      Hero.speed.alongX = 0
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
        Hero.y = myMap.grid[Hero.linFeet][Hero.colFeet].y - (Hero.h * Hero.scale - 8) -- put the Hero on top of the ground
      end
    end
    
    -- manage the walking animation
    if Hero.mov == "walk" then Hero.picCurrent = Hero.picCurrent + (Hero.speed.animWalk * dt) end
    if math.floor(Hero.picCurrent) > #Hero.animWalk then Hero.picCurrent = 1 end
    
    -- manage the movement along x
    if ( Hero.mov == "walk" or Hero.mov == "jump" or Hero.mov == "fall" ) -- actions allow to move along x
        and ( (love.keyboard.isDown("left") or love.keyboard.isDown("right")) -- press keyboard
            and ( (Hero.x > windowWidth*(1-Hero.wall) and Hero.x < windowWidth*Hero.wall) -- hero in the center part
                or ( Hero.x > 0 and Hero.x <= windowWidth*(1-Hero.wall) and myMap.grid[1][1].x > -1 ) -- hero left part
                or ( (Hero.x - Hero.w) < windowWidth and Hero.x >= windowWidth*Hero.wall and myMap.grid[myMap.size.h][myMap.size.w].x < (windowWidth - TILE_SIZE + 10) ) ) ) -- hero in the right part
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
    
    -- manage the lateral ground collision
    if textureLeft == "ground" and love.keyboard.isDown("left")
    or textureRight == "ground" and love.keyboard.isDown("right") then
      Hero.speed.walk = 0
    else Hero.speed.walk = 5 end
    
    -- manage the movement along y
    if Hero.mov == "jump" or Hero.mov == "fall" then
      Hero.y = Hero.y - Hero.speed.alongY
      Hero.speed.alongY = Hero.speed.alongY - dt*9.81
    end
    -- manage the status along y
    if Hero.speed.alongY > 0 then Hero.mov = "jump"
    elseif Hero.speed.alongY < 0 then Hero.mov = "fall" end

    if Hero.yFeet > myMap.size.pixH - 10 and heroIsDead == false then
      -- death animation
      heroIsDead = true
      Hero.Dead = {}
      Hero.Dead.x = Hero.x
      Hero.Dead.y = Hero.y
      Hero.Dead.vy = -5
      Hero.Dead.rot = 0
      Hero.speed.alongY = 0
      Hero.speed.alongX = 0
    end
  end
  
  if heroIsDead == true then
    Hero.Dead.y = Hero.Dead.y + Hero.Dead.vy
    Hero.Dead.vy = Hero.Dead.vy + 9.81 * dt
    Hero.Dead.rot = Hero.Dead.rot + 2 * dt
    
    -- if hero dead, load another sreen
    
  end
  
end

function Hero.Draw()
  myMap.Draw()
  
  if heroIsDead == false then
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
  end    
  
  if heroIsDead == true then love.graphics.draw(Hero.pitDeathPic,
                                                Hero.Dead.x, Hero.Dead.y, Hero.Dead.rot,
                                                Hero.sign * Hero.scale, 1 * Hero.scale,
                                                Hero.w/2, 1) end
  
  love.graphics.printf("line : "..Hero.linFeet.." / column : "..Hero.colFeet, 10, 70, windowWidth, "left")
  
  love.graphics.circle("fill", Hero.xFeet, Hero.yFeet, 2)
  love.graphics.circle("fill", Hero.xLeft, Hero.yLeft, 2)
  love.graphics.circle("fill", Hero.xHead, Hero.yHead, 2)
  love.graphics.circle("fill", Hero.xRight, Hero.yRight, 2)
  
  love.graphics.circle("fill", Hero.xLeftHead, Hero.yLeftHead, 2)
  love.graphics.circle("fill", Hero.xLeftFoot, Hero.yLeftFoot, 2)
  love.graphics.circle("fill", Hero.xRightHead, Hero.yRightHead, 2)
  love.graphics.circle("fill", Hero.xRightFoot, Hero.yRightFoot, 2)
  
end

return Hero