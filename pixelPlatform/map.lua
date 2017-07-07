local Map = {}
Map.tileTextures = {}
Map.grid = {}

Map.TILE_SIZE = 32
local speedAdjust = 45
local windowWidth, windowHeight
Map.mov = false
local listPits = {}
local listHills = {}
local coefMap = 6

--Map = require("Map")
--Map.myScrolling = require("mapScrolling")
local myEltGen = require("mapEltGen")

function Map.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  -- load the tile sheet
  Map.TileSheet = love.graphics.newImage("pictures/platFormTileSet02_32x32.png")
  local nbColumns = Map.TileSheet:getWidth() / Map.TILE_SIZE
  local nbLines = Map.TileSheet:getHeight() / Map.TILE_SIZE
  
  -- extract all the tiles in the tile sheet
  local l, c
  local id = 1
  Map.tileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    Map.tileTextures[id] = love.graphics.newQuad(
                              (c-1)*Map.TILE_SIZE,
                              (l-1)*Map.TILE_SIZE,
                              Map.TILE_SIZE,
                              Map.TILE_SIZE,
                              Map.TileSheet:getDimensions()
                              )
    id = id + 1
    end
  end
  
  Map.tileSetBatch = love.graphics.newSpriteBatch(Map.TileSheet, windowWidth * windowHeight)
  
  -- initialize the size of the map
  Map.size = { w = (coefMap * windowWidth)/Map.TILE_SIZE, h = (windowHeight - (2 * Map.TILE_SIZE))/Map.TILE_SIZE,
                       pixW = coefMap * windowWidth, pixH = windowHeight - (2 * Map.TILE_SIZE)}

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
end

function Map.Update(dt, pHero)
  -- manage the map movement
  Map.tileSetBatch:clear()
  if Map.mov == true then
    local lin, col
    for lin = 1, Map.size.h do
      for col = 1, Map.size.w do
        local g = Map.grid[lin][col]
        g.x = g.x - pHero.sign * pHero.speed.walk * dt * speedAdjust
        Map.tileSetBatch:add(Map.tileTextures[g.idText], g.x*Map.TILE_SIZE, g.y*Map.TILE_SIZE)
      end
    end
  end
  Map.tileSetBatch:flush()
end

function Map.Draw()
  love.graphics.draw(Map.tileSetBatch)
  
  --[[
  local lin, col
  for lin = 1, Map.size.h do
    for col = 1, Map.size.w do
      local g = Map.grid[lin][col]
      love.graphics.draw(Map.TileSheet, Map.tileTextures[g.idText], g.x, g.y)
    end
  end
  --]]
  love.graphics.printf("maxLin : "..Map.size.h.." / maxCol : "..Map.size.w, 10, 30, windowWidth, "left")
  love.graphics.printf("maxHeight : "..Map.size.pixH.." / maxWidth : "..Map.size.pixW, 10, 50, windowWidth, "left")
end

return Map