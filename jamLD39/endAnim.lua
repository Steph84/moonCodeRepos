local EndAnim = {}

local windowWidth, windowHeight, status, endFont, titleFont, dataFont
local coorStatus, coorHoriTitle, coorVertTitle, coorData = {}, {}, {}, {}
local calculDone = false

local myMap = require("map")
local myMachina = require("machina")

local verticalTitles = {"Harvest Oil", "Oil Left", "Map Explored (%)"}
local horizontalTitles = {"Grassland", "Desert", "Ocean", "Toundra", "Mars", "Total"}
local dataByLevel = {}
local iter
for iter = 1, 6 do
  dataByLevel[iter] = {0, 0, 0}
end

function EndAnim.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  endFont = love.graphics.newFont("fonts/Pacifico.ttf", 32)
  titleFont = love.graphics.newFont("fonts/Pacifico.ttf", 24)
  dataFont = love.graphics.newFont("fonts/Pacifico.ttf", 20)
  
  coorStatus = {x = 0, y = windowHeight * 0.1}
  coorHoriTitle = {x = windowWidth * 1/8 + 16, y = coorStatus.y + ((windowHeight - coorStatus.y) * 1/6)}
  coorVertTitle = {x = 0 + 16, y = coorHoriTitle.y + ((windowHeight - coorHoriTitle.y) * 1/6)}
  coorData = {x = coorHoriTitle.x, y = coorHoriTitle.y + ((windowHeight - coorHoriTitle.y) * 1/6)}
  
end

function EndAnim.Update(dt, pStatus)
  status = pStatus
  if calculDone == false then
    local tempSize = myMap.size.w * myMap.size.h
    local k
    for k = 1, #dataByLevel - 1 do
      dataByLevel[k][1] = myMachina.countOil[k]
      dataByLevel[6][1] = dataByLevel[6][1] + dataByLevel[k][1]
      
      dataByLevel[k][2] = myMap.countOil[k]
      dataByLevel[6][2] = dataByLevel[6][2] + dataByLevel[k][2]
      
      dataByLevel[k][3] = math.floor((myMap.fogOutCount[k]/tempSize) * 1000)/10
      dataByLevel[6][3] = dataByLevel[6][3] + myMap.fogOutCount[k]
    end
    dataByLevel[6][3] = math.floor(dataByLevel[6][3] / (tempSize * 5) * 1000)/10
    calculDone = true
  end
end

function EndAnim.Draw()
  if status == "win" then
    love.graphics.setFont(endFont)
    love.graphics.printf("You discover the plutonium bar !!!", coorStatus.x, coorStatus.y, windowWidth, "center")
  end
  
  if status == "lose" then
    love.graphics.setFont(endFont)
    love.graphics.printf("Running out of power...", coorStatus.x, coorStatus.y, windowWidth, "center")
  end
  
  local i
  for i = 1, #horizontalTitles do
    love.graphics.setFont(titleFont)
    love.graphics.printf(horizontalTitles[i], coorHoriTitle.x * i, coorHoriTitle.y, windowWidth/8, "center")
  end
    
  local j
  for j = 1, #verticalTitles do
    love.graphics.setFont(titleFont)
    love.graphics.printf(verticalTitles[j], coorVertTitle.x, coorVertTitle.y + (j-1) * windowHeight/6, windowWidth/8, "center")
  end
  
  local k, l
  for k = 1, #dataByLevel do -- parse level
    for l = 1, #dataByLevel[k] do -- parse element of each level
      local d = dataByLevel[k][l]
      love.graphics.setFont(dataFont)
      love.graphics.printf(d, coorData.x * k, coorData.y + (l-1) * windowHeight/6, windowWidth/8, "center")
    end
  end
  
end

return EndAnim