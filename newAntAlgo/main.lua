math.randomseed(os.time()) --initialiser le random
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

require "listLoad"

local windowWidth = 1000
local windowHeight = 600

function randShot(min, max, number)
  local randArea = {}
  local result = {}
  local tempRand = 0
  for i = min, max do
    table.insert(randArea, i)
    i = i + 1
  end
  
  for k = 1, number do
    tempRand = math.random(1, #randArea - 1)
    table.insert(result, randArea[tempRand])
    table.remove(randArea, tempRand)
    tempRand = 0
    k = k + 1
  end
  
  return result
end

function love.load()
  
  love.window.setMode(windowWidth, windowHeight, {centered = false, x = 100, y = 100}) -- resize the window and place it
  love.graphics.setBackgroundColor(0, 102, 0) -- green map
  
  -- find the level line and column number
  levelAntHill.line = ((windowHeight - 150)/levelAntHill.lineGap) - 1
  levelAntHill.column = ((windowWidth)/levelAntHill.columnGap) - 1
  -- print(levelAntHill.line, levelAntHill.column)
  
  
  levelAntHill.listPoints[1] = {id = "startPoint", x = windowWidth/2, y = 50}
  
  local l, c
  local pointId = 2
  local pointX, pointY = 0, 0
  for l = 1, levelAntHill.line do
    pointX = 0
    for c = 1, levelAntHill.column do
      levelAntHill.listPoints[pointId] = {id = pointId, x = pointX + levelAntHill.columnGap, y = pointY + 150, isOn = false}
      pointId = pointId + 1
      pointX = pointX + levelAntHill.columnGap
    end
    pointY = pointY + levelAntHill.lineGap
  end
  
  levelAntHill.listPoints[pointId + 1] = {id = "endPoint", x = windowWidth/2, y = windowHeight - 50}
  
  
  local tempSelect = {}
  pointId = 2
  for l = 1, levelAntHill.line do
    tempSelect = {}
    tempSelect = randShot(1, levelAntHill.column, 3)
    for c = 1, levelAntHill.column do
      for s = 1, #tempSelect do
        if c == tempSelect[s] then
          levelAntHill.listPoints[pointId].isOn = true
        end
      end
      pointId = pointId + 1
    end
  end
  
  
end

function love.update(dt)

end

function love.draw()
  
  -- start point
  love.graphics.setColor({0, 128, 255})
  love.graphics.circle("fill", levelAntHill.listPoints[1].x, levelAntHill.listPoints[1].y, levelAntHill.circleRad, levelAntHill.circleSeg)
  
  -- map points
  love.graphics.setColor({255, 255, 255})
  local l, c
  local pointId = 2
  for l = 1, levelAntHill.line do
    for c = 1, levelAntHill.column do
      if levelAntHill.listPoints[pointId].isOn == true then
        love.graphics.circle("fill", levelAntHill.listPoints[pointId].x, levelAntHill.listPoints[pointId].y, levelAntHill.circleRad, levelAntHill.circleSeg)
      end
      pointId = pointId + 1
    end
  end
  
  -- end point
  love.graphics.setColor({255, 128, 0})
  love.graphics.circle("fill", levelAntHill.listPoints[pointId + 1].x, levelAntHill.listPoints[pointId + 1].y, levelAntHill.circleRad, levelAntHill.circleSeg)

end

function love.keypressed(key)
  
  print(key)
  
end