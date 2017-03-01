local Field = {}

Field.TileTextures = {}
Field.Map = {}

local mapWidth = 0
local mapHeight = 0
local TILE_SIZE = 32

function Field.Load(pWindowWidth, pWindowHeight)
  Field.TileSheet = love.graphics.newImage("pictures/walls1SLE.png")
  local nbColumns = Field.TileSheet:getWidth() / TILE_SIZE -- width 448
  local nbLines = Field.TileSheet:getHeight() / TILE_SIZE -- height 256
  
  mapWidth = pWindowWidth/32
  mapHeight = pWindowHeight/32
  
  local l, c
  local id = 1
  Field.TileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    Field.TileTextures[id] = love.graphics.newQuad(
                              (c-1)*TILE_SIZE,
                              (l-1)*TILE_SIZE,
                              TILE_SIZE,
                              TILE_SIZE,
                              Field.TileSheet:getDimensions()
                              )
    id = id + 1
    end
  end
  
  local i, j
  for i = 1, mapHeight do
    Field.Map[i] = {}
    for j = 1, mapWidth do
      if i == 1 then Field.Map[i][j] = 4
      elseif j == 1 then Field.Map[i][j] = 15
      elseif j == mapWidth then Field.Map[i][j] = 16
      elseif i == mapHeight then Field.Map[i][j] = 18 else
      Field.Map[i][j] = 7 end
      if i == 1 and j == 1 then Field.Map[i][j] = 31 end
      if i == 1 and j == mapWidth then Field.Map[i][j] = 32 end
      if i == mapHeight and j == 1 then Field.Map[i][j] = 45 end
      if i == mapHeight and j == mapWidth then Field.Map[i][j] = 46 end
    end
  end
  
end

function Field.Draw()
  
  local c, l
  for l = 1, mapHeight do
    for c = 1, mapWidth do
      local id = Field.Map[l][c] -- gather the id in the map table
      local texQuad = Field.TileTextures[id] -- gather the texture of this id
      if texQuad ~= nil then
        love.graphics.draw(Field.TileSheet, texQuad, (c-1)*TILE_SIZE, (l-1)*TILE_SIZE)
      end
    end
  end
  
end


return Field