math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 960 -- default value
local windowHeight = 576 -- default value
--local windowWidth = 1340 -- max value
--local windowHeight = 682 -- max value
--local windowWidth = 1280 -- 32x32px sprites value (40 columns)
--local windowHeight = 672 -- 32x32px sprites value (21 lines)

local Map = {}
Map.grid = {}
Map.grid[1] = "000000000000000000000000000000"
Map.grid[2] = "000000000000000000000000000000"
Map.grid[3] = "000000000000000000000000000000"
Map.grid[4] = "000000000000000000000000000000"
Map.grid[5] = "000000000000000000000000000000"
Map.grid[6] = "000000400000000000000000000000"
Map.grid[7] = "000000000000000000000000000000"
Map.grid[8] = "000000000000000000000000000000"
Map.grid[9] = "000000000000000000000000000000"
Map.grid[10] = "000000000000000000000001110000"
Map.grid[11] = "000030000000000000000000000000"
Map.grid[12] = "000000000000000000000000000000"
Map.grid[13] = "020000000000000000000000000000"
Map.grid[14] = "000000005500000600000000001000"
Map.grid[15] = "000000000000000000000000000100"
Map.grid[16] = "111111111111111111111111111111"
local TileSet = {}
local TileTextures = {}
local scale = 1
local TILE_SIZE = 32 * scale
local setTileSize = 32

local Cube = {}
local bJumpReady = true

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
  --[[
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
  --]]
  
  Cube.x = 100
  Cube.y = 100
  Cube.size = 32
  Cube.vx = 0
  Cube.vy = 0
  Cube.standing = true
  
end

function updatePlayer(pPlayer, dt)
  -- Locals for Physics
  local accel = 500
  local friction = 150
  local maxSpeed = 150
  local jumpVelocity = -280

  -- Friction
  if pPlayer.vx > 0 then
    pPlayer.vx = pPlayer.vx - friction * dt
    if pPlayer.vx < 0 then pPlayer.vx = 0 end
  end
  if pPlayer.vx < 0 then
    pPlayer.vx = pPlayer.vx + friction * dt
    if pPlayer.vx > 0 then pPlayer.vx = 0 end
  end
  -- Keyboard
  if love.keyboard.isDown("right") then
    pPlayer.vx = pPlayer.vx + accel*dt
    if pPlayer.vx > maxSpeed then pPlayer.vx = maxSpeed end
  end
  if love.keyboard.isDown("left") then
    pPlayer.vx = pPlayer.vx - accel*dt
    if pPlayer.vx < -maxSpeed then pPlayer.vx = -maxSpeed end
  end
  if love.keyboard.isDown("up") and pPlayer.standing and bJumpReady then
    pPlayer.vy = jumpVelocity
    pPlayer.standing = false
    bJumpReady = false
  end
  if love.keyboard.isDown("up") == false and bJumpReady == false then
    bJumpReady = true
  end
  -- Move
  pPlayer.x = pPlayer.x + pPlayer.vx * dt
  pPlayer.y = pPlayer.y + pPlayer.vy * dt
end

function love.update(dt)
  updatePlayer(Cube, dt)
end

function love.draw()
  local lin, col
  for lin = 1, Map.size.h do
    for col = 1, Map.size.w do
      local char = string.sub(Map.grid[lin],col,col)
      if tonumber(char) > 0 then
        love.graphics.draw(TileSet, TileTextures[tonumber(char)],
                          (col-1)*TILE_SIZE, (lin-1)*TILE_SIZE, 0, 1, 1)
      end
    end
  end
  
  love.graphics.rectangle("fill", Cube.x, Cube.y, Cube.size, Cube.size)
  
end