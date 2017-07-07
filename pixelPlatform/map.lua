local Map = {}

Map.grid = {}
Map.TILE_SIZE = 32
Map.mov = false

local windowWidth, windowHeight
local TileSet = {}
local TileTextures = {}
local TileSetBatch = {}
local listPits = {}
local listHills = {}
local speedAdjust = 45
local coefMap = 6
local tilesDisplayWidth, tilesDisplayHeight
local mapX, mapY = 1, 1

local myEltGen = require("mapEltGen")

function Map.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  -- load the tile sheet
  TileSet = love.graphics.newImage("pictures/platFormTileSet02_32x32.png")
  local nbColumns = TileSet:getWidth() / Map.TILE_SIZE
  local nbLines = TileSet:getHeight() / Map.TILE_SIZE
  
  -- extract all the tiles in the tile sheet
  local l, c
  local id = 1
  TileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    TileTextures[id] = love.graphics.newQuad(
                              (c-1)*Map.TILE_SIZE,
                              (l-1)*Map.TILE_SIZE,
                              Map.TILE_SIZE,
                              Map.TILE_SIZE,
                              TileSet:getDimensions()
                              )
    id = id + 1
    end
  end
  
  -- initialize the size of the map
  Map.size = { w = (coefMap * windowWidth)/Map.TILE_SIZE, h = (windowHeight - (2 * Map.TILE_SIZE))/Map.TILE_SIZE,
               pixW = coefMap * windowWidth, pixH = windowHeight - (2 * Map.TILE_SIZE)}
  
  tilesDisplayWidth = windowWidth / Map.TILE_SIZE
  tilesDisplayHeight = (windowHeight - (2 * Map.TILE_SIZE)) / Map.TILE_SIZE

  TileSetBatch = love.graphics.newSpriteBatch(TileSet, tilesDisplayWidth * tilesDisplayHeight)

  -- building the map
  local lin, col
  local idGrid = 0
  for lin = Map.size.h, 1, -1 do
    Map.grid[lin] = {}
    for col = 1, Map.size.w do
      idGrid = idGrid + 1
      -- initialize the map
      Map.grid[lin][col] = {id = idGrid,
                            x = (col-1)*Map.TILE_SIZE, y = (lin-1)*Map.TILE_SIZE,
                            w = Map.TILE_SIZE, h = Map.TILE_SIZE, 
                            idText = 28, texture = "void"}
      
      if lin == Map.size.h then
        Map.grid[lin][col].texture = "ground"
        Map.grid[lin][col].idText = math.random(1, 3)
      elseif lin == (Map.size.h - 1) then
        Map.grid[lin][col].texture = "ground"
        Map.grid[lin][col].idText = math.random(4, 6)
      end
    end
  end
  
  -- calculate th element number to fill the map
  -- except first screen and last and a half screen
  local nbElts = coefMap + (coefMap - 4)
  local nbPits = nbElts/2
  local nbHills = nbElts/2
  
  local nP
  for nP = 1, nbPits do
    local buildingPit = myEltGen.pit(Map.size.w * (nP * 2)/(coefMap*2) + 1, Map.size.h)
    table.insert(listPits, buildingPit)
  end
  
  local j
  for j = 1, #listPits do
    local p = listPits[j]
    Map.grid[p.linY][p.colX - 1].idText = math.random(19, 21)
    Map.grid[p.linY + 1][p.colX - 1].idText = math.random(10, 12)
    local alongH, alongW
    for alongH = 1, p.h do
      for alongW = 1, p.w do
        Map.grid[p.linY - 1 + alongH][p.colX - 1 + alongW].texture = "void"
        Map.grid[p.linY - 1 + alongH][p.colX - 1 + alongW].idText = 28
      end
    end
    Map.grid[p.linY][p.colX + p.w].idText = math.random(16, 18)
    Map.grid[p.linY + 1][p.colX + p.w].idText = math.random(7, 9)
  end
  
  
  local nH
  for nH = 1, nbPits do
    local buildingHill = myEltGen.hill(Map.size.w * (nH * 2 + 1)/(coefMap*2) + 1, Map.size.h)
    table.insert(listHills, buildingHill)
  end
  
  local k
  for k = 1, #listHills do
    local h = listHills[k]
    Map.grid[h.linY][h.colX].texture = "ground"
    Map.grid[h.linY][h.colX].idText = math.random(16, 18)
    local alongH, alongW
    for alongH = 1, h.h + 1 do
      for alongW = 1, h.w do
        Map.grid[h.linY + alongH][h.colX - 1 + alongW].texture = "ground"
        Map.grid[h.linY + alongH][h.colX - 1 + alongW].idText = math.random(1, 3)
        if alongW ~= h.w then
          Map.grid[h.linY][h.colX + alongW].texture = "ground"
          Map.grid[h.linY][h.colX + alongW].idText = math.random(4, 6)
        end
        if alongH ~= h.h + 1 then
          Map.grid[h.linY + alongH][h.colX].texture = "ground"
          Map.grid[h.linY + alongH][h.colX].idText = math.random(7, 9)
          Map.grid[h.linY + alongH][h.colX + h.w - 1].texture = "ground"
          Map.grid[h.linY + alongH][h.colX + h.w - 1].idText = math.random(10, 12)
        end
      end
    end
    Map.grid[h.linY][h.colX + h.w - 1].texture = "ground"
    Map.grid[h.linY][h.colX + h.w - 1].idText = math.random(19, 21)
  end
  
  TileSetBatch:clear()
  for disLin = 0, tilesDisplayHeight - 1 do
    for disCol = 0, tilesDisplayWidth - 1 do
      TileSetBatch:add(TileTextures[Map.grid[disLin + 1][disCol + 1].idText],
        disCol*Map.TILE_SIZE, disLin*Map.TILE_SIZE)
    end
  end
  TileSetBatch:flush()
  
end


local function updateTilesetBatch()
  TileSetBatch:clear()
  for disLin = 0, tilesDisplayHeight - 3 do
    if disLin == 16 then
    print("for Lin : ", disLin)
    end
    for disCol = 0, tilesDisplayWidth - 3 do
      print("for Col : ", disCol)
      TileSetBatch:add(TileTextures[Map.grid[disLin + math.floor(mapX)][disCol + math.floor(mapY)].idText],
        disCol*Map.TILE_SIZE, disLin*Map.TILE_SIZE)
    end
  end
  TileSetBatch:flush()
end

local function moveMap(dx, dy)
  local oldMapX = mapX
  local oldMapY = mapY
  mapX = math.max(math.min(mapX + dx, Map.size.w - tilesDisplayWidth), 1)
  mapY = math.max(math.min(mapY + dy, Map.size.h - tilesDisplayHeight), 1)
  -- only update if we actually moved
  if math.floor(mapX) ~= math.floor(oldMapX) or math.floor(mapY) ~= math.floor(oldMapY) then
    updateTilesetBatch()
  end
end

function Map.Update(dt, pHero)
  -- manage the map movement
  if Map.mov == true then
    local lin, col
    for lin = 1, Map.size.h do
      for col = 1, Map.size.w do
        local g = Map.grid[lin][col]
        g.x = g.x - pHero.sign * pHero.speed.walk * dt * speedAdjust
        moveMap((pHero.sign * 0.2 * dt), 0)
      end
    end
  end
end

function Map.Draw()
  love.graphics.draw(TileSetBatch)
  
  --[[
  local lin, col
  for lin = 1, Map.size.h do
    for col = 1, Map.size.w do
      local g = Map.grid[lin][col]
      love.graphics.draw(TileSet, TileTextures[g.idText], g.x, g.y)
    end
  end
  --]]
  love.graphics.printf("maxLin : "..Map.size.h.." / maxCol : "..Map.size.w, 10, 30, windowWidth, "left")
  love.graphics.printf("maxHeight : "..Map.size.pixH.." / maxWidth : "..Map.size.pixW, 10, 50, windowWidth, "left")
end

return Map