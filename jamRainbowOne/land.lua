local Land = {}

Land.TileSheet = nil
Land.wid = {}
Land.hei = {}

Land.Map = {}
Land.Map = {
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
              { 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 63 },
              { 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 78 },
              { 31, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 92, 92, 92, 92, 92, 92, 92, 92, 92, 92, 92, 92, 92, 92, 93 }
            }

local MAP_WIDTH = #Land.Map[1] 
local MAP_HEIGHT = #Land.Map
print(MAP_WIDTH)
local TILE_SIZE = 32

Land.TileTextures = {}

function Land.Load()
  
  Land.font = love.graphics.newImage("pictures/tmMap01.png")
  Land.TileSheet = love.graphics.newImage("pictures/LandTiles_32_32.png")
  local nbColumns = Land.TileSheet:getWidth() / TILE_SIZE
  local nbLines = Land.TileSheet:getHeight() / TILE_SIZE
  
  local l, c
  local id = 1
  Land.TileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    Land.TileTextures[id] = love.graphics.newQuad(
                              (c-1)*TILE_SIZE,
                              (l-1)*TILE_SIZE,
                              TILE_SIZE,
                              TILE_SIZE,
                              Land.TileSheet:getDimensions()
                              )
    id = id + 1
    end
  end
  
end

function Land.Draw()
  local c, l
  for l = 1, MAP_HEIGHT do
    for c = 1, MAP_WIDTH do
      local id = Land.Map[l][c] -- gather the id in the map table
      local texQuad = Land.TileTextures[id] -- gather the texture of this id
      if texQuad ~= nil then
        love.graphics.draw(Land.TileSheet, texQuad, (c-1)*TILE_SIZE, (l-1)*TILE_SIZE)
      end
    end
  end

  -- show the id tile on the map with the mouse
  local x = love.mouse.getX()
  local y = love.mouse.getY()
  local col = math.floor(x/TILE_SIZE) + 1
  local lin = math.floor(y/TILE_SIZE) + 1
  if col > 0 and col <= MAP_WIDTH and lin > 0 and lin <= MAP_HEIGHT then
    local id = Land.Map[lin][col]
    love.graphics.print("ID: "..tostring(id), 1, 1)
  else
    love.graphics.print("Out of boundary", 1, 1)
  end



end




return Land