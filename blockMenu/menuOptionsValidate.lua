local Validate = {}

local windoww, windowh, fontSize, x, y, buttonw
local valButton = {}
local isValidate = false
local timeElapsed = 0

local myMouse = require("mouseControls")
local mySetSettings = require("menuOptionsSetSettings")

function Validate.Load(pWindoww, pWindowh, pFontSize)
  windoww = pWindoww
  windowh = pWindowh
  fontSize = pFontSize
  
  valButton.w = fontSize * 8 * 0.6 -- 8 is for number of letters
  valButton.x = pWindoww - valButton.w - 50
  valButton.y = pWindowh - 50 - fontSize
  valButton.h = fontSize * 1.5
  
end

function Validate.Update(dt, pGameState)
  
  if love.mouse.isDown(1) then
    isValidate = myMouse.HoverOnObject(valButton)
  end
  
  if isValidate == true then
    timeElapsed = timeElapsed + dt
    if timeElapsed > 0.7 then
      pGameState = "title"
      isValidate = false
      timeElapsed = 0
      mySetSettings.Load()
    end
    -- TODO write into text then reload
  end
  
  return pGameState
end

function Validate.Draw()
  -- draw the black background
  if isValidate == false then love.graphics.setColor(0, 0, 0)
  elseif isValidate == true then love.graphics.setColor(255, 255, 255) end
  love.graphics.rectangle("fill", valButton.x, valButton.y, valButton.w, valButton.h)
  
  -- draw the white outline
  if isValidate == false then love.graphics.setColor(255, 255, 255)
  elseif isValidate == true then love.graphics.setColor(0, 0, 0) end
  love.graphics.rectangle("line", valButton.x, valButton.y, valButton.w, valButton.h)
  
  -- draw the text in the button
  love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", fontSize))
  love.graphics.printf("Validate", valButton.x, valButton.y - 2 + valButton.h/6, valButton.w, "center")
  
  love.graphics.setColor(255, 255, 255)
  
end

return Validate