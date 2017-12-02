local Hud = {}

local windowWidth, windowHeight, TILE_SIZE

-- hud is divided in 2 parts
local statPart = {}
local buyPart = {}

local listButtons = {}
local buttonName = {"rest", "meal", "game", "sport"}

local hudFont
local myMap = require("map")

local titleHeight


function Hud.Load(pWindowWidth, pWindowHeight, pTileSize, pFontSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  hudFont = love.graphics.newFont("fonts/arial.ttf", (pFontSize/2) * 0.85)

  -- initialize the coordinates and the size of each hud parts
  statPart.name = "Statistics"
  statPart.x = 0
  statPart.y = windowHeight - TILE_SIZE
  statPart.w = windowWidth - (TILE_SIZE/2) * 8
  statPart.h = TILE_SIZE
  
  buyPart.name = "Buy some element"
  buyPart.x = windowWidth - (TILE_SIZE/2) * 8
  buyPart.y = windowHeight - TILE_SIZE
  buyPart.w = (TILE_SIZE/2) * 8
  buyPart.h = TILE_SIZE
  
  titleHeight = math.max(hudFont:getHeight(statPart.name), hudFont:getHeight(buyPart.name))
  
end

function Hud.Update(dt, pMachina, pMap)
  
end

function Hud.Draw(pLevel)
  
  love.graphics.setFont(hudFont)
  -- draw the frames
  love.graphics.rectangle("line", statPart.x, statPart.y, statPart.w, statPart.h, 10, 10, 5)
  love.graphics.rectangle("line", buyPart.x, buyPart.y, buyPart.w, buyPart.h, 10, 10, 5)
  
  -- buy element part
  love.graphics.printf(buyPart.name, buyPart.x, buyPart.y + 4, buyPart.w, "center")
  
  -- draw white squares
  for pos = 1, 13, 4 do
    love.graphics.rectangle("fill", buyPart.x + buyPart.w * pos/16, buyPart.y + 4 + titleHeight + 4, 32, 32)
  end
  
  -- draw the text into the white squares
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("rest", buyPart.x + buyPart.w * 1/16, buyPart.y + 4 + titleHeight + 4 + 8, 32, "center")
  love.graphics.printf("meal", buyPart.x + buyPart.w * 5/16, buyPart.y + 4 + titleHeight + 4 + 8, 32, "center")
  love.graphics.printf("game", buyPart.x + buyPart.w * 9/16, buyPart.y + 4 + titleHeight + 4 + 8, 32, "center")
  love.graphics.printf("sport", buyPart.x + buyPart.w * 13/16, buyPart.y + 4 + titleHeight + 4 + 8, 32, "center")
  love.graphics.setColor(255, 255, 255)
  
  -- statistic part
  love.graphics.printf(statPart.name, statPart.x, statPart.y + 4, statPart.w, "center")
  
end

return Hud