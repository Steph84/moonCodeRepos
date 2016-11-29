math.randomseed(os.time()) --initialiser le random
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local whiteColor = {255, 255, 255}
local redColor = {255, 0, 0}
local orangeColor = {255, 128, 0}
local yellowColor = {255, 255, 0}
local green1Color = {128, 255, 0}
local green2Color = {0, 255, 0}
local green3Color = {0, 255, 128}
local blue1Color = {0, 255, 255}
local blue2Color = {0, 128, 255}
local blue3Color = {0, 0, 255}
local purple1Color = {127, 0, 255}
local purple2Color = {255, 0, 255}
local purple3Color = {255, 0, 127}

local windowWidth = 600
local windowHeight = 600
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

listArcs = {}

ant = {}
ant.x = 0
ant.y = 0
ant.pict = love.graphics.newImage("pictures/antPic.png")
ant.w = ant.pict:getWidth()
ant.h = ant.pict:getHeight()
ant.dir = "bottom"
ant.pos = "start"
ant.actual = {}
ant.next = " "


local speed = 30

  
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

  
  listArcs[1] = {startPoint.x, startPoint.y, coorPoints[1][1], coorPoints[1][2]}
  listArcs[2] = {startPoint.x, startPoint.y, coorPoints[2][1], coorPoints[2][2]}
  listArcs[3] = {coorPoints[1][1], coorPoints[1][2], coorPoints[3][1], coorPoints[3][2]}
  listArcs[4] = {coorPoints[1][1], coorPoints[1][2], coorPoints[4][1], coorPoints[4][2]}
  listArcs[5] = {coorPoints[2][1], coorPoints[2][2], coorPoints[3][1], coorPoints[3][2]}
  listArcs[6] = {coorPoints[3][1], coorPoints[3][2], coorPoints[5][1], coorPoints[5][2]}
  listArcs[7] = {coorPoints[4][1], coorPoints[4][2], coorPoints[5][1], coorPoints[5][2]}
  listArcs[8] = {coorPoints[4][1], coorPoints[4][2], coorPoints[6][1], coorPoints[6][2]}
  listArcs[9] = {coorPoints[5][1], coorPoints[5][2], coorPoints[7][1], coorPoints[7][2]}
  listArcs[10] = {coorPoints[5][1], coorPoints[5][2], coorPoints[8][1], coorPoints[8][2]}
  listArcs[11] = {coorPoints[6][1], coorPoints[6][2], coorPoints[8][1], coorPoints[8][2]}
  listArcs[12] = {endPoint.x, endPoint.y, coorPoints[7][1], coorPoints[7][2]}
  listArcs[13] = {endPoint.x, endPoint.y, coorPoints[8][1], coorPoints[8][2]}

  local arcNum
  for arcNum = 1, 13 do
    listArcs[arcNum].phero = 0
  end

  
  ant.x = startPoint.x
  ant.y = startPoint.y
  ant.orien = math.rad(180)
  ant.actual = {startPoint.x, startPoint.y}
  
end

function moveSpeed(dt, actualX)
  local subWay = (ant.next[1] - actualX)/100
  --print(ant.next[1], actualX, subWay)
  ant.x = ant.x + subWay*speed*dt
  return ant.x
end

function love.update(dt)
  --TODO
  --faire evoluer x, y et orien
  if ant.dir == "bottom" then
    if ant.pos == "start" then
      tempRand = love.math.random(2)
      ant.next = coorPoints[tempRand]
      ant.pos = "arc"
    end
    
    if ant.pos == "arc" then
      -- faire pivoter (orien)
      --print(ant.next[1], ant.next[2], ant.x, ant.y)
      if ant.y < ant.next[2] then
        moveSpeed(dt, ant.actual[1])
        ant.y = ant.y + 1*speed*dt
      else
        ant.pos = "node"
        ant.actual = ant.next
        ant.next = " "
      end
    end
    if ant.pos == "node" then
      print(tempRand)
      -- a remplacer par un switch case
      if tempRand == 1 then
        tempRand = 0
        tempRand = love.math.random(3, 4)
      elseif tempRand == 2 then
        tempRand = 3
      elseif tempRand == 4 then
        tempRand = 0
        tempRand = love.math.random(5, 6)
      elseif tempRand == 3 then
        tempRand = 5
      ant.pos = "arc"
      ant.next = coorPoints[tempRand]
      print(tempRand, coorPoints[tempRand][1], coorPoints[tempRand][2])
      end
      
      
    end
    
    
  end
end

function love.draw()
  love.graphics.setColor(startPoint.col)
  love.graphics.circle("fill", startPoint.x, startPoint.y, startPoint.rad, startPoint.seg)  
  love.graphics.setColor(endPoint.col)
  love.graphics.circle("fill", endPoint.x, endPoint.y, endPoint.rad, endPoint.seg)  

  love.graphics.setColor(whiteColor)
  local coorTuple--, xyCoor
  for coorTuple = 1, #coorPoints do
    love.graphics.circle("fill", coorPoints[coorTuple][1], coorPoints[coorTuple][2], listPoints.rad)
  end
  
  local arcNum
  for arcNum = 1, #listArcs do
    if listArcs[arcNum].phero == 0 then
      love.graphics.setColor(whiteColor)
    elseif listArcs[arcNum].phero == 0.1 then
      love.graphics.setColor(redColor)
    elseif listArcs[arcNum].phero == 0.2 then
      love.graphics.setColor(orangeColor)
    elseif listArcs[arcNum].phero == 0.3 then
      love.graphics.setColor(yellowColor)
    elseif listArcs[arcNum].phero == 0.4 then
      love.graphics.setColor(green1Color)
    elseif listArcs[arcNum].phero == 0.5 then
      love.graphics.setColor(green2Color)
    elseif listArcs[arcNum].phero == 0.6 then
      love.graphics.setColor(green3Color)
    elseif listArcs[arcNum].phero == 0.7 then
      love.graphics.setColor(blue1Color)
    elseif listArcs[arcNum].phero == 0.8 then
      love.graphics.setColor(blue2Color)
    elseif listArcs[arcNum].phero == 0.9 then
      love.graphics.setColor(blue3Color)
    elseif listArcs[arcNum].phero == 1.0 then
      love.graphics.setColor(purple1Color)
    elseif listArcs[arcNum].phero == 1.1 then
      love.graphics.setColor(purple2Color)
    elseif listArcs[arcNum].phero == 1.2 then
      love.graphics.setColor(purple3Color)
    end
    love.graphics.line(listArcs[arcNum])
    love.graphics.setColor(whiteColor)
  end
  
  love.graphics.draw(ant.pict, ant.x, ant.y, ant.orien, 0.2, 0.2, ant.w/2, ant.h/2)
  
end

function love.keypressed(key)
  if key == "space" or key == " " then --on regenere un donjon a chaque fois qu on appuie sur espace
    --randomPointsGen()
  end
end