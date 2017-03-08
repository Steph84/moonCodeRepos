math.randomseed(os.time()) --initialiser le random

io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local listFrag = {}
local fragStep = 100
local fragRange = 100

function createFrag(x, y)
  local entity = {}
  entity.x1 = x
  entity.y1 = y
  entity.x2 = math.random(entity.x1 - fragRange, entity.x1 + fragRange)
  entity.y2 = entity.y1 + fragStep
  table.insert(listFrag, entity)
end

function love.load()
  love.window.setMode(windowWidth, windowHeight)
  local igniteFrag = {}
  igniteFrag.x1 = windowWidth/2
  igniteFrag.y1 = 10
  igniteFrag.x2 = math.random(igniteFrag.x1 - fragRange, igniteFrag.x1 + fragRange)
  igniteFrag.y2 = igniteFrag.y1 + fragStep
  
  table.insert(listFrag, igniteFrag)
  
end

function love.update(dt)
  if #listFrag < 5 then
    local i
    for i = 1, 5 do
      local f = listFrag[i]
      createFrag(f.x2, f.y2)
    end
  end
end

function love.draw()
  local i
  for i = 1, #listFrag do
    local f = listFrag[i]
    love.graphics.line(f.x1, f.y1, f.x2, f.y2)
  end
  
end

function love.keypressed(key)
  
  print(key)
  
end