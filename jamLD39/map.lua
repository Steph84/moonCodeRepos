math.randomseed(os.time())
local Map = {}

local windowWidth, windowHeight, TILE_SIZE
local mapNb = 5 -- grass, sand, water, snow, Mars
local TileSet, TileTextures = {}, {}
Map.grid = {}
Map.listGrids = {}

-- initialize oil count and fog count
Map.countOil = {}
Map.fogOutCount = {}
local iter
for iter = 1, 5 do
  Map.fogOutCount[iter] = 0
end

-- color used in each map
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

-- function to create level
function CreateLevel(pId)
  local gridItem = {}
  local tempCount = 0
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
      
      -- spawn alternative texture
      local rdGeneric = math.random(0, 100)
      if rdGeneric < 20 then gridItem[lin][col].idText = pId end
      
      -- spawn rocks
      if rdGeneric > 95 then
        gridItem[lin][col].idText = 8 -- rocks
        gridItem[lin][col].texture = "block"
      end
      
      -- for the first level, spawn trees
      if pId == 1 then
        local rdTree = math.random(0, 100)
        if rdTree < 5 then
          gridItem[lin][col].idText = 6 -- trees
          gridItem[lin][col].texture = "block"
        end
      end
      
      -- for the second level spawn cactus
      if pId == 2 then
        local rdCactus = math.random(0, 1000)
        if rdCactus < 5 then
          gridItem[lin][col].idText = 7 -- cactus
          gridItem[lin][col].texture = "block"
        end
      end
      
      -- spawn oil
      if rdGeneric == 7 then -- non significant number
        tempCount = tempCount + 1
        gridItem[lin][col].idText = 9 -- petrol
        gridItem[lin][col].petrol = true
        gridItem[lin][col].texture = "void"
      end
      
    end
  end
  
  -- for the last level, spaw the plutonium bar
  if pId == 5 then
    local rdCol, rdLin
    repeat
      rdCol = math.floor(math.random(Map.size.w * 0.8, Map.size.w * 0.95))
      rdLin = math.floor(math.random(Map.size.h * 0.8, Map.size.h * 0.95))
    until (gridItem[rdLin][rdCol].texture ~= "block")
    gridItem[rdLin][rdCol].idText = 11 -- plutonium
  end
  
  -- update oil count and save each map
  table.insert(Map.countOil, tempCount)
  table.insert(Map.listGrids, gridItem)
  
end

function Map.Update(dt, pLevel)
  -- dynamic update of the area explored
  Map.fogOutCount[pLevel] = 0
  local lin, col
  for lin = 1, Map.size.h do
    for col = 1, Map.size.w do
      local case = Map.listGrids[pLevel][lin][col]
      if case.isHidden == false then
        Map.fogOutCount[pLevel] = Map.fogOutCount[pLevel] + 1
      end
    end
  end
end

function Map.Draw(pId)
  
  local lin, col
  for lin = 1, Map.size.h do
    for col = 1, Map.size.w do
      local g = Map.listGrids[pId][lin][col]
      if g.isHidden == false then
        love.graphics.setColor(listColors[pId])
        love.graphics.rectangle("fill", g.x, g.y, TILE_SIZE, TILE_SIZE)
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(TileSet, TileTextures[g.idText], g.x, g.y)
      end
    end
  end
end

return Map