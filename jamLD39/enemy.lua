local Enemy = {}

local TileSet, TileTextures = {}, {}
local windowWidth, windowHeight, TILE_SIZE
local ENEMY_SIZE = 30
local currentLevel = 0
Enemy.listEnemies = {}

local myMap = require("map")

function CreateEnemy(pId)
  local item = {}
  
  item.id = pId
  item.col = math.random(1, myMap.size.w)
  item.lin = math.random(1, myMap.size.h)
  item.x = (item.col-1) * TILE_SIZE
  item.y = (item.lin-1) * TILE_SIZE
  item.isEnabled = true
  item.timeElapsed = 0
  item.speed = 1
  item.attack = false
  
  table.insert(Enemy.listEnemies, item)
end

function Enemy.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  -- load the tile sheet
  TileSet = love.graphics.newImage("pictures/enemiesLD39.png")
  local nbColumns = TileSet:getWidth() / ENEMY_SIZE
  local nbLines = TileSet:getHeight() / ENEMY_SIZE
  
  -- extract all the tiles in the tile sheet
  local l, c
  local id = 1
  TileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    TileTextures[id] = love.graphics.newQuad(
                                            (c-1)*ENEMY_SIZE,
                                            (l-1)*ENEMY_SIZE,
                                            ENEMY_SIZE,
                                            ENEMY_SIZE,
                                            TileSet:getDimensions()
                                            )
    id = id + 1
    end
  end
  
  -- generate list enemies
  local nbEnemies = math.floor(myMap.size.w/10) - 1
  local e
  for e = 1, nbEnemies do
    CreateEnemy(e)
  end
  
  currentLevel = 1
  
end

function Enemy.Update(dt, pLevel)
  local reInit = false
  if pLevel ~= currentLevel then
    reInit = true
    currentLevel = pLevel
  end
  
  local i
  for i = 1, #Enemy.listEnemies do
    local e = Enemy.listEnemies[i]
    
    if reInit == true then
      e.isEnabled = true
      e.col = math.random(1, myMap.size.w)
      e.lin = math.random(1, myMap.size.h)
      e.x = (e.col-1) * TILE_SIZE
      e.y = (e.lin-1) * TILE_SIZE
    end
    
    if e.isEnabled == true then
      
      e.timeElapsed = e.timeElapsed + dt
      
      if e.attack == true then e.speed = 0.5
      else e.speed = 1 end
      
      if e.timeElapsed > e.speed then
        local oldCol = e.col
        local oldLin = e.lin
        
        if e.attack == false then
          e.col = e.col + math.random(-1, 1)
          e.lin = e.lin + math.random(-1, 1)
        end
        
        if e.attack == true then
          e.col = e.col + math.random(-1, 1)
          e.lin = e.lin + math.random(-1, 1)
        end
        
        if e.col < 1 or e.col > myMap.size.w then e.col = oldCol end
        if e.lin < 1 or e.lin > myMap.size.h then e.lin = oldLin end
        
        e.x = (e.col-1) * TILE_SIZE
        e.y = (e.lin-1) * TILE_SIZE
        
        e.timeElapsed = 0
      end
      
    end
  end    
  -- attack kamikaze
  -- loss of power
end

function Enemy.Draw(pId)
  local i
  for i = 1, #Enemy.listEnemies do
    local e = Enemy.listEnemies[i]
    if e.isEnabled == true then
    --if myMap.listGrids[pId][e.lin][e.col].isHidden == false and e.isEnabled == true then
      love.graphics.draw(TileSet, TileTextures[pId], e.x + 1, e.y + 1)
    end
  end
end

return Enemy