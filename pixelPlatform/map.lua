local Map = {}
Map.tileTextures = {}
Map.grid = {}

local windowWidth, windowHeight
Map.TILE_SIZE = 32
local speedAdjust = 35

function Map.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  local build = false
  
  -- load the tile sheet
  Map.TileSheet = love.graphics.newImage("pictures/groundBlocks.png")
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
  
  -- initialize the size of the map
  Map.size = { w = (2 * windowWidth)/Map.TILE_SIZE, h = (windowHeight - (2 * Map.TILE_SIZE))/Map.TILE_SIZE,
               pixW = 2 * windowWidth, pixH = windowHeight - (2 * Map.TILE_SIZE)}

  -- building the map
  local lin, col
  local idGrid = 0
  for lin = 1, Map.size.h do
    Map.grid[lin] = {}
    for col = 1, Map.size.w do
      idGrid = idGrid + 1
      -- initialize the map
      Map.grid[lin][col] = {id = idGrid,
                            x = (col-1)*Map.TILE_SIZE, y = (lin-1)*Map.TILE_SIZE,
                            w = Map.TILE_SIZE, h = Map.TILE_SIZE, 
                            idText = -1, texture = "void"}
      
      if lin == Map.size.h then
        Map.grid[lin][col].texture = "ground"
        if col == 1 then
          Map.grid[lin][col].idText = 1
        elseif col == Map.size.w then
          Map.grid[lin][col].idText = 3
        else 
          Map.grid[lin][col].idText = 2
        end
      end
    end
  end
  
  -- test for a platform
  if build == false then
    local azerty = 20 --math.random(Map.size.w/4, Map.size.w/2)
    local myline = Map.size.h - 4
    Map.grid[myline][azerty].idText = 1
    Map.grid[myline][azerty].texture = "ground"
    local it
    for it = 1, 3 do
      Map.grid[myline][azerty + it].idText = 2
      Map.grid[myline][azerty + it].texture = "ground"
    end
    Map.grid[myline][azerty + 4].idText = 3
    build = true
  end
  
end

function Map.Update(dt, pHero)
  
  -- manage the map movement
  if pHero.x > windowWidth * pHero.wall - 5
  and (Map.grid[Map.size.h][Map.size.w].x + Map.TILE_SIZE) > windowWidth
  and (pHero.mov == "walk" or pHero.mov == "jump" or pHero.mov == "fall") then
    local lin, col
    for lin = 1, Map.size.h do
      for col = 1, Map.size.w do
        local g = Map.grid[lin][col]
        g.x = g.x - pHero.speed.walk * dt * speedAdjust
      end
    end
  end
  if pHero.x < windowWidth * (1-pHero.wall)
  and Map.grid[1][1].x < 0
  and (pHero.mov == "walk" or pHero.mov == "jump" or pHero.mov == "fall") then
    local lin, col
    for lin = 1, Map.size.h do
      for col = 1, Map.size.w do
        local g = Map.grid[lin][col]
        g.x = g.x + pHero.speed.walk * dt * speedAdjust
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
      if g.texture == "void" and g.idText ~= 3 then
      else love.graphics.draw(Map.TileSheet, Map.tileTextures[g.idText],  g.x, g.y) end
    end
  end
end

return Map