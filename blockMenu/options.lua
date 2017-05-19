local Options = {}

local Resolution = {}
Resolution.displayScreen = { 0, 0 }
Resolution.window = { 0, 0, 0 } -- width, height, selection

local bgOptions = nil
local ratioW = 0
local ratioH = 0

local anchorX = 100
local anchorY = 100
local dropDownWidth = 200

local myDropList = require("dropList")

-- to load the data for the dropLists
local myListItems = require("listitems")


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
  
  Resolution.displayScreen[1], Resolution.displayScreen[2] = love.window.getDesktopDimensions(1)
  
  Resolution.window[1], Resolution.window[2], flags = love.window.getMode()
  Resolution.window[3] = 1
  
  local content = 3
  myDropList.Load(anchorX, anchorY, dropDownWidth, pFontSize, content, "Resolution", Resolution.window[3])
  
end

function Options.Update(pDt, pGameState)
  local tempReso = Resolution.window[3]
  
  if love.keyboard.isDown("escape") then pGameState = "title" end
  
  tempReso = myDropList.Update(pDt, Resolution.window[3])
  if tempReso ~= Resolution.window[3] then
    Resolution.window[3] = tempReso
    Resolution.window[1] = myListItems[3][Resolution.window[3]][1]
    Resolution.window[2] = myListItems[3][Resolution.window[3]][2]
    love.window.setMode( Resolution.window[1], Resolution.window[2] )
  end
  
  return pGameState
end


function Options.Draw(pWindowWidth, pWindowHeight, pFontSize)
  
  love.graphics.draw(bgOptions, 0, 0, 0, 1/ratioW, 1/ratioH)
  
  myDropList.Draw(pWindowWidth)
  
end

return Options