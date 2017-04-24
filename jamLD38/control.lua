local Control = {}

local mouseClicked = {}

function Control.UpdateMap(pDt, pScreen, pListCities)
  if love.mouse.isDown(1) then
    if love.mouse.getX() > pListCities[1].X and
       love.mouse.getX() < pListCities[1].X + 32 then
         if love.mouse.getY() > pListCities[1].Y and
            love.mouse.getY() < pListCities[1].Y + 32 then
              pScreen = "city"
         end
    end
  end
  return pScreen
end


function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    mouseClicked.on = true
    mouseClicked.x = x
    mouseClicked.y = y
  end
end
function love.mousereleased(x, y, button, istouch)
  if button == 1 then
    mouseClicked.on = false
    mouseClicked.x = nil
    mouseClicked.y = nil
  end
end

function Control.UpdateButt(pDt, pListButtons, pCityWindow, pListCities, pScreen)
  
  if mouseClicked.on then
    local i
    for i = 1, #pListButtons do
      local butt = pListButtons[i]
      local coorX = pCityWindow.cityWindowX + butt.X
      local coorY = pCityWindow.cityWindowY + i*butt.Y
      if pListCities[1].Treasury > 0 then
        if mouseClicked.x > coorX and
           mouseClicked.x < coorX + 32*butt.Scale then
             if mouseClicked.y > coorY and
                mouseClicked.y < coorY + 32*butt.Scale then
                  
                  pListCities[1].BuildingNumber[i] = pListCities[1].BuildingNumber[i] + 1
                  pListCities[1].Treasury = pListCities[1].Treasury - i*i*100
                  mouseClicked.x = 0
                  mouseClicked.y = 0
                  
             end
        end
      end
    end
  end
  
  if love.keyboard.isDown("escape") then
    pScreen = "map"
  end
  return pScreen
end



return Control