local Resolution = {}

-- TODO manage the full screen mode

local windowWidth, windowHeight, fontSize, resolutionProp

Resolution.displayScreen = { 0, 0 }
Resolution.window = { 0, 0, 0 } -- width, height, selection

local bgPic = {}
local dropListProp = {}

local myDropList = require("dropList")

-- load the data for the dropLists
local myListItems = require("dropListItems")


  local data = {}

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
  
  dropListProp.data = {}
  local modes = love.window.getFullscreenModes() -- get the resolution possible
  -- sort the resolution by ascendant size
  table.sort(modes, function(a, b) return a.width*a.height < b.width*b.height end)
  -- refacto the data to fit the dropList schema
  local i
  for i = 1, #modes do
    local thisRes = {}
    table.insert(thisRes, modes[i].width)
    table.insert(thisRes, modes[i].height)
    table.insert(dropListProp.data, thisRes)
  end
  
  -- get the window resolution of the game
  Resolution.window[1], Resolution.window[2], flags = love.window.getMode()
  local j
  for j = 1, #dropListProp.data do
    local item = dropListProp.data[j]
    if item[1] == Resolution.window[1] and item[2] == Resolution.window[2] then
      Resolution.window[3] = j
    end
  end
  
  -- create the resolution dropList object
  myDropList.Load("Resolution", dropListProp.data, Resolution.window[3],
                  resolutionProp.anchorX, resolutionProp.anchorY, resolutionProp.dropDownWidth, fontSize)
  
end

function Resolution.Update(dt)
  
  local tempReso = Resolution.window[3]
  
  
  
  tempReso = myDropList.Update(dt, Resolution.window[3])
  if tempReso ~= Resolution.window[3] then
    Resolution.window[3] = tempReso
    Resolution.window[1] = dropListProp.data[Resolution.window[3]][1]
    Resolution.window[2] = dropListProp.data[Resolution.window[3]][2]
    --love.window.setMode( Resolution.window[1], Resolution.window[2] )
  end
  
  return pGameState
end

function Resolution.Draw()
  love.graphics.draw(bgPic.src, 0, 0, 0, 1/bgPic.ratioW, 1/bgPic.ratioH)
  myDropList.Draw()
end

return Resolution