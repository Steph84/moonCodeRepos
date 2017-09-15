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
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
              {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
              {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6}
           }

local TILE_SIZE = 32
local reInitVY = 10

local Cube = {}

local myColor = require("color")
local displayWidth, displayHeight

function love.load()
  
  displayWidth, displayHeight = love.window.getDesktopDimensions()
  if displayWidth > 1500 then
    windowWidth = windowWidth * 1.5
    windowHeight = windowHeight * 1.5
  end
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("my Title")
  
  -- initialize the size of the map
  Map.size = { w = 960/TILE_SIZE, h = (576 - (2 * TILE_SIZE))/TILE_SIZE}
  
 
  
  Cube.x = 100
  Cube.y = 100
  Cube.size = 32
  Cube.vx = 5
  Cube.vy = 5
  Cube.state = "stand"
  
end

local function getTileAt(pX, pY)
  local col = math.floor(pX / TILE_SIZE) + 1
  local lig = math.floor(pY / TILE_SIZE) + 1
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

function love.update(dt)
  
  local textureUnder = getTileAt(Cube.x + TILE_SIZE/2, Cube.y + TILE_SIZE + 5)
  
  if love.keyboard.isDown("right") then
    Cube.x = Cube.x + Cube.vx
    Cube.state = "walk"
  elseif love.keyboard.isDown("left") then
    Cube.x = Cube.x - Cube.vx
    Cube.state = "walk"
  else
    Cube.state = "stand"
  end
    
  if (love.keyboard.isDown("space") and Cube.state ~= "jump") or textureUnder == 0 then
    Cube.state = "jump"
  end
  
  if (love.keyboard.isDown("right") or love.keyboard.isDown("left")) and textureUnder == 0 then
    --Cube.vy = 0
  end
  
  if Cube.state == "jump" then
    Cube.y = Cube.y - Cube.vy
    Cube.vy = Cube.vy - 10 * dt
  else
    Cube.vy = reInitVY
  end
  
  
  
end

function love.draw()
  
  if displayWidth > 1500 then
    love.graphics.scale(1.5, 1.5)
  end
  
  
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
  
  love.graphics.circle("fill", Cube.x + TILE_SIZE/2, Cube.y + TILE_SIZE + 5, 5)
  
  
end