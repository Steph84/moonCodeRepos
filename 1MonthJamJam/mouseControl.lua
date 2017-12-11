local MouseControl = {}

MouseControl.clicked = false

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    MouseControl.clicked = true
  end
end

--[[
function love.mousereleased(x, y, button, istouch)
  if button == 1 and MouseControl.clicked == true then
    MouseControl.clicked = false
  end
end
]]--

return MouseControl