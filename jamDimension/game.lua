local Game = {}

local windowWidth, windowHeight
local BlackHole = {}
BlackHole.src = {}

local objectNumber = 10
local listObjects = {}
local bgMusic = {}
Game.duration = 0
Game.timeElapsed = 0

function createObject(id, windowWidth, windowHeight, pNature)
  local item = {}
  item.nature = Game.phase
  if pNature ~= nil then
    item.nature = pNature
  end
  
  item.id = id
  item.x = windowWidth/2
  item.y = windowHeight/2
  
  while item.x > 0 and item.x < windowWidth do
    item.x = math.random(-5, windowWidth + 5)
  end
  
  while item.y > 0 and item.y < windowHeight do
    item.y = math.random(-5, windowHeight + 5)
  end
  
  item.vx = 0
  item.vy = 0

  while item.vx == 0 do item.vx = math.random(-10, 10)/10 end
  while item.vy == 0 do item.vy = math.random(-10, 10)/10 end
  
  item.scaleX = 1
  item.scaleY = 1
  
  if item.nature == 0 then
    item.circSize = 5
  elseif item.nature == 1 then
    item.lineSize = 50
    item.x2 = math.random(item.x - item.lineSize, item.x + item.lineSize)
    item.y2 = math.random(item.y - item.lineSize, item.y + item.lineSize)
  elseif item.nature == 2 then
    item.size = 100
    item.vertexNb = math.random(3, 5)
    item.vertices = {}
    table.insert(item.vertices, item.x)
    table.insert(item.vertices, item.y)
    while #item.vertices < (item.vertexNb * 2) do
      local tempX = math.random(item.x - item.size, item.x + item.size)
      table.insert(item.vertices, tempX)
      local tempY = math.random(item.y - item.size, item.y + item.size)
      table.insert(item.vertices, tempY)
    end
  end
  
  item.boundary = 20
  
  table.insert(listObjects, item)
end

function Game.Load(GameSizeCoefficient, pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  Game.phase = 0
  
  BlackHole.src = love.graphics.newImage("pictures/blackHole.png")
  BlackHole.x = windowWidth/2
  BlackHole.y = windowHeight/2
  BlackHole.speed = 1
  BlackHole.picW = BlackHole.src:getWidth()
  BlackHole.picH = BlackHole.src:getHeight()
  BlackHole.rotation = 0
  BlackHole.move = "forth"

  local i
  for i = 1, objectNumber do
    createObject(i, windowWidth, windowHeight)
  end
  
  -- load the background music
  bgMusic = love.audio.newSource("musics/reptileSong.wav", "stream")
  bgMusic:setLooping(false)
  bgMusic:setVolume(0.75)
  --bgMusic:play()
  Game.duration = bgMusic:getDuration() -- in seconds
  
end


function Game.Update(dt)
  
  -- manage the phases in relation to the time
  if Game.timeElapsed > 125 and Game.timeElapsed < 280 then
    Game.phase = 1
  elseif Game.timeElapsed >= 280 then
    Game.phase = 2
  end
  
  
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
  
  --while #listObjects < objectNumber do
    --createObject(#listObjects + 1, windowWidth, windowHeight)
  --end
  
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
    if o.nature ~= 2 then
      o.x = o.x + o.vx
      o.y = o.y + o.vy
    end
    
    if o.nature == 1 then
      o.x2 = o.x2 + o.vx
      o.y2 = o.y2 + o.vy
    end
    
    if o.nature == 2 then
      for j = 1, #o.vertices do
        --local coor = o.vertices[j]
        if (j % 2 == 0) then
          -- even == y
          o.vertices[j] = o.vertices[j] + o.vx
        else
          -- odd == x
          o.vertices[j] = o.vertices[j] + o.vy
        end
      end
    end
    
    
    -- collision with blackHole
    if Game.phase == 2 then
      
      if math.abs(o.vertices[1] - BlackHole.x) < 25 and math.abs(o.vertices[2] - BlackHole.y) < 25 then
        table.remove(listObjects, i)
      end
      
      if o.vertices[1] > windowWidth + o.boundary or o.vertices[1] < 0 - o.boundary or
         o.vertices[2] < 0 - o.boundary or o.vertices[2] > windowHeight + o.boundary then
          table.remove(listObjects, i)
      end
      
    else
    
      if math.abs(o.x - BlackHole.x) < 25 and math.abs(o.y - BlackHole.y) < 25 then
        table.remove(listObjects, i)
        if o.nature == Game.phase then -- if it is the good phase/dimension
          createObject(#listObjects + 1, windowWidth, windowHeight, Game.phase + 1) -- ok
        else
          createObject(#listObjects + 1, windowWidth, windowHeight, 0) -- else create points
        end
      end
      
      if o.x > windowWidth + o.boundary or o.x < 0 - o.boundary or
         o.y < 0 - o.boundary or o.y > windowHeight + o.boundary then
          table.remove(listObjects, i)
          createObject(#listObjects + 1, windowWidth, windowHeight, o.nature) -- ok
      end
      
    end
    
  end
  Game.timeElapsed = Game.timeElapsed + dt
end

function Game.Draw()
  love.graphics.setColor(255, 255, 255) -- white
  
  love.graphics.draw(BlackHole.src, BlackHole.x, BlackHole.y,
                     BlackHole.rotation, 1, 1, BlackHole.picW/2, BlackHole.picH/2)
  
  local i
  for i = #listObjects, 1, -1 do
    local o = listObjects[i]
    
    if o.nature == 0 then
      love.graphics.circle("fill", o.x, o.y, o.circSize)
    elseif o.nature == 1 then
      love.graphics.line(o.x, o.y, o.x2, o.y2)
    elseif o.nature == 2 then
      love.graphics.polygon("fill", o.vertices)
      love.graphics.print("x : "..o.vertices[1]..", y : "..o.vertices[2], o.vertices[1], o.vertices[2])
    end
    
  end
  
  --love.graphics.printf("angle : "..BlackHole.rotation, 50, 50, 200, "left")
  
  love.graphics.printf("PHASE "..Game.phase, 10, 10, windowWidth, "left")
  
  love.graphics.setColor(0, 0, 0) -- black
  
end
  
return Game
  