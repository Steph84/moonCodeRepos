local Enemy = {}

local windowWidth, windowHeight, TILE_SIZE
local textureUnder, textureBeforeFeet, textureAfterFeet, textureBefore, textureAfter
local listEnemies = {}

function Enemy.Load(pId, pWindowWidth, pWindowHeight, pTileSize, pMapSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  local item = {}
  
  item.id = pId
  item.isDead = false
  item.mov = "stand"
  item.speed = {}
  item.speed.walk = math.random(5, 15)/10
  item.speed.animWalk = 10
  item.speed.alongY = 5
  item.animWalk = {}
  item.picCurrent = 1
  item.mov = "walk"
  item.dir = "right"
  item.sign = 1
  item.scale = 1.5
  item.w = 32
  item.h = 32
  item.x = math.random(windowWidth * 0.75, pMapSize.pixW - windowWidth * 0.75)
  item.y = 100
  
  item.animHit = false
  item.hitted = false
  item.animHitSpeedX = 5
  item.animHitSpeedY = 5
  item.health = 3
  item.ptsAttack = 3
  item.ptsDefense = 1
  
  item.Dead = {}
  item.Dead.rot = 3.14
  
  -- load the animation walking tile
  item.anim = love.graphics.newImage("pictures/enemy01Walk.png")
  local nbColumns = item.anim:getWidth() / 32
  local nbLines = item.anim:getHeight() / 32
  
  -- extract all the frames in the animation walking tile
  local l, c
  local id = 1
  item.animWalk[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    item.animWalk[id] = love.graphics.newQuad((c-1)*item.w, (l-1)*item.h,
                                              item.w, item.h,
                                              item.anim:getDimensions())
    id = id + 1
    end
  end
  table.insert(listEnemies, item)
  
end

function Enemy.Update(dt, pMap, pHero)
  
  for item = 1, #listEnemies do
    local e = listEnemies[item]
  
    if e.isDead == false then
      -- manage the walking animation
      if e.mov == "walk" then e.picCurrent = e.picCurrent + (e.speed.animWalk * dt) end
      if math.floor(e.picCurrent) > #e.animWalk then e.picCurrent = 1 end
      
      -- calculate the position of the feet in pixel
      e.xFeet = e.x + (e.w * e.scale)/2 - (e.w * e.scale)/2 -- the (- e.w/2) is for centered sprite
      e.yFeet = e.y + e.h * e.scale
      -- calculate the position of the feet in line and columns
      e.linFeet = math.ceil(e.yFeet / TILE_SIZE)
      e.colFeet = math.ceil((e.xFeet - pMap.grid[1][1].x) / TILE_SIZE)
      
      -- calculate the position of the left and right in pixel
      e.xCenter = e.x + (e.w * e.scale)/2
      e.yCenter = e.y + (e.h * e.scale)/2
      -- calculate the position of the left and right in line and columns
      e.colCenter = math.ceil((e.xCenter - pMap.grid[1][1].x) / TILE_SIZE)
      e.linCenter = math.ceil(e.yCenter / TILE_SIZE)
      
      -- stay on the ground
      textureUnder = pMap.grid[e.linFeet][e.colFeet].texture
      -- avoid fall into pit
      textureBeforeFeet = pMap.grid[e.linFeet][e.colFeet - 1].texture
      textureAfterFeet = pMap.grid[e.linFeet][e.colFeet + 1].texture
      -- avoid walking through hill
      textureBefore = pMap.grid[e.linFeet - 1][e.colFeet - 1].texture
      textureAfter = pMap.grid[e.linFeet - 1][e.colFeet + 1].texture
    
      if textureUnder == "ground" then e.mov = "walk" end
      if textureUnder == "void" then e.mov = "fall" end -- fall when no more ground
      
      if e.mov == "walk" then
        e.y = pMap.grid[e.linFeet][e.colFeet].y - (e.h * e.scale - 8) -- put the e on top of the ground
        
        e.x = e.x + e.speed.walk * e.sign
        
        -- avoid walking through hill
        if textureBefore == "ground" and e.dir == "left" then
          e.dir = "right"
          e.sign = -1 * e.sign
        end
        if textureAfter == "ground" and e.dir == "right" then
          e.dir = "left"
          e.sign = -1 * e.sign
        end
        
        if pMap.mov == true then
          e.x = e.x - pHero.speed.walk * pHero.sign
        end
        
        if e.dir == "right" and (textureAfterFeet == "void" or (e.colFeet + 1) == pMap.size.w) then
          e.dir = "left"
          e.sign = -1 * e.sign
        end
        
        if e.dir == "left" and (textureBeforeFeet == "void" or (e.colFeet - 1) == 1) then
          e.dir = "right"
          e.sign = -1 * e.sign
        end
        
      end
      
      -- manage the movement along y
      if e.mov == "fall" then
        e.y = e.y - e.speed.alongY
        e.speed.alongY = e.speed.alongY - dt*9.81
      else
        e.speed.alongY = 5
      end
      
      -- condition for death
      if e.health < 0 then
        e.isDead = true
        e.Dead.y = e.y
        e.Dead.x = e.x
      end
    end
    
    -- death animation
    if e.isDead == true then
      e.Dead.y = e.Dead.y - e.speed.alongY
      e.speed.alongY = e.speed.alongY - dt*9.81
      if e.Dead.y > windowHeight then e = {} end
    end
  end
end

function Enemy.Draw()
  
  for item = 1, #listEnemies do
    local e = listEnemies[item]
  
    if e.isDead == false then
      if e.x > (0 - 32) and e.x < (windowWidth + 32) then
        love.graphics.draw(e.anim, e.animWalk[math.floor(e.picCurrent)],
                           e.x, e.y, 0,
                           e.sign * e.scale, 1 * e.scale,
                           e.w/2, 1)
      end
      
      love.graphics.setColor(0, 0, 0)
      love.graphics.printf("health : "..e.health, e.x - 16, e.y - 16, windowWidth, "left")
      love.graphics.setColor(255, 255, 255)
    end
    
    if e.isDead == true then
      love.graphics.draw(e.anim, e.animWalk[math.floor(e.picCurrent)],
                         e.Dead.x, e.Dead.y, e.Dead.rot,
                         e.sign * e.scale, 1 * e.scale,
                         e.w/2, 1)
    end
  end
  
end

return Enemy