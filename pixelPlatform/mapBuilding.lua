local MapBuilding = {}
MapBuilding.tileTextures = {}
MapBuilding.grid = {}

local windowWidth, windowHeight
local TILE_SIZE = 32

function MapBuilding.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  local build = false
  
  -- load the tile sheet
  MapBuilding.TileSheet = love.graphics.newImage("pictures/platFormTileSet01_32x32.png")
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
  MapBuilding.size = { w = (2 * windowWidth)/TILE_SIZE, h = (windowHeight - (2 * TILE_SIZE))/TILE_SIZE,
                       pixW = 2 * windowWidth, pixH = windowHeight - (2 * TILE_SIZE)}

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
                            idText = 15, texture = "void"}
      
      if lin == MapBuilding.size.h or lin == (MapBuilding.size.h - 1) then
        MapBuilding.grid[lin][col].texture = "ground"
        MapBuilding.grid[lin][col].idText = math.random(1, 3)
      end
      if lin == (MapBuilding.size.h - 2) then
        MapBuilding.grid[lin][col].idText = math.random(4, 5)
      end
    end
  end
  
  -- test for a platform
  if build == false then
    local azerty = 20 --math.random(MapBuilding.size.w/4, MapBuilding.size.w/2)
    local myline = MapBuilding.size.h - 4
    MapBuilding.grid[myline][azerty].idText = 1
    MapBuilding.grid[myline][azerty].texture = "ground"
    local it
    for it = 1, 3 do
      MapBuilding.grid[myline][azerty + it].idText = 2
      MapBuilding.grid[myline][azerty + it].texture = "ground"
    end
    MapBuilding.grid[myline][azerty + 4].idText = 3
    build = true
  end
  
end

return MapBuilding