math.randomseed(os.time()) --initialiser le random

io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local listFrag = {}
local departure = 10
local fragStep = 50
local fragRange = 100
local nbBranch = 3
local nbStep = windowHeight/fragStep
local newSize = 0
local oldSize = 0

function createFrag(pX, pY, pVolt)
  local entity = {}
  entity.x1 = pX
  entity.y1 = pY
  entity.x2 = math.random(entity.x1 - fragRange, entity.x1 + fragRange)
  entity.y2 = entity.y1 + fragStep
  entity.volt = pVolt
  table.insert(listFrag, entity)
end

function love.load()
  love.window.setMode(windowWidth, windowHeight)
  local igniteFrag = {}
  igniteFrag.x1 = windowWidth/2
  igniteFrag.y1 = departure
  igniteFrag.x2 = math.random(igniteFrag.x1 - fragRange, igniteFrag.x1 + fragRange)
  igniteFrag.y2 = igniteFrag.y1 + fragStep
  igniteFrag.volt = 12
  
  table.insert(listFrag, igniteFrag)
  
end

function love.update(dt)
    if listFrag[#listFrag].y2 == departure + fragStep then
      oldSize = #listFrag
      local i
      for i = 1, nbBranch do
        local tempSizeList = #listFrag
        createFrag(listFrag[ tempSizeList + 1 - i ].x2,
                   listFrag[ tempSizeList + 1 - i ].y2,
                   listFrag[ tempSizeList + 1 - i ].volt * ( i / nbBranch ) - 1)
      end
      newSize = #listFrag
    end
    
    if listFrag[#listFrag].y2 == departure + 2 * fragStep then
      local stepToCheck = newSize - oldSize
      local a
      local indexToCheck = {}
      for a = #listFrag - stepToCheck, #listFrag do
        if listFrag[a].volt > 2 then table.insert(indexToCheck, a) end
      end
      
      local b
      for b = 1, #indexToCheck do
        local i
        for i = 1, nbBranch do
          createFrag(listFrag[indexToCheck[b]].x2,
                     listFrag[indexToCheck[b]].y2,
                     listFrag[indexToCheck[b]].volt * ( i / nbBranch ) - 1)
        end
      end
    end
    
end

function love.draw()
  local i
  for i = 1, #listFrag do
    local f = listFrag[i]
    love.graphics.setLineWidth(f.volt)
    love.graphics.line(f.x1, f.y1, f.x2, f.y2)
  end
  
end

function love.keypressed(key)
  
  print(key)
  
end