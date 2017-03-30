math.randomseed(os.time())

local Lobster = {}
Lobster.tileSheet = {}
Lobster.tileTextures = {}
Lobster.scaleX = 1
Lobster.scaleY = 1

local tileWidth = 0
local tileHeight = 0

function Lobster.Load(ppWindowWidth, ppWindowHeight)
  
  -- load the pictures
  Lobster.tileSheet = love.graphics.newImage("pictures/lobster_walk.png")
  local nbColumns = 6
  local nbLines = 1
  tileWidth = Lobster.tileSheet:getWidth()/nbColumns
  tileHeight = Lobster.tileSheet:getHeight()/nbLines
  
  -- get all the tiles in the tile sheet
  local l, c
  local id = 1
  Lobster.tileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    Lobster.tileTextures[id] = love.graphics.newQuad(
                              (c-1)*tileWidth,
                              (l-1)*tileHeight,
                              tileWidth,
                              tileHeight,
                              Lobster.tileSheet:getDimensions()
                              )
    id = id + 1
    end
  end
  
  Lobster.pictures = {}
  local n
  for n = 1, 6 do
    Lobster.pictures[n] = Lobster.tileTextures[n]
  end   
  
  Lobster.picCurrent = 1
  
  Lobster.x = math.random(0, ppWindowWidth)
  Lobster.y = ppWindowHeight - tileHeight
  
  Lobster.vx = 1
  
end

function Lobster.Update(ppDt, ppWindowWidth, ppWindowHeight)
  Lobster.picCurrent = Lobster.picCurrent + (8 * ppDt) -- using the delta time
  
  if math.floor(Lobster.picCurrent) > #Lobster.pictures then
    Lobster.picCurrent = 1
  end
  
  Lobster.x = Lobster.x + Lobster.vx
  
  if Lobster.x < 0 or Lobster.x > ppWindowWidth then
    Lobster.vx = - Lobster.vx
    Lobster.scaleX = - Lobster.scaleX
  end
  
end

function Lobster.Draw()
  love.graphics.draw(
                      Lobster.tileSheet,
                      Lobster.pictures[math.floor(Lobster.picCurrent)],
                      Lobster.x,
                      Lobster.y,
                      0,
                      Lobster.scaleX,
                      Lobster.scaleY,
                      tileWidth/2,
                      tileHeight/2
                      )
end

return Lobster