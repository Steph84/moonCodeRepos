local Validate = {}

local windowWidth, windowHeight, fontSize, anchorX, anchorY, buttonWidth

function Validate.Load(pWindowWidth, pWindowHeight, pFontSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  fontSize = pFontSize
  
  buttonWidth = fontSize * 8 * 0.6
  anchorX = pWindowWidth - buttonWidth - 50
  anchorY = pWindowHeight - 50 - fontSize
  
  
end

function Validate.Update(dt)
  
end

function Validate.Draw()
  -- draw the black background
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", anchorX, anchorY, buttonWidth, fontSize * 1.5)
  
  -- draw the white outline
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", anchorX, anchorY, buttonWidth, fontSize * 1.5)
  
  love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", fontSize))
  
  love.graphics.printf("Validate", anchorX, anchorY - 2 + fontSize*0.25, buttonWidth, "center")
  
end

return Validate