math.randomseed(os.time())
local RiverFlow = {}

local windowWidth, windowHeight
local listTides = {}
listTides.initNb = 10
listTides.maxNb = 100
listTides.maxSpeed = 3
local bedElements

function CreateTide(pId, windowWidth, windowHeight, pBedElements)
  local item = {}
  
  item.id = pId
  item.x = math.random(1, windowWidth)
  item.y = -1
  local leftBankY = pBedElements.leftBankCoeffDir * item.x + pBedElements.leftBankOrdo
  local rightBankY = pBedElements.rightBankCoeffDir * item.x + pBedElements.rightBankOrdo 
  while item.y < 0 or item.y > windowHeight do
    item.y = math.random(leftBankY, rightBankY)
  end
  
  table.insert(listTides, item)
  
end

function RiverFlow.Load(pWindowWidth, pWindowHeight, pBedElements)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  bedElements = pBedElements
  
  local i, j
  for i = 1, listTides.initNb do
    for j = 1, #pBedElements do
      CreateTide(i, windowWidth, windowHeight, bedElements[j])
    end
  end
  
end

function RiverFlow.Update(dt)
  local i, j
  for i = #listTides, 1, -1 do
    for j = 1, #bedElements do
      local a = listTides[i]
      a.x = a.x + listTides.maxSpeed
      a.y = a.y + bedElements[j].averCoeffDir * listTides.maxSpeed
      
      if a.x > windowWidth or a.y > windowHeight then table.remove(listTides, i) end
      
      --[[
      if #listTides < listTides.maxNb then
        createTide(#listTides + 1, riverCoord.y, riverSize.w/pWindowWidth * 100, riverSize.h)
      end
      --]]
    end
  end
end

function RiverFlow.Draw()
  love.graphics.setColor(255, 255, 255)
  local j
  for j = 1, #listTides do
    local t = listTides[j]
    love.graphics.circle("fill", t.x, t.y, 3)
  end
end

return RiverFlow