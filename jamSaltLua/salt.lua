local Salt = {}

local TILE_SIZE = 32
Salt.tileTextures = {}
Salt.pictures = {}

local listSalts = {}

function createSalt(pId, pX, pY)
  local item = {}
  
  item.id = pId
  item.x = pX
  item.y = pY
  item.picCurrent = 1
  
  table.insert(listSalts, item)
  
  return item
end

function Salt.Load()
  
  Salt.tileSheet = love.graphics.newImage("pictures/saltx32.png")
  local nbColumns = Salt.tileSheet:getWidth() / TILE_SIZE -- width 256 8
  local nbLines = Salt.tileSheet:getHeight() / TILE_SIZE -- height 32 1
  
  local l, c
  local id = 1
  Salt.tileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    Salt.tileTextures[id] = love.graphics.newQuad(
                              (c-1)*TILE_SIZE,
                              (l-1)*TILE_SIZE,
                              TILE_SIZE,
                              TILE_SIZE,
                              Salt.tileSheet:getDimensions()
                              )
    id = id + 1
    end
  end
  
  local n
  for n = 1, nbColumns do
    Salt.pictures[n] = Salt.tileTextures[n]
  end
  
  createSalt(1, 100, 100)
  
end

function Salt.Update(pDt)
  if #listSalts > 0 then
    print("dell")
    local i
    for i = #listSalts, 1, -1 do
      local f = listSalts[i]
      f.picCurrent = f.picCurrent + (12 * pDt)
      
      if math.floor(f.picCurrent) > #Salt.pictures then
        f.picCurrent = 1
      end
    end
  end
end

function Salt.Draw()
  local i
  for i = #listSalts, 1, -1 do
    local g = listSalts[i]
    love.graphics.draw(Salt.tileSheet, Salt.pictures[math.floor(g.picCurrent)], g.x, g.y)
  end
end

return Salt