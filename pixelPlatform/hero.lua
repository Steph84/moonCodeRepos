local Hero = {}

local windowWidth, windowHeight, TILE_SIZE
local myMap = require("map")
local myEnemy = require("enemy")
local textureUnder, textureAbove, textureLeft, textureRight = 0, 0, 0, 0
local groundCollision = false
local timeElapsedAttack = 0
local timeElapsedAnimHit = 0
local isBlinking = false
local ScaleLevel = {}
local ThresholdLevel = {}

function Hero.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  Hero.isDead = false
  Hero.pic = love.graphics.newImage("pictures/char01Stand.png") -- standing pic
  Hero.w = Hero.pic:getWidth()
  Hero.h = Hero.pic:getHeight()
  Hero.x = windowWidth/5
  Hero.y = 200
  Hero.jumpPic = love.graphics.newImage("pictures/char01Jump.png")
  Hero.fallPic = love.graphics.newImage("pictures/char01Fall.png")
  Hero.pitDeathPic = love.graphics.newImage("pictures/char01PitDeath.png")
  Hero.attackPic = love.graphics.newImage("pictures/char01Attack.png")
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
  
  Hero.attack = false
  Hero.hitted = false
  Hero.health = 0
  Hero.maxHealth = 0
  Hero.healthBar = 0
  Hero.ptsAttack = 0
  Hero.ptsDefense = 0
  Hero.level = 1
  Hero.xp = 0
  Hero.xpBar = 0
  Hero.xpMax = 0
  
  Hero.animHit = false
  Hero.animHitSpeedX = 5
  Hero.animHitSpeedY = 5
  
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
  
  ThresholdLevel[1] = 0
  local thigh
  for thigh = 2, 25 do
    ThresholdLevel[thigh] = math.ceil(2.5 * thigh^2 - 3 * thigh + 10)
  end
  
  Hero.health = math.random(8, 12)
  Hero.maxHealth = Hero.health
  Hero.ptsAttack = math.random(4, 6)
  Hero.ptsDefense = math.random(1, 3)
  Hero.xpMax = ThresholdLevel[2]
  
end

function Hero.Update(dt)
  
  if Hero.isDead == false then
    
    Hero.healthBar = Hero.health/Hero.maxHealth
    Hero.xpBar = Hero.xp/Hero.xpMax
    
    -- calculate the position of the feet in pixel
    Hero.xFeet = Hero.x - Hero.sign * 10 + (Hero.w * Hero.scale)/2 - (Hero.w * Hero.scale)/2 -- the (- Hero.w/2) is for centered sprite
    Hero.yFeet = Hero.y + Hero.h * Hero.scale - 2
    -- calculate the position of the head in pixel
    Hero.xHead = Hero.x - Hero.sign * 10
    Hero.yHead = Hero.y + 5

    if Hero.attack == false then
      
      if Hero.sign == 1 then
        Hero.xLeft = Hero.x - (Hero.w * Hero.scale)/2 + 28
        Hero.xRight = Hero.x + (Hero.w * Hero.scale)/2 - 48
      end
      if Hero.sign == -1 then
        Hero.xLeft = Hero.x - (Hero.w * Hero.scale)/2 + 48
        Hero.xRight = Hero.x + (Hero.w * Hero.scale)/2 - 28
      end
      -- calculate the postion of the left in pixel
      Hero.yLeft = Hero.y + (Hero.h * Hero.scale)/2
      -- calculate the postion of the right in pixel
      Hero.yRight = Hero.y + (Hero.h * Hero.scale)/2
    elseif Hero.attack == true then
      
      if Hero.sign == 1 then
        Hero.xLeft = Hero.x - (Hero.w * Hero.scale)/2 + 30
        Hero.xRight = Hero.x + (Hero.w * Hero.scale)/2 - 1
      end
      if Hero.sign == -1 then
        Hero.xLeft = Hero.x - (Hero.w * Hero.scale)/2 + 1
        Hero.xRight = Hero.x + (Hero.w * Hero.scale)/2 - 30
      end
      
      Hero.yLeft = Hero.y + (Hero.h * Hero.scale)/2
      Hero.yRight = Hero.y + (Hero.h * Hero.scale)/2
    end
    
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
    
    textureUnder = myMap.grid[Hero.linFeet][Hero.colFeet].texture
    textureAbove = myMap.grid[Hero.linHead][Hero.colHead].texture
    textureLeft = myMap.grid[Hero.linLeft][Hero.colLeft].texture
    textureRight = myMap.grid[Hero.linRight][Hero.colRight].texture
    
    -- standard movements
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
    
    -- manage the attack animation
    if (Hero.mov == "walk" or Hero.mov == "jump" or Hero.mov == "fall" or Hero.mov == "stand")
    and love.keyboard.isDown("e") and Hero.attack == false then
      Hero.attack = true
    end
    if Hero.attack == true then
      timeElapsedAttack = timeElapsedAttack + dt
      if timeElapsedAttack > 0.3 then
        timeElapsedAttack = 0
        Hero.attack = false
      end
    end
    
    -- manage the movement along x
    if ( Hero.mov == "walk" or Hero.mov == "jump" or Hero.mov == "fall" or Hero.animHit == true) -- actions allow to move along x
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
    if (textureLeft == "ground" and love.keyboard.isDown("left"))
    or (textureRight == "ground" and love.keyboard.isDown("right")) then
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

    if (Hero.yFeet > myMap.size.pixH - 12 or Hero.health <= 0) and Hero.isDead == false then
      -- death animation
      Hero.isDead = true
      Hero.Dead = {}
      Hero.Dead.x = Hero.x
      Hero.Dead.y = Hero.y
      Hero.Dead.vy = -5
      Hero.Dead.rot = 0
      Hero.speed.alongY = 0
      Hero.speed.alongX = 0
    end
    
    if Hero.animHit == true then
      timeElapsedAnimHit = timeElapsedAnimHit + dt
      
      if timeElapsedAnimHit < 0.1 or timeElapsedAnimHit > 0.4
         or (timeElapsedAnimHit > 0.2 and timeElapsedAnimHit < 0.3) then
          isBlinking = true
      else isBlinking = false
      end
    
      if timeElapsedAnimHit > 0.5 then
        timeElapsedAnimHit = 0
        Hero.animHit = false
        Hero.hitted = false
      end
    end
  end
  
  
  if Hero.xp > ThresholdLevel[Hero.level] then
    
    Hero.xp = Hero.xp - ThresholdLevel[Hero.level]
    Hero.level = Hero.level + 1
    Hero.xpMax = ThresholdLevel[Hero.level]
    
    local t = myEnemy.countDeadBodies
    local key, max = 1, t[1]
    for k, v in ipairs(t) do
        if t[k] > max then
            key, max = k, v
        end
    end

    if key == 1 then
      Hero.health = Hero.health + 2
      Hero.maxHealth = Hero.maxHealth + 2
      Hero.ptsAttack = Hero.ptsAttack + 1
      Hero.ptsDefense = Hero.ptsDefense + 0
    elseif key == 2 then
      Hero.health = Hero.health + 4
      Hero.maxHealth = Hero.maxHealth + 4
      Hero.ptsAttack = Hero.ptsAttack + 2
      Hero.ptsDefense = Hero.ptsDefense + 1
    elseif key == 3 then
      Hero.health = Hero.health + 8
      Hero.maxHealth = Hero.maxHealth + 8
      Hero.ptsAttack = Hero.ptsAttack + 4
      Hero.ptsDefense = Hero.ptsDefense + 3
    end
    
    myEnemy.countDeadBodies = {0, 0, 0}
  end
  
  if Hero.isDead == true then
    Hero.Dead.y = Hero.Dead.y + Hero.Dead.vy
    Hero.Dead.vy = Hero.Dead.vy + 9.81 * dt
    Hero.Dead.rot = Hero.Dead.rot + 2 * dt
  end
  
end

function Hero.Draw()
  
  if Hero.isDead == false then
    if Hero.animHit == false then
      if Hero.attack == true then love.graphics.draw(Hero.attackPic,
                                                     Hero.x, Hero.y, 0,
                                                     Hero.sign * Hero.scale, 1 * Hero.scale,
                                                     Hero.w/2, 1)
      else
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
    elseif Hero.animHit == true then
      if isBlinking == false then
        love.graphics.draw(Hero.pitDeathPic,
                           Hero.x, Hero.y, 0,
                           Hero.sign * Hero.scale, 1 * Hero.scale,
                           Hero.w/2, 1)
      end
    end
  end    
  
  
  if Hero.isDead == true then love.graphics.draw(Hero.pitDeathPic, Hero.Dead.x, Hero.Dead.y, Hero.Dead.rot,
                                                 Hero.sign * Hero.scale, 1 * Hero.scale,
                                                 Hero.w/2, 1) end
  
end

return Hero