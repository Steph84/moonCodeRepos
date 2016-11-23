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

  arc1 = {startPoint.x, startPoint.y, coorPoints[1][1], coorPoints[1][2]}
  arc2 = {startPoint.x, startPoint.y, coorPoints[2][1], coorPoints[2][2]}
  
  arc3 = {coorPoints[1][1], coorPoints[1][2], coorPoints[3][1], coorPoints[3][2]}
  arc4 = {coorPoints[1][1], coorPoints[1][2], coorPoints[4][1], coorPoints[4][2]}
  arc5 = {coorPoints[2][1], coorPoints[2][2], coorPoints[3][1], coorPoints[3][2]}
  
  arc6 = {coorPoints[3][1], coorPoints[3][2], coorPoints[5][1], coorPoints[5][2]}
  arc7 = {coorPoints[4][1], coorPoints[4][2], coorPoints[5][1], coorPoints[5][2]}
  arc8 = {coorPoints[4][1], coorPoints[4][2], coorPoints[6][1], coorPoints[6][2]}
  
  arc9 = {coorPoints[5][1], coorPoints[5][2], coorPoints[7][1], coorPoints[7][2]}
  arc10 = {coorPoints[5][1], coorPoints[5][2], coorPoints[8][1], coorPoints[8][2]}
  arc11 = {coorPoints[6][1], coorPoints[6][2], coorPoints[8][1], coorPoints[8][2]}
  
  arc12 = {endPoint.x, endPoint.y, coorPoints[7][1], coorPoints[7][2]}
  arc13 = {endPoint.x, endPoint.y, coorPoints[8][1], coorPoints[8][2]}

  table.insert(listArcs, arc1)
  table.insert(listArcs, arc2)
  table.insert(listArcs, arc3)
  table.insert(listArcs, arc4)
  table.insert(listArcs, arc5)
  table.insert(listArcs, arc6)
  table.insert(listArcs, arc7)
  table.insert(listArcs, arc8)
  table.insert(listArcs, arc9)
  table.insert(listArcs, arc10)
  table.insert(listArcs, arc11)
  table.insert(listArcs, arc12)
  table.insert(listArcs, arc13)
  
  arc1.phero = 0
  arc2.phero = 0
  arc3.phero = 0
  arc4.phero = 0
  arc5.phero = 0
  arc6.phero = 0
  arc7.phero = 0
  arc8.phero = 0
  arc9.phero = 0
  arc10.phero = 0
  arc11.phero = 0
  arc12.phero = 0
  arc13.phero = 0
  
 

  
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

end

function love.keypressed(key)
  if key == "space" or key == " " then --on regenere un donjon a chaque fois qu on appuie sur espace
    --randomPointsGen()
  end
end