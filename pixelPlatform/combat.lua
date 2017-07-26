local Combat = {}

local myHero = require("hero")
local myEnemy = require("enemy")

function Combat.Load()
  
end

function Combat.Update(dt)
  
  -- detection hero is hitted
  if myHero.attack == false and myHero.hitted == false then
    
    local dx = myHero.xHead - myEnemy.x
    local dy = myHero.yHead - myEnemy.y
    if (math.abs(dx) < (myEnemy.w / myEnemy.scale)) then
      if (math.abs(dy) < ((myHero.yFeet - myHero.yHead) + (myEnemy.h / myEnemy.scale))) then
        myHero.hitted = true
      end
    end
  end
  
  -- detection enemy is hitted
  if myHero.attack == true and myEnemy.hitted == false then
    local dx
    if myHero.sign == 1 then
      dx = myHero.x - myEnemy.x
    else dx = myHero.x - myEnemy.x end
    local dy = myHero.y - myEnemy.y
    if (math.abs(dx) < (myHero.w + (myEnemy.w / myEnemy.scale))) then
      if (math.abs(dy) < ((myHero.yFeet - myHero.yHead) + (myEnemy.h / myEnemy.scale))) then
        myEnemy.hitted = true
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
      myHero.health = myHero.health - (myEnemy.ptsAttack - myHero.ptsDefense)
    end
    myHero.animHitSpeedY = myHero.animHitSpeedY - dt*9.81
  end
  
end

function Combat.Draw()
  
end

return Combat