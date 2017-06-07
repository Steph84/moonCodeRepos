local MapGen = {}

local mapSize = {}
mapSize.width = 0
mapSize.height = 0
local TILE_SIZE = 32

local tileSheet = {}
local tileTextures = {}
local windowWidth, windowHeight
local myMapping = require("tileSetMapping")

function CreateTile(pId, pLin, pCol, pIdLeft, pIdUp)
  local thisTile = {}
  thisTile.id = pId
  thisTile.x = (pCol - 1) * TILE_SIZE
  thisTile.y = (pLin - 1) * TILE_SIZE
  if pId == 1 then
    thisTile.idTile = 1 --math.random(1, 48)
  else
    if pIdLeft ~= 1 then
      thisTile.idTile = myMapping[pIdLeft][math.random(#myMapping[pIdLeft])]
    elseif pIdUp ~= 0 then
      
    elseif pIdLeft ~= 0 and pIdUp ~= 0 then
  
    end
  end
  
  
  return thisTile
end


function MapGen.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  
  -- get all the tiles in the tile sheet
  tileSheet.src = love.graphics.newImage("tileSets/terrainTiles32x32.png")
  local nbCol = tileSheet.src:getWidth() / TILE_SIZE
  local nbLin = tileSheet.src:getHeight() / TILE_SIZE
  
  local l2, c2
  local id = 1
  tileTextures[0] = nil
  for l = 1, nbLin do
    for c = 1, nbCol do
    tileTextures[id] = love.graphics.newQuad(
                                              (c-1)*TILE_SIZE,
                                              (l-1)*TILE_SIZE,
                                              TILE_SIZE,
                                              TILE_SIZE,
                                              tileSheet.src:getDimensions()
                                            )
    id = id + 1
    end
  end
  
  
  -- map building
  mapSize.width = math.floor(windowWidth / TILE_SIZE)
  mapSize.height = math.floor(windowHeight / TILE_SIZE) - 64/TILE_SIZE -- for game hub
  
  local tileId, leftId, upId = 0, 0, 0
  for l = 1, mapSize.height do MapGen[l] = {}
    for c = 1, mapSize.width do
      tileId = tileId + 1
      if c-1 > 0 then leftId = MapGen[l][c-1].idTile end
      if l-1 > 0 then upId = MapGen[l-1][c].idTile end
      MapGen[l][c] = CreateTile(tileId, l, c, leftId, upId)
    end
  end
  
end


function MapGen.Draw()
  for l = 1, mapSize.height do
    for c = 1, mapSize.width do
      local t = MapGen[l][c]
      local texQuad = tileTextures[t.idTile] -- gather the texture of this id
      if texQuad ~= nil then
        love.graphics.draw(tileSheet.src, texQuad, t.x, t.y)
      end
      --love.graphics.rectangle("fill", t.x + 1, t.y + 1, TILE_SIZE - 2, TILE_SIZE - 2)
    end
  end
end

return MapGen