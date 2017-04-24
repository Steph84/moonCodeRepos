local Control = {}

local Screen = "map"

function Control.UpdateMap(pDt, pListCities)
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

function Control.UpdateButt(pDt, pListButtons, pCityWindow)
  if love.mouse.isDown(1) then
    
    local i
    for i = 1, #pListButtons do
      local butt = pListButtons[i]
      local coorX = pCityWindow.cityWindowX + butt.X
      local coorY = pCityWindow.cityWindowY + i*butt.Y
      if love.mouse.getX() > coorX and
         love.mouse.getX() < coorX + 32*butt.Scale then
           if love.mouse.getY() > coorY and
              love.mouse.getY() < coorY + 32*butt.Scale then
           end
      end
    end
  end
end



return Control