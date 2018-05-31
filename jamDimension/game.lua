local Game = {}

local windowWidth, windowHeight
local BlackHole = {}
BlackHole.tileSheet = {}


local objectNumber = 20
local listObjects = {}

function createObject(id, windowWidth, windowHeight)
  local item = {}
  
  item.id = id
  
  item.x = math.random(100, windowWidth - 100)
  item.y = math.random(100, windowHeight - 100)

  item.dir = 0
  while item.dir == 0 do item.dir = math.random(-1, 1) end
  
  item.vy = 0
  item.vx = item.dir *  math.random(1, 10)/10
  while item.vy == 0 do item.vy = math.random(-10, 10)/10 end
  
  item.scaleX = 1
  item.scaleY = 1
  
  item.boundary = 50
  
  table.insert(listObjects, item)
end

function Game.Load(GameSizeCoefficient, pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  --BlackHole.tileSheet = love.graphics.newImage("pictures/color_fish.png")
  BlackHole.x = windowWidth/2
  BlackHole.y = windowHeight/2
  BlackHole.speed = 10
  
  local i
  for i = 1, objectNumber do
    createObject(i, windowWidth, windowHeight)
  end
end


function Game.Update(dt)
  
  while #listObjects < objectNumber do createObject(#listObjects + 1, windowWidth, windowHeight) end
  
  -- blackHole movements
  if love.keyboard.isDown("down") then
    BlackHole.y = BlackHole.y + BlackHole.speed
  end

  if love.keyboard.isDown("up") then
    BlackHole.y = BlackHole.y - BlackHole.speed
  
  end

  if love.keyboard.isDown("left") then
    BlackHole.x = BlackHole.x - BlackHole.speed
  end

  if love.keyboard.isDown("right") then
    BlackHole.x = BlackHole.x + BlackHole.speed
  end
  
  -- objects AI
  local i
  for i = #listObjects, 1, -1 do
    local o = listObjects[i]
    
    -- movement
    o.x = o.x + o.vx
    o.y = o.y + o.vy
    
    if o.x > windowWidth + o.boundary or o.x < 0 - o.boundary or
       o.y < 0 - o.boundary or o.y > windowHeight + o.boundary then
        table.remove(listObjects, i)
    end
    
  end
end

function Game.Draw()
  love.graphics.setColor(255, 255, 255) -- white
  
  local i
  for i = #listObjects, 1, -1 do
    local o = listObjects[i]
    
    love.graphics.circle("fill", o.x, o.y, 5)
    
  end
  
  love.graphics.setColor(0, 0, 0) -- black
end
  
return Game
  