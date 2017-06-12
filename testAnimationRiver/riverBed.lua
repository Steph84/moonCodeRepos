local RiverBed = {}

local windowWidth, windowHeight
RiverBed.elements = {}
local riverWidth = 200

function RiverElement(pId, pCoords)
  local item = {}
  item.id = pId
  item.coords = pCoords
  item.coeffDir = (pCoords[6] - pCoords[4]) / (pCoords[5] - pCoords[3])
  
  table.insert(RiverBed.elements, item)
end

function RiverBed.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  local firstElement = {0, 0,
                        0 + riverWidth, 0,
                        windowWidth, windowHeight,
                        windowWidth - riverWidth, windowHeight}
  RiverElement(1, firstElement)
  
end

function RiverBed.Draw()
  love.graphics.setColor(0, 0, 255)
  local i, j
  for i = 1, #RiverBed.elements do
    local e = RiverBed.elements[i]
    love.graphics.polygon("fill", e.coords)
  end
  
  
  
end


return RiverBed