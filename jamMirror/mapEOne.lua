local MapE01 = {}

local mapSize = {}
mapSize.width = 0
mapSize.height = 0
mapSize.tileSize = 16
local TILE_SIZE = 16

local tileSheet = {}
local tileTextures = {}

local windowWidth, windowHeight

function MapE01.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  mapSize.width = math.floor(windowWidth / TILE_SIZE)
  mapSize.height = math.floor(windowHeight / TILE_SIZE) - 4 -- for game hub
  print(mapSize.width, mapSize.height)
  
  -- map initialization
  for l = 1, mapSize.height do MapE01[l] = {}
    for c = 1, mapSize.width do MapE01[l][c] = 0
    end
  end
  
  tileSheet.src = love.graphics.newImage("tileSets/whiteTileSet.png")
  local nbCol = tileSheet.src:getWidth() / TILE_SIZE
  local nbLin = tileSheet.src:getHeight() / TILE_SIZE
  
  -- get all the tiles in the tile sheet
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
  
end


function MapE01.Draw()
  
end


return MapE01