local Combat = {}

local windowWidth, windowHeight, TILE_SIZE

local tempEnemy = {}
local tempSign = 0
local counter = 0

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
        
        local dxLeft = math.abs(myHero.xLeft - e.xLeft)
        local dxRight = math.abs(myHero.xRight - e.xRight)
        local dWidthFighters = (myHero.xRight - myHero.xLeft) + (e.xRight - e.xLeft)
        
        local dyHead = math.abs(myHero.yHead - e.yHead)
        local dyFeet = math.abs(myHero.yFeet - e.yFeet)
        local dHeightFighters = (myHero.yFeet - myHero.yHead) + (e.yFeet - e.yHead)
        
        if dxLeft < dWidthFighters or dxRight < dWidthFighters then
          --print(dxLeft, dxRight, dWidthFighters)
          if dyHead < dHeightFighters or dyFeet < dHeightFighters then
            print(e.yFeet - e.yHead, myHero.yFeet - myHero.yHead, dHeightFighters)
            --print(e.yFeet, e.yHead)
          end
        end
        
        --[[
        local dx = myHero.xHead - e.x
        local dy = myHero.yHead - e.y
        if (math.abs(dx) < (e.w / e.scale)) then
          if (math.abs(dy) < ((myHero.yFeet - myHero.yHead))) then
            myHero.hitted = true
            table.insert(tempEnemy, e)
            counter = 0
          end
        end
        --]]
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
    myHero.animHit = true
    -- reinitialize and calculate the new health
    if counter < 1 then
      myHero.health = myHero.health - (tempEnemy[1].ptsAttack - myHero.ptsDefense)
      table.remove(tempEnemy, 1)
      counter = counter + 1
    end
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
        
        if te.animHitSpeedX > 0
          -- avoid crash from left or right boundary
          and te.x < (windowWidth - te.w * te.scale)
          and te.x > (te.w * te.scale) then
            te.animHitSpeedX = te.animHitSpeedX - dt*6
        else
          -- reinitialize and calculate the new health
          te.animHit = false
          te.animHitSpeedX = 5
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