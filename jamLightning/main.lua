math.randomseed(os.time()) --initialiser le random

io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local listFrag = {}
local fragStep = 80
local fragRange = 100
local maxBranch = 3
local nbStep = windowHeight/fragStep

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
  igniteFrag.y1 = 10
  igniteFrag.x2 = math.random(igniteFrag.x1 - fragRange, igniteFrag.x1 + fragRange)
  igniteFrag.y2 = igniteFrag.y1 + fragStep
  igniteFrag.volt = 10
  
  table.insert(listFrag, igniteFrag)
  
end

function love.update(dt)
  if #listFrag < nbStep then
    local i
    for i = 1, nbStep do
      local f = listFrag[i]
      local nbBranch = math.random(1, maxBranch)
      local j
      for j = 1, nbBranch do
        createFrag(f.x2, f.y2, f.volt-1)
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