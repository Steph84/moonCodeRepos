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
  myValidate.Update(dt)
  
  return pGameState
end


function Options.Draw()
  myResolution.Draw()
  myValidate.Draw()
end

return Options