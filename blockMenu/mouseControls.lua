local MouseControls = {}

-- manage the mouse control
function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    MouseControls.clicked = true
    MouseControls.x = x
    MouseControls.y = y
  end
end
function love.mousereleased(x, y, button, istouch)
  if button == 1 then
    MouseControls.clicked = false
    MouseControls.x = 0
    MouseControls.y = 0
  end
end

-- the parameter object must be
-- x, y, w and h
function MouseControls.ClickOnObject(pObject)
  if MouseControls.clicked == true then
    if MouseControls.x > pObject.x and
       MouseControls.x < pObject.x + pObject.w and
       MouseControls.y > pObject.y and
       MouseControls.y < pObject.y + pObject.h then
      MouseControls.clicked = false
      return true
    end
    return false
  end
end

function MouseControls.HoverOnObject(pObject)
  MouseControls.currentX, MouseControls.currentY = love.mouse.getPosition()
  
  if MouseControls.currentX > pObject.x and
     MouseControls.currentX < pObject.x + pObject.w and
     MouseControls.currentY > pObject.y and
     MouseControls.currentY < pObject.y + pObject.h then
    return true, MouseControls.currentX, MouseControls.currentY
  end
  return false, MouseControls.currentX, MouseControls.currentY
end

return MouseControls