local Hud = {}

local windowWidth, windowHeight, TILE_SIZE

-- hud is divided in 3 parts
local heroPart = {}
local mapPart = {}
local mobPart = {}

local myHero = require("hero")

local hudFont = love.graphics.newFont("fonts/arial.ttf", 12)

function Hud.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  -- initialize the coordinates and the size of each hud parts
  heroPart.x = 0
  heroPart.y = windowHeight - 2 * TILE_SIZE
  heroPart.w = windowWidth/4
  heroPart.h = 2 * TILE_SIZE
  
  mapPart.x = windowWidth/4
  mapPart.y = windowHeight - 2 * TILE_SIZE
  mapPart.w = windowWidth/2
  mapPart.h = 2 * TILE_SIZE
  
  mobPart.x = windowWidth * 3/4
  mobPart.y = windowHeight - 2 * TILE_SIZE
  mobPart.w = windowWidth/4
  mobPart.h = 2 * TILE_SIZE
  
end

function Hud.Update(dt, pMachina, pMap)
  
end

function Hud.Draw(pLevel)
  
  love.graphics.setFont(hudFont)
  -- draw the frames
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", heroPart.x, heroPart.y, heroPart.w, heroPart.h, 10, 10, 5)
  love.graphics.rectangle("line", mapPart.x, mapPart.y, mapPart.w, mapPart.h, 10, 10, 5)
  love.graphics.rectangle("line", mobPart.x, mobPart.y, mobPart.w, mobPart.h, 10, 10, 5)
  
  -- central part
  love.graphics.printf("Map", mapPart.x, mapPart.y + 4, mapPart.w, "center")
  
  -- frame of the power bar
  love.graphics.rectangle("line", mapPart.x + 16, mapPart.y + 24, mapPart.w - 32, mapPart.h - 32, 10, 10, 5)
  -- dynamic bar for the power
  --love.graphics.rectangle("fill", powerPart.x + 22, powerPart.y + 30, myMachina.power * tempRatio, powerPart.h - 44)
  
  
  -- right part
  love.graphics.printf("Mobs", mobPart.x, mobPart.y + 4, mobPart.w, "center")
  
  
  -- left part
  love.graphics.printf("Health", heroPart.w * (1/40), heroPart.y + heroPart.h * (1/7), 64, "left")
  love.graphics.printf("LV", heroPart.w * (1/10), heroPart.y + heroPart.h * (3/7), 32, "left")
  love.graphics.printf("Att.", heroPart.w * (4/10), heroPart.y + heroPart.h * (3/7), 32, "left")
  love.graphics.printf("Def.", heroPart.w * (7/10), heroPart.y + heroPart.h * (3/7), 32, "left")
  love.graphics.printf("Exp.", heroPart.w * (1/40), heroPart.y + heroPart.h * (5/7), 64, "left")
  -- manage color of the health bar
  if myHero.healthBar >= 0.6 then love.graphics.setColor(0, 128, 0)
  elseif myHero.healthBar < 0.6 and myHero.healthBar >= 0.3 then love.graphics.setColor(255, 192, 0)
  elseif myHero.healthBar < 0.3 then love.graphics.setColor(255, 0, 0) end
  
  if myHero.isDead == false then
    love.graphics.rectangle("fill", heroPart.x + 60, heroPart.y + heroPart.h * (1/7), myHero.healthBar * (heroPart.w - 80), 5)
    love.graphics.setColor(0, 64, 128)
    love.graphics.rectangle("fill", heroPart.x + 60, heroPart.y + heroPart.h * (5/7), myHero.xpBar * (heroPart.w - 80), 5)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", heroPart.x + 59, heroPart.y + heroPart.h * (1/7) - 1, (heroPart.w - 78), 7)
    love.graphics.rectangle("line", heroPart.x + 59, heroPart.y + heroPart.h * (5/7) - 1, (heroPart.w - 78), 7)
    love.graphics.printf(myHero.level, heroPart.w * (2/10), heroPart.y + heroPart.h * (3/7), 16, "right")
    love.graphics.printf(myHero.ptsAttack, heroPart.w * (5/10), heroPart.y + heroPart.h * (3/7), 16, "right")
    love.graphics.printf(myHero.ptsDefense, heroPart.w * (8/10), heroPart.y + heroPart.h * (3/7), 16, "right")
  end
  
  
end

return Hud