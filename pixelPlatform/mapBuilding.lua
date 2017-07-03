local MapBuilding = {}
MapBuilding.tileTextures = {}
MapBuilding.grid = {}

local windowWidth, windowHeight
local TILE_SIZE = 32
local MAX_ITERATION = 500
local myMapping = require("tileSetMapping")

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
      if lin <= (MapBuilding.size.h - 2) then
        if col == 1 then
          local downIdText = MapBuilding.grid[lin+1][col].idText
          MapBuilding.grid[lin][col].idText = myMapping.bottom[downIdText][math.random(#myMapping.bottom[downIdText])]
        else
        local downIdText = MapBuilding.grid[lin+1][col].idText
        local leftIdText = MapBuilding.grid[lin][col-1].idText
        if downIdText == -1 then downIdText = 15 end
        if leftIdText == -1 then leftIdText = 15 end
        
        local tempLeft, tempDown, iteration = -1, 0, 0
        while tempLeft ~= tempDown and iteration < MAX_ITERATION do
          iteration = iteration + 1
          tempLeft = myMapping.left[leftIdText][math.random(#myMapping.left[leftIdText])]
          tempDown = myMapping.bottom[downIdText][math.random(#myMapping.bottom[downIdText])]
        end
        if iteration == MAX_ITERATION then
          MapBuilding.grid[lin][col].idText = -1
        else
          MapBuilding.grid[lin][col].idText = tempLeft
          if tempLeft == 1 or tempLeft == 2 or tempLeft == 3 then
            MapBuilding.grid[lin][col].texture = "ground"
          end
        end
        
        end
      end
    end
  end
  
  
  
end

return MapBuilding