local Hud = {}

local windowWidth, windowHeight, TILE_SIZE

-- hud is divided in 3 parts
local instructionPart = {}
local powerPart = {}
local statPart = {}

local myMap = require("map")
local myMachina = require("machina")

local hudFont = love.graphics.newFont("fonts/arial.ttf", 16)

function Hud.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  -- initialize the coordinates and the size of each hud parts
  instructionPart.x = 0
  instructionPart.y = windowHeight - 2 * TILE_SIZE
  instructionPart.w = windowWidth/4
  instructionPart.h = 2 * TILE_SIZE
  
  powerPart.x = windowWidth/4
  powerPart.y = windowHeight - 2 * TILE_SIZE
  powerPart.w = windowWidth/2
  powerPart.h = 2 * TILE_SIZE
  
  statPart.x = windowWidth * 3/4
  statPart.y = windowHeight - 2 * TILE_SIZE
  statPart.w = windowWidth/4
  statPart.h = 2 * TILE_SIZE
  
end

function Hud.Update(dt, pMachina, pMap)
  
  -- determine if particular instruction is shown
  if pMachina.action.drill == true then
    instructionPart.drill = "show"
  else instructionPart.drill = "hide"
  end
  if pMachina.action.teleport == true then
    instructionPart.teleport = "show"
  else instructionPart.teleport = "hide"
  end
  if pMachina.action.extract == true then
    instructionPart.extract = "show"
  else instructionPart.extract = "hide"
  end
  
  
end

function Hud.Draw(pLevel)
  
  love.graphics.setFont(hudFont)
  -- draw the frames
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", instructionPart.x, instructionPart.y, instructionPart.w, instructionPart.h, 10, 10, 5)
  love.graphics.rectangle("line", powerPart.x, powerPart.y, powerPart.w, powerPart.h, 10, 10, 5)
  love.graphics.rectangle("line", statPart.x, statPart.y, statPart.w, statPart.h, 10, 10, 5)
  
  -- power part
  love.graphics.printf("Power", powerPart.x, powerPart.y + 4, powerPart.w, "center") -- title
  local tempRatio = (powerPart.w - 44)/(myMap.size.w * 15) -- bar width/max power
  -- frame of the power bar
  love.graphics.rectangle("line", powerPart.x + 16, powerPart.y + 24, powerPart.w - 32, powerPart.h - 32, 10, 10, 5)
  -- dynamic bar for the power
  love.graphics.rectangle("fill", powerPart.x + 22, powerPart.y + 30, myMachina.power * tempRatio, powerPart.h - 44)
  
  -- determine the coordinates of threshold
  local drillLine = {x = (powerPart.x + 22) + myMachina.costDrill * tempRatio, y = powerPart.y + 30,
                     w = 2, h = powerPart.h - 44}
  local teleportLine = {x = (powerPart.x + 22) + myMachina.costTeleport * tempRatio, y = powerPart.y + 30,
                        w = 2, h = powerPart.h - 44}
  local extractLine = {x = (powerPart.x + 22) + myMachina.costExtract * tempRatio, y = powerPart.y + 30,
                       w = 2, h = powerPart.h - 44}
  
  -- show the threshold directly on the power bar
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle("fill", drillLine.x, drillLine.y, drillLine.w, drillLine.h)
  love.graphics.print("drill", drillLine.x - 16, drillLine.y - 24)
  love.graphics.rectangle("fill", teleportLine.x, teleportLine.y, teleportLine.w, teleportLine.h)
  love.graphics.print("teleport", teleportLine.x - 16, teleportLine.y - 24)
  love.graphics.rectangle("fill", extractLine.x, extractLine.y, extractLine.w, extractLine.h)
  love.graphics.print("extract", extractLine.x - 16, extractLine.y - 24)
  
  love.graphics.setColor(255, 255, 255)
  
  -- statitic part
  love.graphics.printf("Statistics", statPart.x, statPart.y + 4, statPart.w, "center")
  
  -- oil tiles number existing in this level
  love.graphics.printf("Oil tiles : "..myMap.countOil[pLevel],
                       statPart.x + 16, statPart.y + 24,
                       statPart.w/2, "left")

  -- percentage of area explored in this level
  local tempArea = math.floor((myMap.fogOutCount[pLevel]/(myMap.size.w * myMap.size.h)) * 1000)/10
  love.graphics.printf("Map explored : "..tempArea.." %",
                       statPart.x + 16, statPart.y + 24 + 16,
                       statPart.w/2, "left")
  
  -- instruction part
  love.graphics.printf("Instructions", instructionPart.x, instructionPart.y + 4, instructionPart.w, "center")
  
  love.graphics.printf("Arrow keys to move",
                       instructionPart.x + 16, instructionPart.y + 24,
                       instructionPart.w/2, "left")
  
  if instructionPart.drill == "show" then
    love.graphics.printf("d key to drill",
                         instructionPart.x + 16, instructionPart.y + 24 + 16,
                         instructionPart.w/2, "left")
  end
  
  if instructionPart.teleport == "show" then
  love.graphics.printf("t key to teleport",
                       instructionPart.x + 16 + instructionPart.w/2, instructionPart.y + 24,
                       instructionPart.w/2, "left")
  end
  
  if instructionPart.extract == "show" then
  love.graphics.printf("e key to extract",
                       instructionPart.x + 16 + instructionPart.w/2, instructionPart.y + 24 + 16,
                       instructionPart.w/2, "left")
  end
end

return Hud