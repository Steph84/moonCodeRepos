math.randomseed(os.time())
local Map = {}

local windowWidth, windowHeight, TILE_SIZE
local mapNb = 5 -- grass, sand, water, snow, Mars
local TileSet, TileTextures = {}, {}
Map.grid = {}
Map.listGrids = {}

local listColors = {
                    {0, 128, 0},
                    {255, 192, 0},
                    {0, 64, 128},
                    {255, 255, 255},
                    {192, 0, 64}
                   }

function Map.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  -- initialize the size of the map
  Map.size = { w = windowWidth/TILE_SIZE, h = (windowHeight - (2 * TILE_SIZE))/TILE_SIZE}
  
  -- load the tile sheet
  TileSet = love.graphics.newImage("pictures/tileSetLD39.png")
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
  
  local i
  for i = 1, mapNb do
    CreateLevel(i)
  end
end

function CreateLevel(pId)
  local gridItem = {}
  -- building the map
  local lin, col
  local idTile = 0
  for lin = 1, Map.size.h do
    gridItem[lin] = {}
    for col = 1, Map.size.w do
      idTile = idTile + 1
      -- initialize the map
      gridItem[lin][col] = {id = idTile,
                            x = (col-1)*TILE_SIZE, y = (lin-1)*TILE_SIZE,
                            w = TILE_SIZE, h = TILE_SIZE, 
                            idText = 10, texture = "void",
                            isHidden = true, petrol = false}
      
      local rdGeneric = math.random(0, 100)
      if rdGeneric < 20 then gridItem[lin][col].idText = pId end
      if rdGeneric > 95 then
        gridItem[lin][col].idText = 8 -- rocks
        gridItem[lin][col].texture = "block"
      end
      
      if pId == 1 then
        local rdTree = math.random(0, 100)
        if rdTree < 5 then
          gridItem[lin][col].idText = 6 -- trees
          gridItem[lin][col].texture = "block"
        end
      end
      
      if pId == 2 then
        local rdCactus = math.random(0, 100)
        if rdCactus < 5 then
          gridItem[lin][col].idText = 7 -- cactus
          gridItem[lin][col].texture = "block"
        end
      end
      
      if rdGeneric > 15 and rdGeneric < 75 then
        gridItem[lin][col].idText = 9 -- petrol
        gridItem[lin][col].petrol = true
        gridItem[lin][col].texture = "void"
      end
      
    end
  end
  
  if pId == 5 then
    local rdCol, rdLin
    repeat
      rdCol = math.floor(math.random(Map.size.w * 0.8, Map.size.w * 0.95))
      rdLin = math.floor(math.random(Map.size.h * 0.8, Map.size.h * 0.95))
    until (gridItem[rdLin][rdCol].texture ~= "block")
    gridItem[rdLin][rdCol].idText = 11 -- plutonium
  end
  
  table.insert(Map.listGrids, gridItem)
  
end

function Map.Draw(pId)
    
  local lin, col
  for lin = 1, Map.size.h do
    for col = 1, Map.size.w do
      local g = Map.listGrids[pId][lin][col]
      --if g.isHidden == false then
        love.graphics.setColor(listColors[pId])
        love.graphics.rectangle("fill", g.x, g.y, TILE_SIZE, TILE_SIZE)
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(TileSet, TileTextures[g.idText], g.x, g.y)
      --end
    end
  end
end

return Map