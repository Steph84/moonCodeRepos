local MapScrolling = {}

local speedAdjust = 45

function MapScrolling.Update(dt, pHero, pMap)

  -- manage the map movement
  if pMap.mov == true then
    local lin, col
    for lin = 1, pMap.myBuilding.size.h do
      for col = 1, pMap.myBuilding.size.w do
        local g = pMap.myBuilding.grid[lin][col]
        g.x = g.x - pHero.sign * pHero.speed.walk * dt * speedAdjust
      end
    end
  end
  
end

function MapScrolling.Draw()
  
end

return MapScrolling