math.randomseed(os.time()) --initialiser le random
local Field = {}

Field.TileTextures = {}
Field.Map = {}
Field.Map.Grid = {}
Field.Wall = {}
Field.TileType = {}
Field.Flipper = {}

local mapWidth = 0
local mapHeight = 0
local TILE_SIZE = 32

local myBall = require("ball")

function Field.Map.IsSolid(pID)
  local tileType = Field.TileType[pID]
  if tileType == "wall" then return true end
  return false
end

function Field.Load(pWindowWidth, pWindowHeight)
  Field.TileSheet = love.graphics.newImage("pictures/walls1SLE.png")
  local nbColumns = Field.TileSheet:getWidth() / TILE_SIZE -- width 448 14
  local nbLines = Field.TileSheet:getHeight() / TILE_SIZE -- height 256 8
  mapWidth = pWindowWidth/32
  mapHeight = pWindowHeight/32
  
  -- randomly choose the color in the tile sheet
  local colorPickA = math.random(0, 1)
  math.randomseed(os.time())
  local colorPickB = math.random(0, 1)
  
  -- there are 4 colors so : 
  -- 0, 0        1, 0
  -- 0, 1        1, 1
  Field.Wall.up = 4 + colorPickA * 7 + colorPickB*56
  Field.Wall.down = 18 + colorPickA * 7 + colorPickB*56
  Field.Wall.left = 15 + colorPickA * 7 + colorPickB*56
  Field.Wall.right = 16 + colorPickA * 7 + colorPickB*56
  Field.Wall.ulCorner = 31 + colorPickA * 7 + colorPickB*56
  Field.Wall.urCorner = 32 + colorPickA * 7 + colorPickB*56
  Field.Wall.dlCorner = 45 + colorPickA * 7 + colorPickB*56
  Field.Wall.drCorner = 46 + colorPickA * 7 + colorPickB*56
  Field.Wall.Floor = 7 + colorPickA * 7 + colorPickB*56
  
  -- to manage the ball rebound
  Field.TileType[Field.Wall.up] = "wall"
  Field.TileType[Field.Wall.down] = "wall"
  Field.TileType[Field.Wall.left] = "wall"
  Field.TileType[Field.Wall.right] = "wall"
  Field.TileType[Field.Wall.ulCorner] = "wall"
  Field.TileType[Field.Wall.urCorner] = "wall"
  Field.TileType[Field.Wall.dlCorner] = "wall"
  Field.TileType[Field.Wall.drCorner] = "wall"
  Field.TileType[Field.Wall.Floor] = "ground"
    
  -- get all the tiles in the tile sheet
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
  
  -- build the map
  local li, co
  for li = 1, mapHeight do
    Field.Map.Grid[li] = {}
    for co = 1, mapWidth do
      if li == 1 then Field.Map.Grid[li][co] = Field.Wall.up
      elseif co == 1 then Field.Map.Grid[li][co] = Field.Wall.left
      elseif co == mapWidth then Field.Map.Grid[li][co] = Field.Wall.right
      elseif li == mapHeight then Field.Map.Grid[li][co] = Field.Wall.down else
      Field.Map.Grid[li][co] = Field.Wall.Floor end
      if li == 1 and co == 1 then Field.Map.Grid[li][co] = Field.Wall.ulCorner end
      if li == 1 and co == mapWidth then Field.Map.Grid[li][co] = Field.Wall.urCorner end
      if li == mapHeight and co == 1 then Field.Map.Grid[li][co] = Field.Wall.dlCorner end
      if li == mapHeight and co == mapWidth then Field.Map.Grid[li][co] = Field.Wall.drCorner end
    end
  end
  
  -- load and place the flippers
  Field.Flipper.src = love.graphics.newImage("pictures/flipper.png")
  Field.Flipper.w = Field.Flipper.src:getWidth()
  Field.Flipper.h = Field.Flipper.src:getHeight()
  Field.Flipper.scale = 1
  Field.Flipper.leftX = 110
  Field.Flipper.leftY = 550
  Field.Flipper.leftRotation = math.pi/4
  Field.Flipper.rightX = 380
  Field.Flipper.rightY = 550
  Field.Flipper.rightRotation = - math.pi/4
  
  myBall.Load()
end

function Field.Update(dt, pWindowWidth, pWindowHeight)
  
  -- moving the flippers
  if love.keyboard.isDown("left") then
    Field.Flipper.leftRotation = 0
  elseif love.keyboard.isDown("right") then
    Field.Flipper.rightRotation = 0
  else 
    Field.Flipper.leftRotation = math.pi/4
    Field.Flipper.rightRotation = - math.pi/4
  end
  
  -- calculate the coordonates of the end of each flipper
  Field.Flipper.leftEndX = Field.Flipper.w * math.cos(Field.Flipper.leftRotation) + Field.Flipper.leftX - 1.5*Field.Flipper.w/10
  Field.Flipper.leftEndY = Field.Flipper.w * math.sin(Field.Flipper.leftRotation) * (0.8) + Field.Flipper.leftY
  Field.Flipper.rightEndX = - Field.Flipper.w * math.cos(Field.Flipper.rightRotation) + Field.Flipper.rightX + 1.5*Field.Flipper.w/10
  Field.Flipper.rightEndY = - Field.Flipper.w * math.sin(Field.Flipper.rightRotation) * (0.8) + Field.Flipper.rightY
  
  myBall.Update(dt, Field, pWindowWidth, pWindowHeight, mapWidth, mapHeight, TILE_SIZE, Field)
  
end

function Field.Draw()
  
  -- draw the map
  local c, l
  for l = 1, mapHeight do
    for c = 1, mapWidth do
      local id = Field.Map.Grid[l][c] -- gather the id in the map table
      local texQuad = Field.TileTextures[id] -- gather the texture of this id
      if texQuad ~= nil then
        love.graphics.draw(Field.TileSheet, texQuad, (c-1)*TILE_SIZE, (l-1)*TILE_SIZE)
      end
    end
  end
  
  -- draw the flippers and manage their movement
  love.graphics.push()
  love.graphics.draw(Field.Flipper.src,
                     Field.Flipper.leftX, Field.Flipper.leftY,
                     Field.Flipper.leftRotation,
                     Field.Flipper.scale, Field.Flipper.scale,
                     Field.Flipper.w/10, Field.Flipper.h/2)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.draw(Field.Flipper.src,
                     Field.Flipper.rightX, Field.Flipper.rightY,
                     Field.Flipper.rightRotation,
                     Field.Flipper.scale, Field.Flipper.scale,
                     Field.Flipper.w*9/10, Field.Flipper.h/2)
  love.graphics.pop()
  
  --love.graphics.circle("fill", Field.Flipper.leftX, Field.Flipper.leftY, 10)
  --love.graphics.circle("fill", Field.Flipper.leftEndX, Field.Flipper.leftEndY, 10)
  --love.graphics.circle("fill", Field.Flipper.rightX, Field.Flipper.rightY, 10)
  --love.graphics.circle("fill", Field.Flipper.rightEndX, Field.Flipper.rightEndY, 10)
  
  myBall.Draw()
  
end

return Field