local Combat = {}

local windowWidth, windowHeight, TILE_SIZE

local tempEnemy = {}
local tempSign = 0

local myHero = require("hero")
local myEnemy = require("enemy")

function Combat.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
end

function Combat.Update(dt)
  
  -- detection hero is hitted
  if myHero.attack == false and myHero.hitted == false then
    local item
    for item = #myEnemy.listEnemies, 1, -1 do
      local e = myEnemy.listEnemies[item]
      if e.hitted == false and e.isDead == false then
        local dx = myHero.xHead - e.x
        local dy = myHero.yHead - e.y
        if (math.abs(dx) < (e.w / e.scale)) then
          if (math.abs(dy) < ((myHero.yFeet - myHero.yHead) + (e.h / e.scale))) then
            myHero.hitted = true
            table.insert(tempEnemy, e)
          end
        end
      end
    end
  end
  
  -- detection enemy is hitted
  if myHero.attack == true then
    local item
    for item = #myEnemy.listEnemies, 1, -1 do
      local e = myEnemy.listEnemies[item]
      if e.hitted == false then
        local dx = myHero.x - e.x
        local dy = myHero.y - e.y
        
        if (math.abs(dx) < (myHero.w + (e.w / e.scale))) then
          if (math.abs(dy) < ((myHero.yFeet - myHero.yHead) + (e.h / e.scale))) then
            e.hitted = true
            tempEnemy[#tempEnemy + 1] = e
          end
        end
      end
    end
  end
  
  -- animation and calculus if the hero is hitted
  if myHero.hitted == true then
    -- to bypass the standard hero animation
    myHero.animHit = true
    -- bound animation
    myHero.x = myHero.x - myHero.animHitSpeedX * myHero.sign
    myHero.y = myHero.y - myHero.animHitSpeedY
    
    if myHero.animHitSpeedX > 0 then
      myHero.animHitSpeedX = myHero.animHitSpeedX - dt*6
    else
      -- reinitialize and calculate the new health
      myHero.animHit = false
      myHero.animHitSpeedX = 5
      myHero.animHitSpeedY = 5
      myHero.hitted = false
      myHero.health = myHero.health - (tempEnemy[1].ptsAttack - myHero.ptsDefense)
      table.remove(tempEnemy, 1)
    end
    myHero.animHitSpeedY = myHero.animHitSpeedY - dt*9.81
  end
  
  -- animation and calculus if the hero is hitted
  if #tempEnemy > 0 then
    local i
    for i = #tempEnemy, 1, -1 do
      local te = tempEnemy[i]
      if te.hitted == true then
        if tempSign == 0 then
          tempSign = myHero.sign
        end
        -- to bypass the standard hero animation
        te.animHit = true
        -- bound animation
        te.x = te.x + te.animHitSpeedX * tempSign
        
        te.animHitSpeedY = te.animHitSpeedY - dt*9.81
        
        if te.animHitSpeedX > 0 then
          te.animHitSpeedX = te.animHitSpeedX - dt*6
        else
          -- reinitialize and calculate the new health
          te.animHit = false
          te.animHitSpeedX = 5
          te.animHitSpeedY = 5
          te.hitted = false
          tempSign = 0
          te.health = te.health - (myHero.ptsAttack - te.ptsDefense)
          table.remove(tempEnemy, i)
        end
      end
    end
  end
end

function Combat.Draw()
  
end

return Combat