local Enemy = {}

local windowWidth, windowHeight, TILE_SIZE, mapSizePixW
local textureUnder, textureBeforeFeet, textureAfterFeet, textureBefore, textureAfter
local timeElapsedAnimHit = 0
local isBlinking = false
local mobCreation = 0

Enemy.listEnemies = {}
--               underLv, sameLv, aboveLv
Enemy.countDeadBodies = {0, 0, 0}
--                  goom, tank
Enemy.countDeadTypes = {0, 0}

Enemy.goomCount, Enemy.tankCount = {}, {}
Enemy.goomCount.inf = 0
Enemy.goomCount.same = 0
Enemy.goomCount.sup = 0
Enemy.tankCount.inf = 0
Enemy.tankCount.same = 0
Enemy.tankCount.sup = 0

local countDifA = {min = 100, max = -100}
local countDifD = {min = 100, max = -100}

function Enemy.Load(pInstant, pType, pWindowWidth, pWindowHeight, pTileSize, pMapSize, pHeroLevel)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  mapSizePixW = pMapSize
  
  mobCreation = mobCreation + 1
  
  local item = {}
  
  item.id = mobCreation
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
  item.difA = 0
  item.difD = 0
  
  if pInstant == "load" then item.x = math.random(windowWidth * 0.7, pMapSize - windowWidth * 0.7) end -- spawn in the map
  if pInstant == "update" then item.x = math.random(windowWidth * 0.3, windowWidth * 0.7) end -- spawn in the window
  item.y = 100
  
  item.animHit = false
  item.hitted = false
  item.animHitSpeedX = 5
  item.counter = 0
  
  item.Dead = {}
  item.Dead.rot = 3.14
  
  if pInstant == "load" then item.level = math.random(1, 3) end -- level 1 to 3
  if pInstant == "update" then item.level = math.random(pHeroLevel + 1, pHeroLevel + 2) end -- level +1 to +2
    
  if pType == 1 then
    -- initialize level 1
    item.ptsAttack = math.random(3, 5)
    item.ptsDefense = math.random(1, 3)
    item.health = math.random(8, 12)
    
    -- modify if level > 1
    if item.level > 1 then
      item.ptsAttack = math.floor(2.5 * (item.level - 1) + item.ptsAttack)
      item.ptsDefense = math.floor(3 * (item.level - 1) + item.ptsDefense)
      item.health = math.floor(5 * (item.level - 1) + item.health)
    end
    
    item.maxHealth = item.health    
    
    item.w = 32
    item.h = 32
    item.speed.walk = math.random(5, 15)/10
    item.speed.animWalk = 10
    
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
    -- initialize level 1
    item.ptsAttack = math.random(5, 6)
    item.ptsDefense = math.random(5, 6)
    item.health = math.random(18, 22)
    
    if item.level > 1 then
      item.ptsAttack = math.floor(3.5 * (item.level - 1) + item.ptsAttack)
      item.ptsDefense = math.floor(4.5 * (item.level - 1) + item.ptsDefense)
      item.health = math.floor(10 * (item.level - 1) + item.health)
    end
    
    item.maxHealth = item.health
    
    item.w = 64
    item.h = 64
    item.speed.walk = math.random(2, 7)/10
    item.speed.animWalk = 7
    
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
end

function Enemy.Update(dt, pMap, pHero, pMaxEnemiesNb)
  
  -- if the enemies number decrease, spawn a new one with a type in relation to the kill
  if #Enemy.listEnemies < pMaxEnemiesNb then
    local spawnType = 1
    if Enemy.countDeadTypes[1] > Enemy.countDeadTypes[2] then spawnType = 2 end
    Enemy.Load("update", spawnType, windowWidth, windowHeight, TILE_SIZE, mapSizePixW, pHero.level)
  end
  
  Enemy.goomCount.inf = 0
  Enemy.goomCount.same = 0
  Enemy.goomCount.sup = 0
  Enemy.tankCount.inf = 0
  Enemy.tankCount.same = 0
  Enemy.tankCount.sup = 0
  
  if #Enemy.listEnemies > 0 then
    for item = #Enemy.listEnemies, 1, -1 do
      local e = Enemy.listEnemies[item]
    
      if e.type == 1 then -- goom mob
        if e.level < pHero.level then Enemy.goomCount.inf = Enemy.goomCount.inf + 1 end
        if e.level == pHero.level then Enemy.goomCount.same = Enemy.goomCount.same + 1 end
        if e.level > pHero.level then Enemy.goomCount.sup = Enemy.goomCount.sup + 1 end
      end
      
      if e.type == 2 then -- tank mob
        if e.level < pHero.level then Enemy.tankCount.inf = Enemy.tankCount.inf + 1 end
        if e.level == pHero.level then Enemy.tankCount.same = Enemy.tankCount.same + 1 end
        if e.level > pHero.level then Enemy.tankCount.sup = Enemy.tankCount.sup + 1 end
      end
    
      if e.isDead == false then
        
        e.healthBar = e.health/e.maxHealth
        e.difA = pHero.ptsAttack - e.ptsDefense -- difference if Hero attack
        e.difD = e.ptsAttack - pHero.ptsDefense -- difference if Hero defend
        
        if e.difA < countDifA.min then countDifA.min = e.difA end
        if e.difA > countDifA.max then countDifA.max = e.difA end
        if e.difD < countDifD.min then countDifD.min = e.difD end
        if e.difD > countDifD.max then countDifD.max = e.difD end
        
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
          
          if pMap.mov == true then e.x = e.x - pHero.speed.walk * pHero.sign end
          
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
          if pMap.mov == true then
            e.x = e.x - pHero.speed.walk * pHero.sign
          end
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
    
      -- death animation
      if e.isDead == true then
        e.Dead.y = e.Dead.y - e.speed.alongY
        if pMap.mov == true then
          e.Dead.x = e.Dead.x - pHero.speed.walk * pHero.sign
        end
        e.speed.alongY = e.speed.alongY - dt*9.81
        if e.Dead.y > windowHeight then
          pHero.xp = pHero.xp + ((2^(e.level - pHero.level) * 1.5) + 1 ) * pHero.level
          if e.level < pHero.level then Enemy.countDeadBodies[1] = Enemy.countDeadBodies[1] + 1 end
          if e.level == pHero.level then Enemy.countDeadBodies[2] = Enemy.countDeadBodies[2] + 1 end
          if e.level > pHero.level then Enemy.countDeadBodies[3] = Enemy.countDeadBodies[3] + 1 end
          Enemy.countDeadTypes[e.type] = Enemy.countDeadTypes[e.type] + 1
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
          if e.healthBar >= 0.6 then love.graphics.setColor(0, 128, 0)
          elseif e.healthBar < 0.6 and e.healthBar >= 0.3 then love.graphics.setColor(255, 192, 0)
          elseif e.healthBar < 0.3 then love.graphics.setColor(255, 0, 0) end
          
          love.graphics.rectangle("fill", e.x - (e.w * e.scale)/2, e.y - 8, (e.healthBar)*(e.w * e.scale), 5)
          love.graphics.setColor(0, 0, 0)
          love.graphics.printf("LV "..e.level, e.x - (e.w * e.scale)/2, e.yHead - 24, e.w * e.scale, "center")
          love.graphics.rectangle("line", e.x - (e.w * e.scale)/2 - 1, e.y - 8 - 1, e.w * e.scale, 7)
          love.graphics.printf(e.difA, e.x - (e.w * e.scale), e.yHead - 24, e.w * e.scale * 2, "left")
          love.graphics.printf(e.difD, e.x - (e.w * e.scale), e.yHead - 24, e.w * e.scale * 2, "right")
          love.graphics.setColor(255, 255, 255)
          
          love.graphics.draw(e.anim, e.animWalk[math.floor(e.picCurrent)],
                             e.x, e.y, 0,
                             e.sign * e.scale, 1 * e.scale,
                             e.w/2, 1)
        end
      end
      
      
    end
    
    if e.isDead == true then
      love.graphics.draw(e.anim, e.animWalk[math.floor(e.picCurrent)],
                         e.Dead.x, e.Dead.y, e.Dead.rot,
                         e.Dead.sign * e.Dead.scale, 1 * e.Dead.scale,
                         e.Dead.w/2, 1)
    end
  end
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("difA : "..countDifA.min.." / "..countDifA.max, 100, 20, windowWidth/2, "center")
  love.graphics.printf("difD : "..countDifD.min.." / "..countDifD.max, 100, 50, windowWidth/2, "center")
  love.graphics.setColor(255, 255, 255)
  
end

return Enemy