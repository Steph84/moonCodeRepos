local Enemy = {}

local windowWidth, windowHeight, TILE_SIZE
local textureUnder, textureBeforeFeet, textureAfterFeet, textureBefore, textureAfter
local timeElapsedAnimHit = 0
local isBlinking = false

Enemy.listEnemies = {}
Enemy.countDeadBodies = {}

function Enemy.Load(pId, pType, pWindowWidth, pWindowHeight, pTileSize, pMapSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  local item = {}
  
  item.id = pId
  item.type = pType
  item.isDead = false
  item.mov = "stand"
  item.speed = {}
  item.speed.alongY = 5
  item.animWalk = {}
  item.picCurrent = 1
  item.mov = "walk"
  item.dir = "left"
  item.sign = - 1
  item.scale = 1.5
  item.x = math.random(windowWidth * 0.75, pMapSize.pixW - windowWidth * 0.75)
  item.y = 100
  
  item.animHit = false
  item.hitted = false
  item.animHitSpeedX = 5
  item.counter = 0
  
  item.Dead = {}
  item.Dead.rot = 3.14
  
  if pType == 1 then
    item.w = 32
    item.h = 32
    item.speed.walk = 0.5 --math.random(5, 15)/10
    item.speed.animWalk = 10
    item.health = 10
    item.maxHealth = 10
    item.ptsAttack = 3
    item.ptsDefense = 1
    item.level = 1
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
  end
  
  if pType == 2 then
    item.w = 64
    item.h = 64
    item.speed.walk = math.random(2, 7)/10
    item.speed.animWalk = 7
    item.health = 20
    item.maxHealth = 20
    item.ptsAttack = 4
    item.ptsDefense = 4
    item.level = 1
    -- load the animation walking tile
    item.anim = love.graphics.newImage("pictures/tankWalking.png")
    local nbColumns = item.anim:getWidth() / 64
    local nbLines = item.anim:getHeight() / 64
    
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
  end
  
  table.insert(Enemy.listEnemies, item)
  
  Enemy.countDeadBodies = {underLv = 0, sameLv = 0, aboveLv = 0}
  
end

function Enemy.Update(dt, pMap, pHero)
  
  if #Enemy.listEnemies > 0 then
    for item = #Enemy.listEnemies, 1, -1 do
      local e = Enemy.listEnemies[item]
    
      if e.isDead == false then
        
        e.healthBar = e.health/e.maxHealth
        
        -- manage the walking animation
        if e.mov == "walk" then e.picCurrent = e.picCurrent + (e.speed.animWalk * dt) end
        if math.floor(e.picCurrent) > #e.animWalk then e.picCurrent = 1 end
        
        if e.type == 1 then
          -- calculate the position of the feet in pixel
          e.xFeet = e.x + (e.w * e.scale)/2 - (e.w * e.scale)/2 -- the (- e.w/2) is for centered sprite
          e.yFeet = e.y + e.h * e.scale - 2
          -- calculate the position of the head in pixel
          e.xHead = e.x
          e.yHead = e.y + 3
          -- calculate the position of the left and right in pixel in relation to the type of enemy
          e.xLeft = e.x - e.w * e.scale / 2 + 5
          e.yLeft = e.y + e.h * e.scale / 2
          e.xRight = e.x + e.w * e.scale / 2 - 5
          e.yRight = e.y + e.h * e.scale / 2
        
        elseif e.type == 2 then
          -- calculate the position of the feet in pixel
          e.xFeet = e.x - e.sign * (e.w * e.scale)/5
          e.yFeet = e.y + e.h * e.scale - 2
          -- calculate the position of the head in pixel
          e.xHead = e.x - e.sign * (e.w * e.scale)/5
          e.yHead = e.y + 3
          -- calculate the position of the left and right in pixel in relation to the type of enemy
          e.xLeft = e.x - e.w * e.scale / 2 + 5
          e.yLeft = e.y + e.h * e.scale / 2
          e.xRight = e.x + e.w * e.scale / 2 - 5
          e.yRight = e.y + e.h * e.scale / 2
        end
        
        -- calculate the position of the feet in line and columns
        e.linFeet = math.ceil(e.yFeet / TILE_SIZE)
        e.colFeet = math.ceil((e.xFeet - pMap.grid[1][1].x) / TILE_SIZE)

        -- calculate the position of the left and right in line and columns
        e.colLeft = math.ceil((e.xLeft - pMap.grid[1][1].x) / TILE_SIZE)
        e.linLeft = math.ceil(e.yLeft / TILE_SIZE)
        e.colRight = math.ceil((e.xRight - pMap.grid[1][1].x) / TILE_SIZE)
        e.linRight = math.ceil(e.yRight / TILE_SIZE)
        
        e.xCenter = e.x
        e.yCenter = e.y + (e.h * e.scale)/2
        -- calculate the position of the left and right in line and columns
        e.colCenter = math.ceil((e.xCenter - pMap.grid[1][1].x) / TILE_SIZE)
        e.linCenter = math.ceil(e.yCenter / TILE_SIZE)
        
        -- stay on the ground
        textureUnder = pMap.grid[e.linFeet][e.colFeet].texture
        
        -- avoid walking through hill
        textureBefore = pMap.grid[e.linLeft][e.colLeft].texture
        textureAfter = pMap.grid[e.linRight][e.colRight].texture
        
        if e.type == 1 then
          -- avoid fall into pit
          textureBeforeFeet = pMap.grid[e.linLeft + 1][e.colLeft].texture
          textureAfterFeet = pMap.grid[e.linRight + 1][e.colRight].texture
        elseif e.type == 2 then
          -- avoid fall into pit
          textureBeforeFeet = pMap.grid[e.linLeft + 2][e.colLeft].texture
          textureAfterFeet = pMap.grid[e.linRight + 2][e.colRight].texture
        end
      
        if textureUnder == "ground" then e.mov = "walk" end
        if textureUnder == "void" then e.mov = "fall" end -- fall when no more ground
        
        if e.mov == "walk" then
          e.y = pMap.grid[e.linFeet][e.colFeet].y - (e.h * e.scale - 8) -- put the e on top of the ground
          
          if e.hitted == false then
            e.x = e.x + e.speed.walk * e.sign
          end
          
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
          
          if e.dir == "right" and (textureAfterFeet == "void" or e.colRight > pMap.size.w - 1) then
            e.dir = "left"
            e.sign = -1 * e.sign
          end
          
          if e.dir == "left" and (textureBeforeFeet == "void" or e.colLeft < 2) then
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
        if e.health <= 0 then
          e.isDead = true
          e.Dead.y = e.y
          e.Dead.x = e.x
          e.Dead.scale = e.scale
          e.Dead.sign = e.sign
          e.Dead.w = e.w
        end
      end
      
      -- remove enemy from the list if spawn into a pit
      if e.yFeet > pMap.size.pixH - 32 and e.isDead == false then
        table.remove(Enemy.listEnemies, item)
      end
      
      if e.animHit == true then
        timeElapsedAnimHit = timeElapsedAnimHit + dt
        
        if timeElapsedAnimHit < 0.1 or timeElapsedAnimHit > 0.4
           or (timeElapsedAnimHit > 0.2 and timeElapsedAnimHit < 0.3) then
            isBlinking = true
        else isBlinking = false
        end
      
        if timeElapsedAnimHit > 0.5 then
          timeElapsedAnimHit = 0
          e.animHit = false
          e.hitted = false
        end
      end
      
      --print(Enemy.countDeadBodies.underLv, Enemy.countDeadBodies.sameLv, Enemy.countDeadBodies.aboveLv)
      -- death animation
      if e.isDead == true then
        e.Dead.y = e.Dead.y - e.speed.alongY
        e.speed.alongY = e.speed.alongY - dt*9.81
        if e.Dead.y > windowHeight then 
          pHero.xp = pHero.xp + 10
          if e.level < pHero.level then Enemy.countDeadBodies.underLv = Enemy.countDeadBodies.underLv + 1 end
          if e.level == pHero.level then Enemy.countDeadBodies.sameLv = Enemy.countDeadBodies.sameLv + 1 end
          if e.level > pHero.level then Enemy.countDeadBodies.aboveLv = Enemy.countDeadBodies.aboveLv + 1 end
          table.remove(Enemy.listEnemies, item)
        end
      end
    end
  end
end


function Enemy.Draw()
  
  for item = 1, #Enemy.listEnemies do
    local e = Enemy.listEnemies[item]
  
    if e.isDead == false then
      if e.x > (0 - 64) and e.x < (windowWidth + 64) then
        if e.animHit == false or (e.animHit == true and isBlinking == false) then
          
          -- manage color of the health bar
          if e.healthBar >= 0.5 then love.graphics.setColor(0, 128, 0)
          elseif e.healthBar < 0.5 and e.healthBar >= 0.2 then love.graphics.setColor(255, 192, 0)
          elseif e.healthBar < 0.2 then love.graphics.setColor(255, 0, 0) end
          
          love.graphics.rectangle("fill", e.x - (e.w * e.scale)/2, e.y - 16, (e.healthBar)*(e.w * e.scale), 5)
          love.graphics.setColor(255, 255, 255)
          
          love.graphics.draw(e.anim, e.animWalk[math.floor(e.picCurrent)],
                             e.x, e.y, 0,
                             e.sign * e.scale, 1 * e.scale,
                             e.w/2, 1)
        end
      end
      
      
    end
    
    --[[
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", e.xFeet, e.yFeet, 2)
    love.graphics.circle("fill", e.xHead, e.yHead, 2)
    love.graphics.circle("fill", e.xLeft, e.yLeft, 2)
    love.graphics.circle("fill", e.xRight, e.yRight, 2)
    love.graphics.setColor(255, 255, 255)
    --]]
    
    if e.isDead == true then
      love.graphics.draw(e.anim, e.animWalk[math.floor(e.picCurrent)],
                         e.Dead.x, e.Dead.y, e.Dead.rot,
                         e.Dead.sign * e.Dead.scale, 1 * e.Dead.scale,
                         e.Dead.w/2, 1)
    end
  end
  
end

return Enemy