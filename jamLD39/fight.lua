local Fight = {}

local myMap = require("map")
local myMachina = require("machina")
local myEnemy = require("enemy")
local soundEffects = {}
soundEffects.crash = love.audio.newSource("sounds/SNES_HyperZone_EnemyHit2.wav", "static")

function Fight.Update(dt, pLevel)
  local i
  for i = 1, #myEnemy.listEnemies do
    local e = myEnemy.listEnemies[i]
    
    local tempDist = (e.col - myMachina.body.col)^2 + (e.lin - myMachina.body.lin)^2
    if tempDist < 17 then
      e.attack = true
    else e.attack = false end
    
    if myMap.listGrids[pLevel][e.lin][e.col] == myMap.listGrids[pLevel][myMachina.body.lin][myMachina.body.col]
       and e.isEnabled == true then
          soundEffects.crash:setPitch(0.5)
          soundEffects.crash:play()
          e.isEnabled = false
          myMachina.power = myMachina.power - 50
    end
  end
end

return Fight