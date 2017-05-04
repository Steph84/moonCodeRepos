local DropList = {}

local cursorPic = nil

function DropList.Load()
  cursorPic = love.graphics.newImage("pictures/cursor.png")
end

function DropList.Update(pDt)
  
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