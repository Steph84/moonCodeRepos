local Salt = {}

local TILE_SIZE = 32
Salt.tileTextures = {}
Salt.pictures = {}
Salt.ctrl = {}

Salt.listSalts = {}

local whiteColor = {255, 255, 255}

function createSalt(pId, pX, pY)
  local item = {}
  
  item.id = pId
  item.x = pX
  item.y = pY
  item.picCurrent = 1
  item.circRad = 1
  item.alpha = 255
  
  table.insert(Salt.listSalts, item)
  
  return item
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    Salt.ctrl.x = x
    Salt.ctrl.y = y
  end
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
  
  Salt.ctrl.x = 0
  Salt.ctrl.y = 0
  
end

function Salt.Update(pDt)
  if #Salt.listSalts > 0 then
    local i
    for i = #Salt.listSalts, 1, -1 do
      local f = Salt.listSalts[i]
      f.picCurrent = f.picCurrent + (9 * pDt)
      
      if math.floor(f.picCurrent) > #Salt.pictures then
        f.picCurrent = 1
      end
      
      if f.alpha > 0 then f.alpha = f.alpha - 30 * pDt end
      
    end
  end
  
  if Salt.ctrl.x ~= 0 and Salt.ctrl.y ~= 0 then
    createSalt(#Salt.listSalts + 1 ,Salt.ctrl.x - 32/2, Salt.ctrl.y - 32/2)
    Salt.ctrl.x = 0
    Salt.ctrl.y = 0
  end
    
end

function Salt.Draw()
  local i
  for i = #Salt.listSalts, 1, -1 do
    local g = Salt.listSalts[i]
    love.graphics.setColor(whiteColor[1], whiteColor[2], whiteColor[3], g.alpha)
    love.graphics.draw(Salt.tileSheet, Salt.pictures[math.floor(g.picCurrent)], g.x, g.y)
  end
end

return Salt