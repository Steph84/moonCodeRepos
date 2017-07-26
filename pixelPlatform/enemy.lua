local Enemy = {}

local windowWidth, windowHeight, TILE_SIZE
local textureUnder, textureBeforeFeet, textureAfterFeet

function Enemy.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  Enemy.isDead = false
  Enemy.mov = "stand"
  Enemy.speed = {}
  Enemy.speed.walk = 1
  Enemy.speed.animWalk = 10
  Enemy.speed.alongY = 5
  Enemy.animWalk = {}
  Enemy.picCurrent = 1
  Enemy.mov = "walk"
  Enemy.dir = "right"
  Enemy.sign = 1
  Enemy.scale = 1.5
  Enemy.w = 32
  Enemy.h = 32
  Enemy.x = 500
  Enemy.y = 300
  
  Enemy.animHit = false
  Enemy.hitted = false
  Enemy.animHitSpeedX = 5
  Enemy.animHitSpeedY = 5
  Enemy.health = 3
  Enemy.ptsAttack = 3
  Enemy.ptsDefense = 1
  
  Enemy.Dead = {}
  Enemy.Dead.rot = 3.14
  
  -- load the animation walking tile
  Enemy.anim = love.graphics.newImage("pictures/enemy01Walk.png")
  local nbColumns = Enemy.anim:getWidth() / 32
  local nbLines = Enemy.anim:getHeight() / 32
  
  -- extract all the frames in the animation walking tile
  local l, c
  local id = 1
  Enemy.animWalk[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    Enemy.animWalk[id] = love.graphics.newQuad((c-1)*Enemy.w, (l-1)*Enemy.h,
                                              Enemy.w, Enemy.h,
                                              Enemy.anim:getDimensions())
    id = id + 1
    end
  end
end

function Enemy.Update(dt, pMap, pHero)
  
  if Enemy.isDead == false then
    -- manage the walking animation
    if Enemy.mov == "walk" then Enemy.picCurrent = Enemy.picCurrent + (Enemy.speed.animWalk * dt) end
    if math.floor(Enemy.picCurrent) > #Enemy.animWalk then Enemy.picCurrent = 1 end
    
    -- calculate the position of the feet in pixel
    Enemy.xFeet = Enemy.x + (Enemy.w * Enemy.scale)/2 - (Enemy.w * Enemy.scale)/2 -- the (- Enemy.w/2) is for centered sprite
    Enemy.yFeet = Enemy.y + Enemy.h * Enemy.scale
    -- calculate the position of the feet in line and columns
    Enemy.linFeet = math.ceil(Enemy.yFeet / TILE_SIZE)
    Enemy.colFeet = math.ceil((Enemy.xFeet - pMap.grid[1][1].x) / TILE_SIZE)
    
    textureUnder = pMap.grid[Enemy.linFeet][Enemy.colFeet].texture
    textureBeforeFeet = pMap.grid[Enemy.linFeet][Enemy.colFeet - 1].texture
    textureAfterFeet = pMap.grid[Enemy.linFeet][Enemy.colFeet + 1].texture
  
    if textureUnder == "ground" then Enemy.mov = "walk" end
    if textureUnder == "void" then Enemy.mov = "fall" end -- fall when no more ground
    
    if Enemy.mov == "walk" then
      Enemy.y = pMap.grid[Enemy.linFeet][Enemy.colFeet].y - (Enemy.h * Enemy.scale - 8) -- put the Enemy on top of the ground
      
      Enemy.x = Enemy.x + Enemy.speed.walk * Enemy.sign
      if pMap.mov == true then
        Enemy.x = Enemy.x - pHero.speed.walk * pHero.sign
      end
      
      if Enemy.dir == "right" and (textureAfterFeet == "void" or (Enemy.colFeet + 1) == pMap.size.w) then
        Enemy.dir = "left"
        Enemy.sign = -1 * Enemy.sign
      end
      
      if Enemy.dir == "left" and (textureBeforeFeet == "void" or (Enemy.colFeet - 1) == 1) then
        Enemy.dir = "right"
        Enemy.sign = -1 * Enemy.sign
      end
      
    end
    
    -- manage the movement along y
    if Enemy.mov == "fall" then
      Enemy.y = Enemy.y - Enemy.speed.alongY
      Enemy.speed.alongY = Enemy.speed.alongY - dt*9.81
    else
      Enemy.speed.alongY = 5
    end
    
    -- condition for death
    if Enemy.health < 0 then
      Enemy.isDead = true
      Enemy.Dead.y = Enemy.y
      Enemy.Dead.x = Enemy.x
    end
  end
  
  -- death animation
  if Enemy.isDead == true then
    Enemy.Dead.y = Enemy.Dead.y - Enemy.speed.alongY
    Enemy.speed.alongY = Enemy.speed.alongY - dt*9.81
    if Enemy.Dead.y > windowHeight then Enemy = {} end
  end
end

function Enemy.Draw()
  if Enemy.isDead == false then
    if Enemy.x > (0 - 32) and Enemy.x < (windowWidth + 32) then
      love.graphics.draw(Enemy.anim, Enemy.animWalk[math.floor(Enemy.picCurrent)],
                         Enemy.x, Enemy.y, 0,
                         Enemy.sign * Enemy.scale, 1 * Enemy.scale,
                         Enemy.w/2, 1)
    end
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("health : "..Enemy.health, Enemy.x - 16, Enemy.y - 16, windowWidth, "left")
    love.graphics.setColor(255, 255, 255)
  end
  
  if Enemy.isDead == true then
    love.graphics.draw(Enemy.anim, Enemy.animWalk[math.floor(Enemy.picCurrent)],
                       Enemy.Dead.x, Enemy.Dead.y, Enemy.Dead.rot,
                       Enemy.sign * Enemy.scale, 1 * Enemy.scale,
                       Enemy.w/2, 1)
  end
  
end

return Enemy