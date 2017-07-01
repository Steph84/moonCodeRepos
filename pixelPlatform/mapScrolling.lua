local MapScrolling = {}

local speedAdjust = 35

function MapScrolling.Update(dt, pHero, pMapBuilding, pMapMov)

  -- manage the map movement
  if pMapMov == true then
    local lin, col
    for lin = 1, pMapBuilding.size.h do
      for col = 1, pMapBuilding.size.w do
        local g = pMapBuilding.grid[lin][col]
        g.x = g.x - pHero.sign * pHero.speed.walk * dt * speedAdjust
      end
    end
  end
  
end

function MapScrolling.Draw()
  
end

return MapScrolling