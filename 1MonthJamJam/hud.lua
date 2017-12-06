local Hud = {}

local windowWidth, windowHeight, TILE_SIZE

-- hud is divided in 2 parts
local firstPart = {}
local secondPart = {}


local hudFont
local myMap = require("map")

local titleHeight


function Hud.Load(pWindowWidth, pWindowHeight, pTileSize, pFontSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  hudFont = love.graphics.newFont("fonts/arial.ttf", (pFontSize/2) * 0.85)

  -- initialize the coordinates and the size of each hud parts
  firstPart.name = "First"
  firstPart.x = 0
  firstPart.y = windowHeight - TILE_SIZE
  firstPart.w = windowWidth - (TILE_SIZE/2) * 8
  firstPart.h = TILE_SIZE
  
  secondPart.name = "Second"
  secondPart.x = windowWidth - (TILE_SIZE/2) * 8
  secondPart.y = windowHeight - TILE_SIZE
  secondPart.w = (TILE_SIZE/2) * 8
  secondPart.h = TILE_SIZE
  
  titleHeight = math.max(hudFont:getHeight(firstPart.name), hudFont:getHeight(secondPart.name))
  
end

function Hud.Update(dt)
  
end

function Hud.Draw(pLevel)
  
  love.graphics.setFont(hudFont)
  -- draw the frames
  love.graphics.rectangle("line", firstPart.x, firstPart.y, firstPart.w, firstPart.h, 10, 10, 5)
  love.graphics.rectangle("line", secondPart.x, secondPart.y, secondPart.w, secondPart.h, 10, 10, 5)
  
  -- buy element part
  love.graphics.printf(secondPart.name, secondPart.x, secondPart.y + 4, secondPart.w, "center")
  
  -- statistic part
  love.graphics.printf(firstPart.name, firstPart.x, firstPart.y + 4, firstPart.w, "center")
  
end

return Hud