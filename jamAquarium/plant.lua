math.randomseed(os.time())

local Plant = {}

Plant.grassPic = {}

local i
for i = 1, 4 do
  Plant.grassPic[i] = {}
end

local listGrasses = {}
local maxGrass = 30

function createGrass(pppWindowWidth, pppWindowHeight, pGrassPic)
  local item = {}
  
  item.choice = math.random(1, 4)
  
  item.x = math.random(0, pppWindowWidth)
  item.y = math.random(pppWindowHeight - 64, pppWindowHeight)
  item.r = 0
  
  table.insert(listGrasses, item)
end

function Plant.Load(ppWindowWidth, ppWindowHeight)
  local i
  for i = 1, 4 do
    Plant.grassPic[i].src = love.graphics.newImage("pictures/grass"..i..".png")
    Plant.grassPic[i].w = Plant.grassPic[i].src:getWidth() -- ~ 400-900
    Plant.grassPic[i].h = Plant.grassPic[i].src:getHeight() -- ~ 2000
  end

  Plant.grassPic.scale = 256 / Plant.grassPic[1].h -- for 256 pixels high

  local j
  for j = 1, maxGrass do
    createGrass(ppWindowWidth, ppWindowHeight, Plant.grassPic)
  end
end

function Plant.Update(pDt)
  -- TODO change the rotation param to make move the grass
end

function Plant.Draw()
  local i
  for i = 1, #listGrasses do
    local g = listGrasses[i]
    love.graphics.draw(Plant.grassPic[g.choice].src, g.x, g.y, g.r, Plant.grassPic.scale, Plant.grassPic.scale, 1000/2, 2000/2)
  end
end

return Plant