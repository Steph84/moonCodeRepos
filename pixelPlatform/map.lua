local Map = {}
Map.tileTextures = {}
Map.grid = {}

local windowWidth, windowHeight
Map.TILE_SIZE = 32

function Map.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  -- load the tile sheet
  Map.TileSheet = love.graphics.newImage("pictures/groundBLocks.png")
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
  
  Map.size = { w = (2 * windowWidth)/Map.TILE_SIZE, h = (windowHeight - (2 * Map.TILE_SIZE))/Map.TILE_SIZE,
               pixW = 2 * windowWidth, pixH = windowHeight - (2 * Map.TILE_SIZE)}

  local lin, col
  local idGrid = 0
  for lin = 1, Map.size.h do
    Map.grid[lin] = {}
    for col = 1, Map.size.w do
      idGrid = idGrid + 1
      if lin == Map.size.h then
        if col == 1 then
          Map.grid[lin][col] = {id = idGrid, x = (col-1)*Map.TILE_SIZE, y = (lin-1)*Map.TILE_SIZE, idText = 1, texture = "ground"}
        elseif col == Map.size.w then
          Map.grid[lin][col] = {id = idGrid, x = (col-1)*Map.TILE_SIZE, y = (lin-1)*Map.TILE_SIZE, idText = 3, texture = "ground"}
        else Map.grid[lin][col] = {id = idGrid, x = (col-1)*Map.TILE_SIZE, y = (lin-1)*Map.TILE_SIZE, idText = 2, texture = "ground"}
        end
        
      else Map.grid[lin][col] = {id = idGrid, x = (col-1)*Map.TILE_SIZE, y = (lin-1)*Map.TILE_SIZE, idText = -1, texture = "void"} end
    end
  end
  
end

function Map.Update(dt, pHeroX)
  
  if pHeroX > windowWidth * 0.6 then
  
    local lin, col
    for lin = 1, Map.size.h do
      for col = 1, Map.size.w do
        local g = Map.grid[lin][col]
        
        g.x = g.x - 100 * dt
      end
    end
    
  end
end

function Map.Draw()
  local lin, col
  for lin = 1, Map.size.h do
    for col = 1, Map.size.w do
      local g = Map.grid[lin][col]
      --love.graphics.rectangle("line", g.x, g.y, 32, 32)
      --love.graphics.print(lin..", "..col, g.x + 5, g.y + 5, 0, 0.7, 0.7)
      if g.texture == "void" then
      else love.graphics.draw(Map.TileSheet, Map.tileTextures[g.idText],  g.x, g.y) end
    end
  end
end

return Map