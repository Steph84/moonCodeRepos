local Options = {}

local windowWidth, windowHeight, fontSize
local resolutionProp = {}

Options.myResolution = require("menuOptionsResolution")

function Options.Load(pWindowWidth, pWindowHeight, pFontSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  fontSize = pFontSize
  
  resolutionProp.anchorX = 100
  resolutionProp.anchorY = 100
  resolutionProp.dropDownWidth = 200
  Options.myResolution.Load(windowWidth, windowHeight, fontSize, resolutionProp)
  
end

function Options.Update(dt, pGameState)
  if love.keyboard.isDown("escape") then pGameState = "title" end
  
  Options.myResolution.Update(dt)
  return pGameState
end


function Options.Draw()
  Options.myResolution.Draw()
end

return Options