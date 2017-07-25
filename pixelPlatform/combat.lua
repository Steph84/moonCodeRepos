local Combat = {}

local myHero = require("hero")
local myEnemy = require("enemy")

function Combat.Load()
  
end

  local yoshi = 0
function Combat.Update(dt)
  
  if myHero.attack == false and myHero.hitted == false then
    if ( (myHero.xLeft >= myEnemy.x and myHero.xLeft <= (myEnemy.x + myEnemy.w * myEnemy.scale))
        or (myHero.xRight >= myEnemy.x and myHero.xRight <= (myEnemy.x + myEnemy.w * myEnemy.scale)) )
      and ( (myHero.yHead >= myEnemy.y and myHero.yHead <= (myEnemy.y + myEnemy.h * myEnemy.scale))
        or (myHero.yFeet >= myEnemy.y and myHero.yFeet <= (myEnemy.y + myEnemy.h * myEnemy.scale)) ) then
          myHero.hitted = true
    end
  end
  
  if myHero.attack == true and myEnemy.hitted == false then
    if ( (myHero.x >= myEnemy.x and myHero.x <= (myEnemy.x + myEnemy.w * myEnemy.scale))
        or ((myHero.x + myHero.w * myHero.scale) >= myEnemy.x and (myHero.x + myHero.w * myHero.scale) <= (myEnemy.x + myEnemy.w * myEnemy.scale)) )
      and ( (myHero.yHead >= myEnemy.y and myHero.yHead <= (myEnemy.y + myEnemy.h * myEnemy.scale))
        or (myHero.yFeet >= myEnemy.y and myHero.yFeet <= (myEnemy.y + myEnemy.h * myEnemy.scale)) ) then
          myEnemy.hitted = true
    end
  end
  if myHero.hitted == true then
    myHero.animHit = true
    myHero.x = myHero.x - myHero.animHitSpeedX * myHero.sign
      myHero.y = myHero.y - myHero.animHitSpeedY
      if myHero.animHitSpeedX > 0 then
        myHero.animHitSpeedX = myHero.animHitSpeedX - dt*6
      else
        myHero.animHit = false
        myHero.animHitSpeedX = 5
        myHero.animHitSpeedY = 5
        myHero.hitted = false
        myHero.health = myHero.health - (myEnemy.ptsAttack - myHero.ptsDefense)
        yoshi = yoshi + 1
      end
      myHero.animHitSpeedY = myHero.animHitSpeedY - dt*9.81
  end
  
end

function Combat.Draw()
  
end

return Combat