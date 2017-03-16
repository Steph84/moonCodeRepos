local River = {}

local riverSize = {}
local riverCoord = {}

local listTides = {}
listTides.initNb = 100
listTides.maxNb = 100
listTides.maxSpeed = 3

local tideSize = {}
local tideCoord = {}

local whiteColor = {255, 255, 255}
local blue1Color = {0, 255, 255} -- cyan
local blue2Color = {0, 128, 255} -- medium blue
local blue3Color = {0, 0, 255} -- royal blue

function createTide(pId, pRiverY, pRiverWidth, pRiverHeight)
  local item = {}
  
  item.id = pId
  item.w = math.random(2, 10)
  item.h = 5
  item.x = math.random(0, pRiverWidth)
  item.y = math.random(pRiverY + item.h, pRiverY + pRiverHeight - item.h)
  item.vy = 0
  
  if item.y < (pRiverY + pRiverHeight/2) then
    local b = item.y/pRiverY
    item.vx = b * listTides.maxSpeed
  end
  
  if item.y > (pRiverY + pRiverHeight/2) then
    local c = item.y/(pRiverY + pRiverHeight)
    item.vx = 1/c * listTides.maxSpeed
  end
  
  table.insert(listTides, item)
  
  return item
end

function River.Load(pWindowWidth, pWindowHeight)
  riverSize.w = pWindowWidth
  riverSize.h = pWindowHeight * 0.2
  
  riverCoord.x = 0
  riverCoord.y = pWindowHeight/2 - riverSize.h/2
  
  local i
  for i = 1, listTides.initNb do
    createTide(i, riverCoord.y, riverSize.w, riverSize.h)
  end
end

function River.Update(pWindowWidth, pWindowHeight)
  local i
  for i = #listTides, 1, -1 do
    local a = listTides[i]
    a.x = a.x + a.vx
    
    if a.x > pWindowWidth then
      table.remove(listTides, i)
    end
    
    if #listTides < listTides.maxNb then
      createTide(#listTides + 1, riverCoord.y, riverSize.w/pWindowWidth * 100, riverSize.h)
    end
    
  end
end

function River.Draw()
  love.graphics.setColor(blue3Color)
  love.graphics.rectangle("fill", riverCoord.x, riverCoord.y, riverSize.w, riverSize.h)
  love.graphics.setColor(whiteColor)
  
  love.graphics.setColor(blue2Color)
  local i
  for i = 1, #listTides do
    local a = listTides[i]
    love.graphics.rectangle("fill", a.x, a.y, a.w, a.h)
  end
  love.graphics.setColor(whiteColor)
  
  love.graphics.print("number of tides "..#listTides, 5, 5)
end




return River