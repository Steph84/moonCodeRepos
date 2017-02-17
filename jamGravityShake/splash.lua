local Splash = {}

local TILE_WIDTH = 62
local TILE_HEIGHT = 33

function Splash.Load()
  Splash.TileSheet = love.graphics.newImage("pictures/splash.png")
  Splash.pictures = {}
  local nbColumns = Splash.TileSheet:getWidth() / TILE_WIDTH
  local nbLines = Splash.TileSheet:getHeight() / TILE_HEIGHT

  local l, c
  local id = 1
  Splash.pictures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    Splash.pictures[id] = love.graphics.newQuad(
                                (c-1)*TILE_WIDTH,
                                (l-1)*TILE_HEIGHT,
                                TILE_WIDTH,
                                TILE_HEIGHT,
                                Splash.TileSheet:getDimensions()
                                )
    id = id + 1
    end
  end
  Splash.picCurrent = 1
end

function Splash.Update(dt)
  Splash.picCurrent = Splash.picCurrent + (12 * dt)
  if math.floor(Splash.picCurrent) > #Splash.pictures then
    Splash.picCurrent = 1
  end
end

function Splash.Draw()
  
                    
  love.graphics.draw(Splash.TileSheet, Splash.pictures[math.floor(Splash.picCurrent)], 100, 200)
      
end

return Splash