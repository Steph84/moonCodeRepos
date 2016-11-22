math.randomseed(os.time()) --initialiser le random
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1200
local windowHeight = 600
local whiteColor = {255, 255, 255}

listPoints = {}
listPoints.rad = 0

startPoint = {}
startPoint.x = 0
startPoint.y = 0
startPoint.rad = 0
startPoint.seg = 0
startPoint.col = {}
startPoint.gap = 0

endPoint = {}
endPoint.x = 0
endPoint.y = 0
endPoint.rad = 0
endPoint.seg = 0
endPoint.col = {}
endPoint.gap = 0

level = {}
level.c = 0
level.l = 0
level.gap = 0

  
function love.load()
  love.window.setMode(windowWidth, windowHeight)
  love.graphics.setBackgroundColor(0, 102, 0)
  
  startPoint.gap = 50
  startPoint.x = startPoint.gap
  startPoint.y = windowHeight/2
  startPoint.rad = 10
  startPoint.seg = 6
  startPoint.col = {0, 128, 255}

  endPoint.gap = 50
  endPoint.x = windowWidth-endPoint.gap
  endPoint.y = windowHeight/2
  endPoint.rad = 10
  endPoint.seg = 6
  endPoint.col = {255, 128, 0}
    
  level.gap = 100
  level.c = ((windowWidth - 2*startPoint.gap - 2*endPoint.gap)/level.gap) - 1
  level.l = ((windowHeight)/level.gap) - 1
  
  listPoints.rad = 10
  
  -- random creation of nodes
  local i
  for i = 1, level.c do
    tempTuple = {}
    randL1 = love.math.random(level.l)
    tempTuple = {randL1, i}
    table.insert(listPoints, tempTuple)
    tempTuple = {}
    repeat
      randL2 = love.math.random(level.l)
    until randL2 ~= randL1
    tempTuple = {randL2, i}
    table.insert(listPoints, tempTuple)
  end
  
  local l, c, j
  for l = 1, level.l do
    level[l] = {}
    for c = 1, level.c do
      level[l][c] = 0
    end
  end
  
  for j = 1, #listPoints do
    --print(listPoints[j][1], listPoints[j][2])
    level[listPoints[j][1]][listPoints[j][2]] = 1
  end
  
end

function love.update(dt)

end

function love.draw()
  love.graphics.setColor(startPoint.col)
  love.graphics.circle("fill", startPoint.x, startPoint.y, startPoint.rad, startPoint.seg)  
  love.graphics.setColor(endPoint.col)
  love.graphics.circle("fill", endPoint.x, endPoint.y, endPoint.rad, endPoint.seg)  

  love.graphics.setColor(whiteColor)
  
  local l, c
  local bx, by = 0, 0
  for l = 1, level.l do
    bx = 0
    for c = 1, level.c do
      if level[l][c] == 1 then
        love.graphics.circle("fill", bx + 2*startPoint.gap + level.gap, by + level.gap, listPoints.rad) 
      end
      bx = bx + level.gap
    end
    by = by + level.gap
  end
  
end

function love.keypressed(key)
  if key == "space" or key == " " then --on regenere un donjon a chaque fois qu on appuie sur espace
    --randomPointsGen()
  end
end