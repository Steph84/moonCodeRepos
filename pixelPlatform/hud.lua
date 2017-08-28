local Hud = {}

local windowWidth, windowHeight, TILE_SIZE

-- hud is divided in 3 parts
local heroPart = {}
local mapPart = {}
local mobPart = {}

local myHero = require("hero")
local myMap = require("map")

local countNotHidden, percentMap = 0, 0
local countPlatForm, percentPlatForm = 0, 0

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

function Hud.Update(dt)
  if myHero.mov ~= "stand" then
    countNotHidden, countPlatForm = 0, 0
    local lin, col
    for lin = 1, myMap.size.h do
      for col = 1, myMap.size.w do
        local g = myMap.grid[lin][col]
        if g.hidden == false then
          countNotHidden = countNotHidden + 1
          if (g.idText >= 4 and g.idText <= 6)
              or (g.idText >= 16 and g.idText <= 21)
              or (g.idText >= 28 and g.idText <= 36) then
                countPlatForm = countPlatForm + 1
          end
        end
      end
    end
  end
  percentMap = math.floor((countNotHidden/(myMap.size.h * myMap.size.w)) * 10000)/100
  percentPlatForm = math.floor((countPlatForm/myMap.size.platFormNumber) * 10000)/100
end

function Hud.Draw()
  
  love.graphics.setFont(hudFont)
  -- draw the frames
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", heroPart.x, heroPart.y, heroPart.w, heroPart.h, 10, 10, 5)
  love.graphics.rectangle("line", mapPart.x, mapPart.y, mapPart.w, mapPart.h, 10, 10, 5)
  love.graphics.rectangle("line", mobPart.x, mobPart.y, mobPart.w, mobPart.h, 10, 10, 5)
  
  -- central part
  love.graphics.printf("Map", mapPart.x + mapPart.w * (1/40), mapPart.y + mapPart.h * (2/10), mapPart.w, "left")
  love.graphics.printf("Exploration %", mapPart.x + mapPart.w * (1/40), mapPart.y + mapPart.h * (7/10), mapPart.w, "left")
  love.graphics.printf("total map", mapPart.x + mapPart.w * (10/40), mapPart.y + mapPart.h * (7/10), mapPart.w, "left")
  love.graphics.printf("platform", mapPart.x + mapPart.w * (25/40), mapPart.y + mapPart.h * (7/10), mapPart.w, "left")
  
  -- frame of the map bar
  love.graphics.rectangle("line",
                          mapPart.x + mapPart.w * (4/40), mapPart.y + mapPart.h * (2/10),
                          mapPart.w * (34/40), mapPart.h * (5/20),
                          5, 5, 5)
  -- dynamic bar for the power
  love.graphics.rectangle("fill",
                          mapPart.x + mapPart.w * (5/40), mapPart.y + mapPart.h * (3/10),
                          (myHero.colFeet / myMap.size.w) * (mapPart.w * (32/40)), mapPart.h * (1/20))
  -- exploration total map
  
  love.graphics.printf(percentMap.." %", mapPart.x + mapPart.w * (15/40), mapPart.y + mapPart.h * (7/10), mapPart.w, "left")
  love.graphics.printf(percentPlatForm.." %", mapPart.x + mapPart.w * (30/40), mapPart.y + mapPart.h * (7/10), mapPart.w, "left")
  
  
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
    love.graphics.rectangle("fill", heroPart.x + 60, heroPart.y + heroPart.h * (3/14), myHero.healthBar * (heroPart.w - 80), 5)
    love.graphics.setColor(0, 64, 128)
    love.graphics.rectangle("fill", heroPart.x + 60, heroPart.y + heroPart.h * (11/14), myHero.xpBar * (heroPart.w - 80), 5)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", heroPart.x + 59, heroPart.y + heroPart.h * (3/14) - 1/2, (heroPart.w - 78), 7)
    love.graphics.rectangle("line", heroPart.x + 59, heroPart.y + heroPart.h * (11/14) - 1/2, (heroPart.w - 78), 7)
    love.graphics.printf(myHero.level, heroPart.w * (2/10), heroPart.y + heroPart.h * (3/7), 16, "right")
    love.graphics.printf(myHero.ptsAttack, heroPart.w * (5/10), heroPart.y + heroPart.h * (3/7), 16, "right")
    love.graphics.printf(myHero.ptsDefense, heroPart.w * (8/10), heroPart.y + heroPart.h * (3/7), 16, "right")
  end
  
  
end

return Hud