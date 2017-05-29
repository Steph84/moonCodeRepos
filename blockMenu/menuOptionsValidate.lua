local Validate = {}

local windoww, windowh, fontSize, x, y, buttonw
local valButton = {}

local myMouse = require("mouseControls")
local bioshock = false

function Validate.Load(pWindoww, pWindowh, pFontSize)
  windoww = pWindoww
  windowh = pWindowh
  fontSize = pFontSize
  
  valButton.w = fontSize * 8 * 0.6
  valButton.x = pWindoww - valButton.w - 50
  valButton.y = pWindowh - 50 - fontSize
  valButton.h = fontSize * 1.5
  
end


function Validate.Update(dt)
  if myMouse.clicked == true then
    bioshock = myMouse.ClickOnObject(valButton)
  end
end

function Validate.Draw()
  -- draw the black background
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", valButton.x, valButton.y, valButton.w, valButton.h)
  
  -- draw the white outline
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", valButton.x, valButton.y, valButton.w, valButton.h)
  
  love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", fontSize))
  
  love.graphics.printf("Validate", valButton.x, valButton.y - 2 + valButton.h/6, valButton.w, "center")
  
  love.graphics.print(tostring(bioshock), love.mouse.getX(), love.mouse.getY())
  love.graphics.circle("fill", valButton.x, valButton.y, 10)
  
end

return Validate