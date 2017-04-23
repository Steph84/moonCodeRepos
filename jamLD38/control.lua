local Control = {}

local Screen = "map"

function Control.Update(pDt, pListCities)
  if love.mouse.isDown(1) then
    if love.mouse.getX() > pListCities[1].X and
       love.mouse.getX() < pListCities[1].X + 32 then
         if love.mouse.getY() > pListCities[1].Y and
            love.mouse.getY() < pListCities[1].Y + 32 then
              Screen = "city"
         end
    end
  end
  return Screen
end


return Control