local Map = {}

local windowWidth, windowHeight, TILE_SIZE
local timeElpased = 0

local TileSet, TileTextures = {}, {}
Map.grid = {}

function Map.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
-- initialize the size of the map
  Map.size = { w = windowWidth/TILE_SIZE, h = (windowHeight - TILE_SIZE)/TILE_SIZE}
  print(Map.size.w, Map.size.h)
  -- load the tile sheet
  TileSet = love.graphics.newImage("pictures/tileSetLD40.png")
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
  local idTile = 0
  for lin = 1, Map.size.h do
    Map.grid[lin] = {}
    for col = 1, Map.size.w do
      idTile = idTile + 1
      -- initialize the map
      Map.grid[lin][col] = {id = idTile,
                            x = (col-1)*TILE_SIZE, y = (lin-1)*TILE_SIZE,
                            w = TILE_SIZE, h = TILE_SIZE, 
                            idText = 1, texture = "sand"}
      
      if col == Map.size.w - 1 then
        Map.grid[lin][col].idText = 2
        Map.grid[lin][col].texture = "foam"
      end
      
      if col == Map.size.w then
        Map.grid[lin][col].idText = 3
        Map.grid[lin][col].texture = "sea"
      end
      
    end
  end
end

function Map.Update(dt)
  timeElpased = timeElpased + dt
  
  if timeElpased > 2 then
    timeElpased = 0
    RisingTide()
  end
  
end

-- Manage to rise the tide to flood the beach
function RisingTide()
  local lin, col
  for lin = 1, Map.size.h do
    for col = 1, Map.size.w do
      local g = Map.grid[lin][col]
      
      if g.texture == "foam" then
        
        if col == 1 then
          Map.grid[lin][col].idText = 3
          Map.grid[lin][col].texture = "sea"
          -- gameOver
        else
          Map.grid[lin][col - 1].idText = 2
          Map.grid[lin][col - 1].texture = "foam"
          Map.grid[lin][col].idText = 3
          Map.grid[lin][col].texture = "sea"
        end
      end
      
    end
  end
end

function Map.Draw()
  
  local lin, col
  for lin = 1, Map.size.h do
    for col = 1, Map.size.w do
      local g = Map.grid[lin][col]
      love.graphics.rectangle("line", g.x, g.y, 64, 64)
      love.graphics.draw(TileSet, TileTextures[g.idText], g.x, g.y)
    end
  end
  
end
  
return Map