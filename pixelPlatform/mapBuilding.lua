math.randomseed(os.time())
local MapBuilding = {}
MapBuilding.tileTextures = {}
MapBuilding.grid = {}

local windowWidth, windowHeight
local TILE_SIZE
local listPit = {}
local coefMap = 4

local myMapping = require("tileSetMapping")
local myEltGen = require("mapEltGen")

function MapBuilding.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  local build = false
  
  -- load the tile sheet
  MapBuilding.TileSheet = love.graphics.newImage("pictures/platFormTileSet02_32x32.png")
  local nbColumns = MapBuilding.TileSheet:getWidth() / TILE_SIZE
  local nbLines = MapBuilding.TileSheet:getHeight() / TILE_SIZE
  
  -- extract all the tiles in the tile sheet
  local l, c
  local id = 1
  MapBuilding.tileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    MapBuilding.tileTextures[id] = love.graphics.newQuad(
                              (c-1)*TILE_SIZE,
                              (l-1)*TILE_SIZE,
                              TILE_SIZE,
                              TILE_SIZE,
                              MapBuilding.TileSheet:getDimensions()
                              )
    id = id + 1
    end
  end
  
  -- initialize the size of the map
  MapBuilding.size = { w = (coefMap * windowWidth)/TILE_SIZE, h = (windowHeight - (2 * TILE_SIZE))/TILE_SIZE,
                       pixW = coefMap * windowWidth, pixH = windowHeight - (2 * TILE_SIZE)}

  -- building the map
  local lin, col
  local idGrid = 0
  for lin = MapBuilding.size.h, 1, -1 do
    MapBuilding.grid[lin] = {}
    for col = 1, MapBuilding.size.w do
      idGrid = idGrid + 1
      -- initialize the map
      MapBuilding.grid[lin][col] = {id = idGrid,
                            x = (col-1)*TILE_SIZE, y = (lin-1)*TILE_SIZE,
                            w = TILE_SIZE, h = TILE_SIZE, 
                            idText = 28, texture = "void"}
      
      if lin == MapBuilding.size.h then
        MapBuilding.grid[lin][col].texture = "ground"
        MapBuilding.grid[lin][col].idText = math.random(1, 3)
      elseif lin == (MapBuilding.size.h - 1) then
        MapBuilding.grid[lin][col].texture = "ground"
        MapBuilding.grid[lin][col].idText = math.random(4, 6)
      end
    end
  end
  
  local firstPit = myEltGen.pit(windowWidth/32 + 1, 18)
  table.insert(listPit, firstPit)
  local secondPit = myEltGen.pit(MapBuilding.size.w/2, 18)
  table.insert(listPit, secondPit)
  
  local j
  for j = 1, #listPit do
    local p = listPit[j]
    MapBuilding.grid[p.linY][p.colX - 1].idText = math.random(19, 21)
    MapBuilding.grid[p.linY + 1][p.colX - 1].idText = math.random(10, 12)
    local alongH, alongW
    for alongH = 1, p.h do
      for alongW = 1, p.w do
        MapBuilding.grid[p.linY - 1 + alongH][p.colX - 1 + alongW].texture = "void"
        MapBuilding.grid[p.linY - 1 + alongH][p.colX - 1 + alongW].idText = 28
      end
    end
    MapBuilding.grid[p.linY][p.colX + p.w].idText = math.random(16, 18)
    MapBuilding.grid[p.linY + 1][p.colX + p.w].idText = math.random(7, 9)
  end
  
end

return MapBuilding