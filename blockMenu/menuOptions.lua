local Options = {}

local windowWidth, windowHeight, fontSize
local resolutionProp = {}
local wScale, hScale

local myResolution = require("menuOptionsResolution")
local myValidate = require("menuOptionsValidate")
local myPicture = require("loadPictures")

-- TODO make a validate button with a lua file dedicated

function Options.Load(pWindowWidth, pWindowHeight, pFontSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  fontSize = pFontSize
  
  resolutionProp.anchorX = 100
  resolutionProp.anchorY = 100
  resolutionProp.dropDownWidth = 150
  myResolution.Load(windowWidth, windowHeight, fontSize, resolutionProp)
  myValidate.Load(windowWidth, windowHeight, fontSize)
  
  -- manage the scale of the background picture
  wScale = windowWidth/myPicture.backGround.w
  hScale = windowHeight/myPicture.backGround.h
  
end

function Options.Update(dt, pGameState)
  if love.keyboard.isDown("escape") then pGameState = "title" end
  
  myResolution.Update(dt)
  myValidate.Update(dt)
  
  return pGameState
end


function Options.Draw()
  -- draw the background picture
  love.graphics.setColor(255, 255, 255)
  myPicture.Draw(myPicture.backGround.src, 0, 0, wScale, hScale)
  
  myResolution.Draw()
  myValidate.Draw()
  
  -- draw the back instructions
  love.graphics.setColor(255, 255, 255)
  myPicture.Draw(myPicture.backArrow.src, windowWidth*0.01, windowHeight*0.01, 32/myPicture.backArrow.w, 32/myPicture.backArrow.h)
  love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", fontSize))
  love.graphics.print("Esc ", windowWidth*0.06, windowHeight*0.01)
end

return Options