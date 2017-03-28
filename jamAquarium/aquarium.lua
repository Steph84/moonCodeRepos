math.randomseed(os.time())

local Aqua = {}

Aqua.background = {}
Aqua.bubbles = {}
local i
 for i = 1, 4 do
    Aqua.bubbles[i] = {}
 end

local listBubbles = {}
local maxBubbles = 50

local myPlants = require("plant")

function createBubble(ppWindowHeight, pInit)
  local item = {}
  
  item.color = math.random(1, 4)
  
  if pInit == true then
    item.y = math.random(0, ppWindowHeight)
  elseif pInit == false then
    item.y = math.random(ppWindowHeight, ppWindowHeight + 50)
  end
  
  local tempRand = 0
  while tempRand == 0 do
    tempRand = math.random(-5, 5)/5
  end
  
  item.x = math.random(50, 150)
  item.vx = tempRand
  item.vy = math.random(- 5, - 1)/5
    
  table.insert(listBubbles, item)
end

function Aqua.Load(pWindowWidth, pWindowHeight)
  
  Aqua.background.src = love.graphics.newImage("pictures/underwater.png")
  Aqua.background.w = Aqua.background.src:getWidth() -- 1024
  Aqua.background.h = Aqua.background.src:getHeight() -- 768
  
  Aqua.background.scale = pWindowHeight / Aqua.background.h
  
  local i
  for i = 1, 4 do
    Aqua.bubbles[i].src = love.graphics.newImage("pictures/bubble"..i..".png")
  end
  Aqua.bubbles.w = Aqua.bubbles[1].src:getWidth() -- 322
  Aqua.bubbles.h = Aqua.bubbles[1].src:getHeight() -- 322
  Aqua.bubbles.scale = 0.1 -- 32 pixels
  
  local j
  for j = 1, maxBubbles do
    createBubble(pWindowHeight, true)
  end
  
  myPlants.Load(pWindowWidth, pWindowHeight)
  
  
end

function Aqua.Update(pDt, pWindowHeight)
  
  if #listBubbles < maxBubbles then
    createBubble(pWindowHeight, false)
  end
  
  local i
  for i = #listBubbles, 1, -1 do
    local b = listBubbles[i]
    b.x = b.x + b.vx
    b.y = b.y + b.vy
    
    if b.x < 50 or b.x > 150 then b.vx = - b.vx end
    
    if b.y < (- 40) then table.remove(listBubbles, i) end
    
  end
  
  myPlants.Update(pDt)
    
end


function Aqua.Draw()
  
  love.graphics.draw(Aqua.background.src, 0, 0, 0, Aqua.background.scale, Aqua.background.scale)
  love.graphics.draw(Aqua.background.src, Aqua.background.w * Aqua.background.scale, 0, 0, Aqua.background.scale, Aqua.background.scale)
  
  local i
  for i = 1, #listBubbles do
    local b = listBubbles[i]
    love.graphics.draw(Aqua.bubbles[b.color].src, b.x, b.y, 0, Aqua.bubbles.scale, Aqua.bubbles.scale)
  end
  
  myPlants.Draw()
  
end

return Aqua