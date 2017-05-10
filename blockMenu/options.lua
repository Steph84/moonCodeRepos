local Options = {}

local Resolution = {}
Resolution.displayScreen = { 0, 0 }
Resolution.window = { 0, 0 }

local bgOptions = nil
local ratioW = 0
local ratioH = 0

local anchorX = 100
local anchorY = 100
local dropDownWidth = 200

local myDropList = require("dropList")


function Options.Load(pWindowWidth, pWindowHeight, pFontSize)
  
  -- manage the scale of the background picture
  bgOptions = love.graphics.newImage("pictures/back.png")
  local bgWidth = bgOptions:getWidth()
  local bgHeight = bgOptions:getHeight()
  ratioW = bgWidth/pWindowWidth
  ratioH = bgHeight/pWindowHeight
  if ratioW > ratioH and ratioW > 1 and ratioH > 1 then
    ratioW = ratioH
  elseif ratioW < ratioH and ratioW > 1 and ratioH > 1 then
    ratioH = ratioW
  end
  local content = 1
  myDropList.Load(anchorX, anchorY, dropDownWidth, pFontSize, content, "Resolution")
  
  
  Resolution.displayScreen[1], Resolution.displayScreen[2] = love.window.getDesktopDimensions(1)
  --print(Resolution.displayScreen[1], Resolution.displayScreen[2])
  
  modes = love.window.getFullscreenModes(1)
  local i
  for i = 1, #modes do
    --print(modes[i].width, modes[i].height)
  end
  
  width, height, flags = love.window.getMode()
  local j
  for j = 1, #flags do
    print(flags[i])
  end
end

function Options.Update(pDt, pGameState)
  if love.keyboard.isDown("escape") then pGameState = "title" end
  
  myDropList.Update(pDt)
  
  return pGameState
end


function Options.Draw(pWindowWidth, pWindowHeight, pFontSize)
  
  love.graphics.draw(bgOptions, 0, 0, 0, 1/ratioW, 1/ratioH)
  
  myDropList.Draw(pWindowWidth)
  
end

return Options