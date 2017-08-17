local Combat = {}

local windowWidth, windowHeight, TILE_SIZE

local tempEnemy = {}
local counterHero = 0

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
        local dWidthFighters = math.min(myHero.xRight - myHero.xLeft, e.xRight - e.xLeft)
        
        local dyHead = math.abs(myHero.yHead - e.yHead)
        local dyFeet = math.abs(myHero.yFeet - e.yFeet)
        local dHeightFighters = math.min(myHero.yFeet - myHero.yHead, e.yFeet - e.yHead)
        
        if dxLeft < dWidthFighters or dxRight < dWidthFighters then
          if dyHead < dHeightFighters or dyFeet < dHeightFighters then
            myHero.hitted = true
            table.insert(tempEnemy, e)
            counterHero = 0
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
        local dxLeft = math.abs(myHero.xLeft - e.xLeft)
        local dxRight = math.abs(myHero.xRight - e.xRight)
        local dWidthFighters = math.min(myHero.xRight - myHero.xLeft, e.xRight - e.xLeft)
        
        local dyHead = math.abs(myHero.yHead - e.yHead)
        local dyFeet = math.abs(myHero.yFeet - e.yFeet)
        local dHeightFighters = math.min(myHero.yFeet - myHero.yHead, e.yFeet - e.yHead)
        
        if dxLeft < dWidthFighters or dxRight < dWidthFighters then
          if dyHead < dHeightFighters or dyFeet < dHeightFighters then
            e.hitted = true
            tempEnemy[#tempEnemy + 1] = e
            e.counter = 0
          end
        end
      end
    end
  end
  
  -- animation and calculus if the hero is hitted
  if myHero.hitted == true then
    myHero.animHit = true
    -- reinitialize and calculate the new health
    if counterHero < 1 then
      myHero.health = myHero.health - (tempEnemy[1].ptsAttack - myHero.ptsDefense)
      table.remove(tempEnemy, 1)
      counterHero = counterHero + 1
    end
  end
  
  -- animation and calculus if the hero is hitted
  if #tempEnemy > 0 then
    local i
    for i = #tempEnemy, 1, -1 do
      local te = tempEnemy[i]
      if te.hitted == true then
        te.animHit = true
        if te.counter < 1 then
          te.health = te.health - (myHero.ptsAttack - te.ptsDefense)
          te.counter = te.counter + 1
        end
      else
        table.remove(tempEnemy, #tempEnemy)
      end
    end
  end
end

function Combat.Draw()
  
end

return Combat