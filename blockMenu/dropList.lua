local DropList = {}

local cursorPic = nil
local mouseClicked = {}
DropList.item = {}

function DropList.Load(pAnchorX, pAnchorY, pDropDownWidth, pFontSize)
  cursorPic = love.graphics.newImage("pictures/cursor.png")
  DropList.item = { x = pAnchorX, y = pAnchorY, w = pDropDownWidth, h = pFontSize }
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

function DropList.Update(pDt)
  --
  
  if mouseClicked.on == true then
        if mouseClicked.x > DropList.item.x and
           mouseClicked.x < DropList.item.x + DropList.item.w then
             if mouseClicked.y > DropList.item.y and
                mouseClicked.y < DropList.item.y + DropList.item.h then
                  print("fuck it")
                  
                end
              end
            end
            
      
end

function DropList.Draw(pAnchorX, pAnchorY, pDropDownWidth, pFontSize)
  love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", pFontSize))
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", pAnchorX, pAnchorY, pDropDownWidth, pFontSize)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", pAnchorX, pAnchorY, pDropDownWidth, pFontSize)
  love.graphics.draw(cursorPic, pAnchorX + pDropDownWidth + 2, pAnchorY, 0, 0.5, 0.5)
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf("800 x 600", pAnchorX, pAnchorY, pDropDownWidth, "center")
end

return DropList