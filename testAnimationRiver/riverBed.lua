local RiverBed = {}

local windowWidth, windowHeight
RiverBed.elements = {}
local riverWidth = 200

local myFlow = require("riverFlow")

function RiverElement(pId, pCoords)
  local item = {}
  item.id = pId
  item.coords = pCoords
  item.leftBankCoeffDir = (pCoords[6] - pCoords[4]) / (pCoords[5] - pCoords[3])
  item.rightBankCoeffDir = (pCoords[8] - pCoords[2]) / (pCoords[7] - pCoords[1])
  item.leftBankOrdo = pCoords[4] - item.leftBankCoeffDir * pCoords[3]
  item.rightBankOrdo = pCoords[2] - item.rightBankCoeffDir * pCoords[1]
  item.averageCoeffDir = (item.leftBankCoeffDir + item.rightBankCoeffDir) /2
  
  table.insert(RiverBed.elements, item)
end

function RiverBed.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  local firstElement = {0, 0,
                        0 + riverWidth, 0,
                        windowWidth, windowHeight,
                        windowWidth - 2 * riverWidth, windowHeight}
  RiverElement(1, firstElement)
  
  myFlow.Load(windowWidth, windowHeight, RiverBed.elements)
  
end

function RiverBed.Draw()
  love.graphics.setColor(0, 0, 255)
  local i
  for i = 1, #RiverBed.elements do
    local e = RiverBed.elements[i]
    love.graphics.polygon("fill", e.coords)
  end
  
  myFlow.Draw()
  
  
end


return RiverBed