local Map = {}

local windowWidth, windowHeight
local myPlayer = {}
local timeElpased = 0

local hoveredOffSet = 5
local hoveredTile

local TileSet, TileTextures = {}, {}
Map.Grid = {}
Map.TILE_SIZE = 0

function Map.Load(pWindowWidth, pWindowHeight, pTileSize, pMyPlayer)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  Map.TILE_SIZE = pTileSize
  myPlayer = pMyPlayer
  
-- initialize the size of the map
  Map.Size = { w = windowWidth/Map.TILE_SIZE, h = (windowHeight - Map.TILE_SIZE)/Map.TILE_SIZE}
  
  -- load the tile sheet
  TileSet = love.graphics.newImage("pictures/texture01MonthJamJam.png")
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
  -- building the map
  local lin, col
  local idTile = 0
  for lin = 1, Map.Size.h do
    Map.Grid[lin] = {}
    for col = 1, Map.Size.w do
      idTile = idTile + 1
      -- initialize the map
      Map.Grid[lin][col] = {id = idTile,
                            x = (col-1)*Map.TILE_SIZE, y = (lin-1)*Map.TILE_SIZE,
                            w = Map.TILE_SIZE, h = Map.TILE_SIZE, 
                            idText = 1, texture = "grass", isSelected = false}
    end
  end
end

function Map.Update(dt, pPlayerPosition)
  hoveredTile = Map.Grid[pPlayerPosition.lin][pPlayerPosition.col]
end

function Map.Draw()
  
  hoveredTile.x = hoveredTile.x + hoveredOffSet
  hoveredTile.y = hoveredTile.y - hoveredOffSet
  
  local lin, col
  for lin = 1, Map.Size.h do
    for col = 1, Map.Size.w do
      local g = Map.Grid[lin][col]
      love.graphics.rectangle("line", g.x, g.y, 64, 64)
      love.graphics.draw(TileSet, TileTextures[g.idText], g.x, g.y)
    end
  end
  
  love.graphics.rectangle("line", hoveredTile.x, hoveredTile.y, 64, 64)
  love.graphics.draw(TileSet, TileTextures[hoveredTile.idText], hoveredTile.x, hoveredTile.y)
  
  hoveredTile.x = hoveredTile.x - hoveredOffSet
  hoveredTile.y = hoveredTile.y + hoveredOffSet
  
end
  
return Map