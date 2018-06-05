local Game = {}

local windowWidth, windowHeight
local BlackHole = {}
BlackHole.src = {}


local objectNumber = 20
local listObjects = {}

function createObject(id, windowWidth, windowHeight)
  local item = {}
  
  item.id = id
  --item.nature = nature
  item.x = windowWidth/2
  item.y = windowHeight/2
  
  while item.x > 0 and item.x < windowWidth do
    item.x = math.random(-25, windowWidth + 25)
  end
  
  while item.y > 0 and item.y < windowHeight do
    item.y = math.random(-25, windowHeight + 25)
  end
  
  item.vx = 0
  item.vy = 0

  while item.vx == 0 do item.vx = math.random(-10, 10)/10 end
  while item.vy == 0 do item.vy = math.random(-10, 10)/10 end
  
  item.scaleX = 1
  item.scaleY = 1
  
  item.boundary = 50
  
  table.insert(listObjects, item)
end

function Game.Load(GameSizeCoefficient, pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  BlackHole.src = love.graphics.newImage("pictures/blackHole.png")
  BlackHole.x = windowWidth/2
  BlackHole.y = windowHeight/2
  BlackHole.speed = 5
  BlackHole.picW = BlackHole.src:getWidth()
  BlackHole.picH = BlackHole.src:getHeight()
  BlackHole.rotation = 0
  BlackHole.move = "forth"

  
  local i
  for i = 1, objectNumber do
    createObject(i, windowWidth, windowHeight)
  end
end


function Game.Update(dt)
  
  -- oscillation of the blackHole
  if BlackHole.move == "forth" then
    if BlackHole.rotation < 0.25 then
      BlackHole.rotation = BlackHole.rotation + 0.005
    else
      BlackHole.move = "back"
    end
  else
    if BlackHole.rotation > - 0.25 then
      BlackHole.rotation = BlackHole.rotation - 0.005
    else
      BlackHole.move = "forth"
    end
  end
  
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
  
  local i
  for i = #listObjects, 1, -1 do
    local o = listObjects[i]
    
    -- objects AI
    o.x = o.x + o.vx
    o.y = o.y + o.vy
    if o.x > windowWidth + o.boundary or o.x < 0 - o.boundary or
       o.y < 0 - o.boundary or o.y > windowHeight + o.boundary then
        table.remove(listObjects, i)
    end
    
    -- collision with blackHole
    if math.abs(o.x - BlackHole.x) < 25 and math.abs(o.y - BlackHole.y) < 25 then
      table.remove(listObjects, i)
    end
    
  end
end

function Game.Draw()
  love.graphics.setColor(255, 255, 255) -- white
  
  love.graphics.draw(BlackHole.src, BlackHole.x, BlackHole.y,
                     BlackHole.rotation, 1, 1, BlackHole.picW/2, BlackHole.picH/2)
  
  local i
  for i = #listObjects, 1, -1 do
    local o = listObjects[i]
    
    love.graphics.circle("fill", o.x, o.y, 5)
    
  end
  
  --love.graphics.printf("angle : "..BlackHole.rotation, 50, 50, 200, "left")
  love.graphics.setColor(0, 0, 0) -- black
  
end
  
return Game
  