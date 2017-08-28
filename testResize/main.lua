 -- initialiser le random
math.randomseed(os.time())

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 960 -- default value
local windowHeight = 576 -- default value
--local windowWidth = 1340 -- max value
--local windowHeight = 682 -- max value
--local windowWidth = 1280 -- 32x32px sprites value (40 columns)
--local windowHeight = 672 -- 32x32px sprites value (21 lines)

local Map = {}
Map.grid = {}
local TileSet = {}
local TileTextures = {}
local scale = 1
local TILE_SIZE = 32 * scale
local setTileSize = 32

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("my Title")
  
  -- initialize the size of the map
  Map.size = { w = windowWidth/TILE_SIZE, h = (windowHeight - (2 * TILE_SIZE))/TILE_SIZE,
               pixW = windowWidth, pixH = windowHeight - (2 * TILE_SIZE)}
  -- load the tile sheet
  TileSet = love.graphics.newImage("pictures/platFormTileSet02_32x32.png")
  local nbColumns = TileSet:getWidth() / setTileSize
  local nbLines = TileSet:getHeight() / setTileSize
  
  -- extract all the tiles in the tile sheet
  local l, c
  local id = 1
  TileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    TileTextures[id] = love.graphics.newQuad(
                              (c-1)*setTileSize,
                              (l-1)*setTileSize,
                              setTileSize,
                              setTileSize,
                              TileSet:getDimensions()
                              )
    id = id + 1
    end
  end
  
  -- building the map
  local lin, col
  local idGrid = 0
  for lin = Map.size.h, 1, -1 do
    Map.grid[lin] = {}
    for col = 1, Map.size.w do
      idGrid = idGrid + 1
      -- initialize the map
      Map.grid[lin][col] = {id = idGrid,
                            x = (col-1)*TILE_SIZE, y = (lin-1)*TILE_SIZE,
                            w = TILE_SIZE, h = TILE_SIZE, 
                            idText = math.random(1, 37), texture = "void", scale = scale}
      
    end
  end
  
  
end

function love.update(dt)

end

function love.draw()
  local lin, col
  for lin = 1, Map.size.h do
    for col = 1, Map.size.w do
      local g = Map.grid[lin][col]
      if g.idText ~= 37 then
        love.graphics.draw(TileSet, TileTextures[g.idText], g.x, g.y, 0, g.scale, g.scale)
      end
    end
  end
end