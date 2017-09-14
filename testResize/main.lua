math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 960 -- default value 30 columns
local windowHeight = 576 -- default value 18 lines (2 for the hud)
--local windowWidth = 1340 -- max value
--local windowHeight = 682 -- max value
--local windowWidth = 1280 -- 32x32px sprites value (40 columns)
--local windowHeight = 672 -- 32x32px sprites value (21 lines)

local Map = {}
Map.grid = {
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0},
              {0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0},
              {0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0},
              {0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0},
              {0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0},
              {0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0},
              {0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
              {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
              {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6}
           }

local TILE_SIZE = 32
local reInitVY = 10

local Cube = {}

local myColor = require("color")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("my Title")
  
  -- initialize the size of the map
  Map.size = { w = windowWidth/TILE_SIZE, h = (windowHeight - (2 * TILE_SIZE))/TILE_SIZE,
               pixW = windowWidth, pixH = windowHeight - (2 * TILE_SIZE)}
  
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
  Cube.vx = 5
  Cube.vy = reInitVY
  Cube.state = "stand"
  
end

local function getTileAt(pX, pY)
  local col = math.floor(pX / 32) + 1
  local lig = math.floor(pY / 32) + 1
  if col > 0 and col <= #Map.grid[1] and lig > 0 and lig <= #Map.grid then
    local id = Map.grid[lig][col]
    return id
  end
  return 0
end

local function isSolid(pID)
  if pID == 0 then return false end
  if pID > 0 then return true end
end

local function Collide(pSprite)
  local id = getTileAt(pSprite.x + TILE_SIZE/2, pSprite.y + TILE_SIZE/2)
  return isSolid(id)
end

function love.update(dt)
  if love.keyboard.isDown("right") then
    Cube.x = Cube.x + Cube.vx
    Cube.state = "walk"
  elseif love.keyboard.isDown("left") then
    Cube.x = Cube.x - Cube.vx
    Cube.state = "walk"
  else
    Cube.state = "stand"
  end
    
  if (love.keyboard.isDown("space") and Cube.state ~= "jump") or Cube.y < Map.size.pixH then
    Cube.state = "jump"
  end
  
  if Cube.state == "jump" then
    Cube.y = Cube.y - Cube.vy
    Cube.vy = Cube.vy - 10 * dt
  else
    Cube.vy = reInitVY
  end
  
  local collide = false
  if Cube.vx ~= 0 then collide = Collide(Cube) end

  if collide then
    Cube.vx = 0
    local col = math.floor((Cube.x + 16) / 32) + 1
    Cube.x = (col-1)*16
  end

  if Cube.vy ~= 0 then
    collide = Collide(Cube)
    if collide then
      Cube.vy = 0
      local lig = math.floor((Cube.y + 16) / 32) + 1
      Cube.y = (lig-1)*16
    end
  end

  
  
end

function love.draw()
  local lin, col
  for lin = 1, Map.size.h do
    for col = 1, Map.size.w do
      local g = Map.grid[lin][col]
      if g > 0 then
        love.graphics.setColor(myColor.RGBData[g])
        love.graphics.rectangle("fill", (col-1)*TILE_SIZE, (lin-1)*TILE_SIZE, TILE_SIZE, TILE_SIZE)
      end
    end
  end
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", Cube.x, Cube.y, Cube.size, Cube.size)
  
end