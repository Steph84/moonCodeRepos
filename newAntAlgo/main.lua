math.randomseed(os.time()) --initialiser le random
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

require "listLoad"

local windowWidth = 1000
local windowHeight = 600
local tempSelect = {}

-- function allowing to pick a number of value between min and max
function randNodes(min, max, number)
  
  local randArea = {}
  local result = {}
  local tempRand = 0
  
  -- total list to pick in
  for i = min, max do
    table.insert(randArea, i)
    i = i + 1
  end
  
  -- pick of the values
  for k = 1, number do
    tempRand = math.random(1, #randArea)
    table.insert(result, randArea[tempRand])
    table.remove(randArea, tempRand)
    tempRand = 0
    k = k + 1
  end
  
  return result
end

function randArcs()
  local arite = math.floor(levelAntHill.numPtsLine * 2/3)
  local listRandArcs = {}
  local a = 0
  for i = 1, arite do
    tempRandArcs = math.random(1, levelAntHill.numPtsLine)
    if tempRandArcs ~= a then
      table.insert(listRandArcs, tempRandArcs)
      a = tempRandArcs
    end
  end
  for j = 1, #listRandArcs do
    print(j, listRandArcs[j])
  end
  return listRandArcs
end

function love.load()
  
  love.window.setMode(windowWidth, windowHeight, {centered = false, x = 100, y = 100}) -- resize the window and place it
  love.graphics.setBackgroundColor(0, 102, 0) -- green map
  
  -- find the level line and column number
  levelAntHill.line = ((windowHeight - 150)/levelAntHill.lineGap) - 1
  levelAntHill.column = ((windowWidth)/levelAntHill.columnGap) - 1
  -- print(levelAntHill.line, levelAntHill.column)
  
  -- start point
  levelAntHill.listPoints[1] = {id = "startPoint", x = windowWidth/2, y = 50}
  
  -- initialization of the map with all the possible points
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
  
  -- end point
  levelAntHill.listPoints[pointId + 1] = {id = "endPoint", x = windowWidth/2, y = windowHeight - 50}
  
  -- random selection of nodes into the map
  local tempSelect = {}
  pointId = 2 -- begin after the start point
  for l = 1, levelAntHill.line do
    tempSelect = randNodes(1, levelAntHill.column, levelAntHill.numPtsLine)
    for c = 1, levelAntHill.column do
      for s = 1, #tempSelect do
        if c == tempSelect[s] then
          levelAntHill.listPoints[pointId].isOn = true -- the node exists
          table.insert(levelAntHill.listNodes, levelAntHill.listPoints[pointId]) -- creation of the nodes list
        end
      end
      pointId = pointId + 1 -- continue with the following node
    end
  end
  
  -- creation of arcs
  local pointsToGo = levelAntHill.numPtsLine - 1
  for arcId = 1, levelAntHill.numPtsLine do
    
    -- creation of the arcs from the start point
    levelAntHill.listArcs[arcId] = {id = arcId, startX = levelAntHill.listPoints[1].x, startY = levelAntHill.listPoints[1].y, endX = levelAntHill.listNodes[arcId].x, endY = levelAntHill.listNodes[arcId].y, phero = 0} -- creation of the arc
    
    -- creation of the following arcs 2nd line
    local tempRandBis = 0
    -- tempRandBis = math.random(1, levelAntHill.numPtsLine)
    -- tempRandList = randArcs()
    levelAntHill.listArcs[arcId + levelAntHill.numPtsLine] = {id = arcId + levelAntHill.numPtsLine, startX = levelAntHill.listNodes[arcId].x, startY = levelAntHill.listNodes[arcId].y, endX = levelAntHill.listNodes[arcId + levelAntHill.numPtsLine].x, endY = levelAntHill.listNodes[arcId + levelAntHill.numPtsLine].y, phero = 0} -- creation of the arc
    pointsToGo = pointsToGo - 1
  end
  
  
  
  --[[
  local lastPointId = pointId
  
  -- creation second line of arcs
  local numFollowArcs = numFirstArcs
  local pointsToGo = levelAntHill.numPtsLine - 1
  for pointId = 2, 2 + pointsToGo do
    local tempRandBis = 0
    tempRandBis = math.random(1, levelAntHill.numPtsLine)
    levelAntHill.listArcs[numFollowArcs] = {id = numFollowArcs, startX = levelAntHill.listPoints[pointId].x, startY = levelAntHill.listPoints[pointId].y, endX = levelAntHill.listPoints[pointId + pointsToGo + tempRandBis].x, endY = levelAntHill.listPoints[pointId + pointsToGo + tempRandBis].y, phero = 0} -- creation of the arc
    pointsToGo = pointsToGo - 1
    numFollowArcs = numFollowArcs + 1
  end
  ]]
  
  
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

  -- arcs
  love.graphics.setColor({255, 255, 255})
  for arcNum = 1, #levelAntHill.listArcs do
    love.graphics.line(levelAntHill.listArcs[arcNum].startX, levelAntHill.listArcs[arcNum].startY, levelAntHill.listArcs[arcNum].endX, levelAntHill.listArcs[arcNum].endY)
    
  end


end

function love.keypressed(key)
  
  print(key)
  
end