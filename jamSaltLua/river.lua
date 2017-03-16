local River = {}

local myColor = require("color")

local riverSize = {}
local riverCoord = {}

local listTides = {}
listTides.initNb = 100
listTides.maxNb = 100
listTides.maxSpeed = 3

local listLeaves = {}
listLeaves.initNb = 50
listLeaves.maxNb = 50
listLeaves.maxSpeed = 2

local tideSize = {}
local tideCoord = {}

local whiteColor = {255, 255, 255}
local blue1Color = {0, 255, 255} -- cyan
local blue2Color = {0, 128, 255} -- medium blue
local blue3Color = {0, 0, 255} -- royal blue
local green2Color = {0, 255, 0}

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

function createLeaf(pId, pRiverY, pRiverWidth, pRiverHeight)
  local item = {}
  
  item.id = pId
  item.radX = 7
  item.radY = 3
  item.x = math.random(0, pRiverWidth)
  item.y = math.random(pRiverY + item.radX, pRiverY + pRiverHeight - item.radY)
  item.vy = 0
  item.alpha = math.random(100, 255)
  item.alphaSpeed = math.random(50, 75)
  
  if item.y < (pRiverY + pRiverHeight/2) then
    local b = item.y/pRiverY
    item.vx = b * listLeaves.maxSpeed
  end
  
  if item.y > (pRiverY + pRiverHeight/2) then
    local c = item.y/(pRiverY + pRiverHeight)
    item.vx = 1/c * listLeaves.maxSpeed
  end
  
  table.insert(listLeaves, item)
  
  return item
end

function River.Load(pWindowWidth, pWindowHeight)
  riverSize.w = pWindowWidth
  riverSize.h = pWindowHeight * 0.3
  
  riverCoord.x = 0
  riverCoord.y = pWindowHeight/2 - riverSize.h/2
  
  local i
  for i = 1, listTides.initNb do
    createTide(i, riverCoord.y, riverSize.w, riverSize.h)
  end
  
  local j
  for j = 1, listLeaves.initNb do
    createLeaf(i, riverCoord.y, riverSize.w, riverSize.h)
  end
end

function River.Update(pDt, pWindowWidth, pWindowHeight)
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
  
  local j
  for j = #listLeaves, 1, -1 do
    local b = listLeaves[j]
    b.x = b.x + b.vx
    b.alpha = b.alpha + b.alphaSpeed * pDt
    
    
    if b.x > pWindowWidth then
      table.remove(listLeaves, j)
    end
    
    if #listLeaves < listLeaves.maxNb then
      createLeaf(#listLeaves + 1, riverCoord.y, riverSize.w/pWindowWidth * 100, riverSize.h)
    end
    
    if b.alpha > 255 then
      b.alphaSpeed = 0 - b.alphaSpeed
    end
    if b.alpha < 100 then
      b.alphaSpeed = 0 - b.alphaSpeed
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
  
  local i
  for i = 1, #listLeaves do
    local d = listLeaves[i]
    love.graphics.setColor(green2Color[1], green2Color[2], green2Color[3], d.alpha)
    love.graphics.ellipse("fill", d.x, d.y, d.radX, d.radY)
  end
  love.graphics.setColor(whiteColor)
  
  --love.graphics.print("number of tides "..#listTides, 5, 5)
end




return River