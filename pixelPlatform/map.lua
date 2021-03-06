local Map = {}

Map.grid = {}
Map.mov = false

local windowWidth, windowHeight, TILE_SIZE
local TileSet = {}
local TileTextures = {}
local listPits = {}
local listHills = {}
local listPlatForms = {}
local coefMap

local myEltGen = require("mapEltGen")
local myParallax = require("parallaxAnimation")
local myColor = require("colorBlock")

function Map.Load(pWindowWidth, pWindowHeight, pTileSize, pCoefMap)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  coefMap = pCoefMap
  
  -- initialize the size of the map
  Map.size = { w = (coefMap * windowWidth)/TILE_SIZE, h = (windowHeight - (2 * TILE_SIZE))/TILE_SIZE,
               pixW = coefMap * windowWidth, pixH = windowHeight - (2 * TILE_SIZE),
               platFormNumber = 0}
  
  myParallax.Load(Map.size.pixW, Map.size.pixH, coefMap)
  
  -- load the tile sheet
  TileSet = love.graphics.newImage("pictures/platFormTileSet02_32x32.png")
  local nbColumns = TileSet:getWidth() / TILE_SIZE
  local nbLines = TileSet:getHeight() / TILE_SIZE
  
  -- extract all the tiles in the tile sheet
  local l, c
  local id = 1
  TileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    TileTextures[id] = love.graphics.newQuad(
                              (c-1)*TILE_SIZE,
                              (l-1)*TILE_SIZE,
                              TILE_SIZE,
                              TILE_SIZE,
                              TileSet:getDimensions()
                              )
    id = id + 1
    end
  end
  
  -- building the map
  local lin, col
  local idGrid = 0
  for lin = Map.size.h, 1, -1 do
    Map.grid[lin] = {}
    for col = 1, Map.size.w do
      idGrid = idGrid + 1
      -- initialize the map
      Map.grid[lin][col] = {id = idGrid,
                            x = (col-1)*TILE_SIZE, y = (lin-1)*TILE_SIZE,
                            w = TILE_SIZE, h = TILE_SIZE, 
                            idText = 37, texture = "void", scale = 1, hidden = true}
      
      if lin == Map.size.h then
        Map.grid[lin][col].texture = "ground"
        Map.grid[lin][col].idText = math.random(13, 15)
      elseif lin == (Map.size.h - 1) then
        Map.grid[lin][col].texture = "ground"
        Map.grid[lin][col].idText = math.random(4, 6)
      end
    end
  end
  
  -- calculate th element number to fill the map
  -- except first screen and last and a half screen
  local nbElts = coefMap + (coefMap - 2)
  local nbPits = nbElts/2
  local nbHills = nbElts/2
  local nbPlatForms = nbElts
  
  local nP
  for nP = 1, nbPits do
    local buildingPit = myEltGen.pit(Map.size.w * (nP * 2)/(coefMap*2) + 1, Map.size.h)
    table.insert(listPits, buildingPit)
  end
  
  local j
  for j = 1, #listPits do
    local p = listPits[j]
    Map.grid[p.linY][p.colX - 1].idText = math.random(19, 21)
    Map.grid[p.linY + 1][p.colX - 1].idText = math.random(25, 27)
    local alongH, alongW
    for alongH = 1, p.h do
      for alongW = 1, p.w do
        Map.grid[p.linY - 1 + alongH][p.colX - 1 + alongW].texture = "void"
        Map.grid[p.linY - 1 + alongH][p.colX - 1 + alongW].idText = 37
      end
    end
    Map.grid[p.linY][p.colX + p.w].idText = math.random(16, 18)
    Map.grid[p.linY + 1][p.colX + p.w].idText = math.random(22, 24)
  end
  
  
  local nH
  for nH = 1, nbHills do
    local buildingHill = myEltGen.hill(Map.size.w * (nH * 2 + 1)/(coefMap*2) + 1, Map.size.h)
    table.insert(listHills, buildingHill)
  end
  
  local k
  for k = 1, #listHills do
    local h = listHills[k]
    -- sprites for the top of the hill
    Map.grid[h.linY][h.colX].texture = "ground"
    Map.grid[h.linY][h.colX].idText = math.random(16, 18)
    local alongWTop
    for alongWTop = 1, h.w - 1 do
      Map.grid[h.linY][h.colX + alongWTop].texture = "ground"
      Map.grid[h.linY][h.colX + alongWTop].idText = math.random(4, 6)
    end
    Map.grid[h.linY][h.colX + h.w - 1].texture = "ground"
    Map.grid[h.linY][h.colX + h.w - 1].idText = math.random(19, 21)
    
    -- sprites for the inside of the hill
    local alongH
    for alongH = 1, h.h - 1 do
      Map.grid[h.linY + alongH][h.colX].texture = "ground"
      Map.grid[h.linY + alongH][h.colX].idText = math.random(7, 9)
      local alongWInside
      for alongWInside = 1, h.w - 1 do
        Map.grid[h.linY + alongH][h.colX + alongWInside].texture = "ground"
        Map.grid[h.linY + alongH][h.colX + alongWInside].idText = math.random(1, 3)
      end
      Map.grid[h.linY + alongH][h.colX + h.w - 1].texture = "ground"
      Map.grid[h.linY + alongH][h.colX + h.w - 1].idText = math.random(10, 12)
    end
    
    -- sprite for the bottom of the hill
    local alongWBottom
    for alongWBottom = 1, h.w do
      Map.grid[h.linY + h.h][h.colX + alongWBottom - 1].idText = math.random(1, 3)
    end
  end
  
  listPlatForms = myEltGen.genPlatForm(coefMap, Map.size.w, Map.size.h)
  local r
  for r = 1, #listPlatForms do
    local pf = listPlatForms[r]
    Map.grid[pf.lin][pf.col].texture = "ground"
    Map.grid[pf.lin][pf.col].idText = math.random(28, 30)
    
    local fill
    for fill = 1, pf.width do
      Map.grid[pf.lin][pf.col + fill].texture = "ground"
      Map.grid[pf.lin][pf.col + fill].idText = math.random(31, 33)
    end
    
    Map.grid[pf.lin][pf.col + pf.width].texture = "ground"
    Map.grid[pf.lin][pf.col + pf.width].idText = math.random(34, 36)
  end
    
  local lin2, col2, countPlatForm = 0, 0, 0
  for lin2 = 1, Map.size.h do
    for col2 = 1, Map.size.w do
      local g = Map.grid[lin2][col2]
      if (g.idText >= 4 and g.idText <= 6)
                  or (g.idText >= 16 and g.idText <= 21)
                  or (g.idText >= 28 and g.idText <= 36) then
                    countPlatForm = countPlatForm + 1
      end
    end
  end
  Map.size.platFormNumber = countPlatForm
end

function Map.Update(dt, pHero)
  -- manage the map movement
  if Map.mov == true then
    local lin, col
    for lin = 1, Map.size.h do
      for col = 1, Map.size.w do
        local g = Map.grid[lin][col]
        g.x = g.x - pHero.sign * pHero.speed.walk
        myParallax.Update(dt, pHero.sign, pHero.speed.walk)
      end
    end
  end
  
end

function Map.Draw()
  
  myParallax.Draw()
  
  local lin, col
  for lin = 1, Map.size.h do
    for col = 1, Map.size.w do
      local g = Map.grid[lin][col]
      if g.x > (0 - 32) and g.x < (windowWidth + 32) then
        love.graphics.draw(TileSet, TileTextures[g.idText], g.x, g.y)
      end
    end
  end
end

return Map