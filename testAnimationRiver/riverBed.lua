local RiverBed = {}

local windowWidth, windowHeight
RiverBed.elements = {}
local riverWidth = 200

function StraigthHorizontal(pId, pXStart, pYStart, pXEnd, pYEnd)
  local item = {}
  item.id = pId
  item.x = pXStart
  item.y = pYStart
  item.w = pXEnd - pXStart
  item.h = pYEnd - pYStart
  table.insert(RiverBed.elements, item)
end

function StraigthVertical(pId, pXStart, pYStart, pXEnd, pYEnd)
  local item = {}
  item.id = pId
  item.x = pXStart
  item.y = pYStart
  item.w = pXEnd - pXStart
  item.h = pYEnd - pYStart
  table.insert(RiverBed.elements, item)
end

function StraigthDiagonal(pId, pXStart, pYStart, pXEnd, pYEnd, pGranularity, pWindowWidth, pWindowHeight, pRiverWidth)
  local item = {}
  local itemPart = {}
  local j
  for j = 1, (pYEnd - pYStart - pRiverWidth) do
    itemPart.id = j
    itemPart.x = pXStart
    itemPart.y = pYStart
    itemPart.w = windowWidth/2
    itemPart.h = riverWidth
    table.insert(item, itemPart)
  end
  item.id = pId
  
  table.insert(RiverBed.elements, item)
end

function RiverBed.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  --StraigthHorizontal(1, 0, 0, windowWidth - riverWidth, riverWidth)
  --StraigthVertical(2, windowWidth - riverWidth, 0, windowWidth, windowHeight)
  StraigthDiagonal(3, 0, 0, windowWidth, windowHeight, windowHeight/2, windowWidth, windowHeight, riverWidth)
  
end

function RiverBed.Draw()
  love.graphics.setColor(0, 0, 255)
  local i
  for i = 1, #RiverBed.elements do
    local e = RiverBed.elements[i]
    love.graphics.rectangle("fill", e.x, e.y, e.w, e.h)
  end
end


return RiverBed