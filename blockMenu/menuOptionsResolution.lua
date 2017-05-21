local Resolution = {}

local windowWidth, windowHeight, fontSize, resolutionProp

Resolution.displayScreen = { 0, 0 }
Resolution.window = { 0, 0, 0 } -- width, height, selection

local bgPic = {}
local dropListProp = {}

local myDropList = require("dropList")

-- load the data for the dropLists
local myListItems = require("dropListItems")

function Resolution.Load(pWindowWidth, pWindowHeight, pFontSize, pResolutionProp)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  fontSize = pFontSize
  resolutionProp = pResolutionProp
  
  -- manage the scale of the background picture
  bgPic.src = love.graphics.newImage("pictures/back.png")
  bgPic.width = bgPic.src:getWidth()
  bgPic.height = bgPic.src:getHeight()
  bgPic.ratioW = bgPic.width/windowWidth
  bgPic.ratioH = bgPic.height/windowHeight
  local w = bgPic.ratioW
  local h = bgPic.ratioH
  if w > h and w > 1 and h > 1 then
    w = h
  elseif w < h and w > 1 and h > 1 then
    h = w
  end
  
  -- get the screen resolution of the display #1
  Resolution.displayScreen[1], Resolution.displayScreen[2] = love.window.getDesktopDimensions(1)
  
  -- get the window resolution of the game
  Resolution.window[1], Resolution.window[2], flags = love.window.getMode()
  Resolution.window[3] = 1 -- TODO temp
  
  local dataList = 3 -- TODO temp
  myDropList.Load("Resolution", dataList, Resolution.window[3],
                  resolutionProp.anchorX, resolutionProp.anchorY, resolutionProp.dropDownWidth, fontSize)
  
end

function Resolution.Update(dt, pGameState)
  
  local tempReso = Resolution.window[3]
  
  if love.keyboard.isDown("escape") then pGameState = "title" end
  
  tempReso = myDropList.Update(dt, Resolution.window[3])
  if tempReso ~= Resolution.window[3] then
    Resolution.window[3] = tempReso
    Resolution.window[1] = myListItems[3][Resolution.window[3]][1]
    Resolution.window[2] = myListItems[3][Resolution.window[3]][2]
    love.window.setMode( Resolution.window[1], Resolution.window[2] )
  end
  
  return pGameState
end

function Resolution.Draw()
  love.graphics.draw(bgPic.src, 0, 0, 0, 1/bgPic.ratioW, 1/bgPic.ratioH)
  myDropList.Draw()
end

return Resolution