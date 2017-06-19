local Map = {}
Map.tileTextures = {}
Map.grid = {}

local windowWidth, windowHeight
local TILE_SIZE = 32

function Map.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  -- load the tile sheet
  Map.TileSheet = love.graphics.newImage("pictures/groundBLocks.png")
  local nbColumns = Map.TileSheet:getWidth() / TILE_SIZE
  local nbLines = Map.TileSheet:getHeight() / TILE_SIZE
  
  -- extract all the tiles in the tile sheet
  local l, c
  local id = 1
  Map.tileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    Map.tileTextures[id] = love.graphics.newQuad(
                              (c-1)*TILE_SIZE,
                              (l-1)*TILE_SIZE,
                              TILE_SIZE,
                              TILE_SIZE,
                              Map.TileSheet:getDimensions()
                              )
    id = id + 1
    end
  end
  
  Map.size = { (2 * windowWidth)/TILE_SIZE, (windowHeight - (2 * TILE_SIZE))/TILE_SIZE}
  local lin, col
  for lin = 1, Map.size[2] do
    Map.grid[lin] = {}
    for col = 1, Map.size[1] do
      if lin == Map.size[2] then
        if col == 1 then
          Map.grid[lin][col] = "ground1"
        elseif col == Map.size[1] then
          Map.grid[lin][col] = "ground3"
        else Map.grid[lin][col] = "ground2"
        end
        
      else Map.grid[lin][col] = "void" end
    end
  end
  
  
end

function Map.Draw()
  local lin, col
  for lin = 1, Map.size[2] do
    for col = 1, Map.size[1] do
      if Map.grid[lin][col] == "ground2" then
        love.graphics.draw(Map.TileSheet, Map.tileTextures[2],  (col-1)*TILE_SIZE, (lin-1)*TILE_SIZE)
      elseif Map.grid[lin][col] == "ground1" then
        love.graphics.draw(Map.TileSheet, Map.tileTextures[1],  (col-1)*TILE_SIZE, (lin-1)*TILE_SIZE)
      elseif Map.grid[lin][col] == "ground3" then
        love.graphics.draw(Map.TileSheet, Map.tileTextures[3],  (col-1)*TILE_SIZE, (lin-1)*TILE_SIZE)
      else Map.grid[lin][col] = "void" end
    end
  end
end

return Map