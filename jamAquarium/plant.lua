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
  item.y = pppWindowHeight - Plant.grassPic[item.choice].h * Plant.grassPic.scale/2 + 15
  item.r = 0
  
  local tempRand = 0
  while tempRand == 0 do
    tempRand = math.random(-2, 2)/1000
  end
  item.vr = tempRand
  
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

function Plant.Update(ppDt)
  local i
  for i = 1, #listGrasses do
    local g = listGrasses[i]
    g.r = g.r + g.vr
    if g.r > 0.1 or g.r < (- 0.1) then g.vr = - g.vr end
  end
  
  
end

function Plant.Draw()
  local i
  for i = 1, #listGrasses do
    local g = listGrasses[i]
    love.graphics.push()
    love.graphics.translate(g.x + Plant.grassPic[g.choice].w * Plant.grassPic.scale/2,
                            g.y + Plant.grassPic[g.choice].h * Plant.grassPic.scale - 32)
    love.graphics.rotate(g.r)
    love.graphics.translate( - g.x - Plant.grassPic[g.choice].w * Plant.grassPic.scale/2,
                             - g.y - Plant.grassPic[g.choice].h * Plant.grassPic.scale + 32)
    love.graphics.draw(Plant.grassPic[g.choice].src, g.x, g.y, 0, Plant.grassPic.scale, Plant.grassPic.scale, 1000/2, 2000/2)
    love.graphics.pop()
  end
end

return Plant