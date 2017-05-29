local Options = {}

local windowWidth, windowHeight, fontSize
local resolutionProp = {}

local myResolution = require("menuOptionsResolution")
local myValidate = require("menuOptionsValidate")

-- TODO make a validate button with a lua file dedicated

function Options.Load(pWindowWidth, pWindowHeight, pFontSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  fontSize = pFontSize
  
  resolutionProp.anchorX = 100
  resolutionProp.anchorY = 100
  resolutionProp.dropDownWidth = 200
  myResolution.Load(windowWidth, windowHeight, fontSize, resolutionProp)
  
  myValidate.Load(windowWidth, windowHeight, fontSize)
  
end

function Options.Update(dt, pGameState)
  if love.keyboard.isDown("escape") then pGameState = "title" end
  
  myResolution.Update(dt)
  pGameState = myValidate.Update(dt, pGameState)
  
  return pGameState
end


function Options.Draw()
  myResolution.Draw()
  myValidate.Draw()
  
  love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", fontSize))
  -- TODO add arrow icon
  love.graphics.printf("To get back, press escape ", 0, windowHeight - fontSize * 1.5, windowWidth - fontSize * 0.5, "right")
end

return Options