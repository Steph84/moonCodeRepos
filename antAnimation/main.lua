math.randomseed(os.time()) --initialiser le random
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 600
local windowHeight = 600
local whiteColor = {255, 255, 255}
local coorPoints = {}

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
  startPoint.x = windowWidth/2
  startPoint.y = startPoint.gap
  startPoint.rad = 10
  startPoint.seg = 6
  startPoint.col = {0, 128, 255}

  endPoint.gap = 50
  endPoint.x = windowWidth/2
  endPoint.y = windowHeight-endPoint.gap
  endPoint.rad = 10
  endPoint.seg = 6
  endPoint.col = {255, 128, 0}
    
  level.gap = 100
  level.c = ((windowWidth)/level.gap) - 1
  level.l = ((windowHeight - startPoint.gap - endPoint.gap)/level.gap) - 1
  
  
  listPoints.rad = 10
  
  -- random creation of nodes
  local i
  for i = 1, level.l do
    tempTuple = {}
    randL1 = love.math.random(level.c)
    tempTuple = {i, randL1}
    table.insert(listPoints, tempTuple)
    tempTuple = {}
    repeat
      randL2 = love.math.random(level.c)
    until randL2 ~= randL1
    tempTuple = {i, randL2}
    table.insert(listPoints, tempTuple)
  end
  
  -- initialisation level to 0
  local l, c, j
  for l = 1, level.l do
    level[l] = {}
    for c = 1, level.c do
      level[l][c] = 0
    end
  end
  -- point to 1
  for j = 1, #listPoints do
    level[listPoints[j][1]][listPoints[j][2]] = 1
  end
  
  local lbis, cbis
  local bx, by = 0, 0
  for lbis = 1, level.l do
    bx = 0
    for cbis = 1, level.c do
      if level[lbis][cbis] == 1 then
        tempPoint = {}
        tempPoint = {bx + level.gap, by + level.gap + startPoint.gap}
        table.insert(coorPoints, tempPoint)
      end
      bx = bx + level.gap
    end
    by = by + level.gap
  end




  tempRand = love.math.random(3, 4)
 

  
end

function love.update(dt)

end

function love.draw()
  love.graphics.setColor(startPoint.col)
  love.graphics.circle("fill", startPoint.x, startPoint.y, startPoint.rad, startPoint.seg)  
  love.graphics.setColor(endPoint.col)
  love.graphics.circle("fill", endPoint.x, endPoint.y, endPoint.rad, endPoint.seg)  

  love.graphics.setColor(whiteColor)
  
  
  local coorTuple, xyCoor
  for coorTuple = 1, #coorPoints do
    print("machin", coorPoints[coorTuple])
    love.graphics.circle("fill", coorPoints[coorTuple][1], coorPoints[coorTuple][2], listPoints.rad)
  end
  
  love.graphics.line(startPoint.x, startPoint.y, coorPoints[1][1], coorPoints[1][2])
  love.graphics.line(startPoint.x, startPoint.y, coorPoints[2][1], coorPoints[2][2])
  
  love.graphics.line(coorPoints[1][1], coorPoints[1][2], coorPoints[3][1], coorPoints[3][2])
  love.graphics.line(coorPoints[1][1], coorPoints[1][2], coorPoints[4][1], coorPoints[4][2])
  love.graphics.line(coorPoints[2][1], coorPoints[2][2], coorPoints[3][1], coorPoints[3][2])
  
  love.graphics.line(coorPoints[3][1], coorPoints[3][2], coorPoints[5][1], coorPoints[5][2])
  love.graphics.line(coorPoints[4][1], coorPoints[4][2], coorPoints[5][1], coorPoints[5][2])
  love.graphics.line(coorPoints[4][1], coorPoints[4][2], coorPoints[6][1], coorPoints[6][2])
  
  love.graphics.line(coorPoints[5][1], coorPoints[5][2], coorPoints[7][1], coorPoints[7][2])
  love.graphics.line(coorPoints[5][1], coorPoints[5][2], coorPoints[8][1], coorPoints[8][2])
  love.graphics.line(coorPoints[6][1], coorPoints[6][2], coorPoints[8][1], coorPoints[8][2])
  
  love.graphics.line(endPoint.x, endPoint.y, coorPoints[7][1], coorPoints[7][2])
  love.graphics.line(endPoint.x, endPoint.y, coorPoints[8][1], coorPoints[8][2])


end

function love.keypressed(key)
  if key == "space" or key == " " then --on regenere un donjon a chaque fois qu on appuie sur espace
    --randomPointsGen()
  end
end