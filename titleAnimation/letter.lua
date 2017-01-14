local myMenu = require("menu")

local Letter = {}

local tile8 = love.graphics.newImage("pictures/titleTile8x8.png")
local tile16 = love.graphics.newImage("pictures/coloredBall_16x16.png")
local tile32 = love.graphics.newImage("pictures/titleTile32x32.png")

local list_pieces = {}

local numPieces = 500
local freeThreshold = 5
local letterSpeed = 2
local gloX = 0
local gloY = 0

function createPiece(pId, pSprite, pX, pY, pRotate)
  local piece = {}
  local tempRandVX = 0
  local tempRandVY = 0
  
  -- to start randomly except
  -- stagnation 0, 0
  -- and vertical and horizontal
  while tempRandVY == 0 do
    tempRandVY = math.random(-freeThreshold, freeThreshold)
  end
  while tempRandVX == 0 do
    tempRandVX = math.random(-freeThreshold, freeThreshold)
  end
  
  piece.id = pId
  piece.sprite = pSprite
  piece.x = pX
  piece.y = pY
  piece.rota = pRotate
  piece.vx = tempRandVX
  piece.vy = tempRandVY
  piece.vr = 0.1
  piece.h = pSprite:getHeight()
  piece.w = pSprite:getWidth()
  piece.targetX = nil
  piece.targetY = nil
  table.insert(list_pieces, piece)
  return piece
end

function Letter.Load(pWindowWidth, pWindowHeight)
  local i
  for i = 1, numPieces do
    createPiece(i, tile16, pWindowWidth/2, pWindowHeight/2, i * 20) -- create pieces at the center Big Bang
  end
  
  -- call the menu Load function to determinate the target coordinates for the pieces
  myMenu.Load(pWindowWidth, pWindowHeight, tile16, list_pieces)
end

function Letter.Update(dt, pWindowWidth, pWindowHeight, pTitleDrawing)
  local i
  local tempRand = 0
  
  -- freestyle mode
  if pTitleDrawing == false then
    local sumX = 0
    local sumY = 0
    
    -- behaviour of the tiles
    for i = 1, numPieces do
      -- movement through the screen
      local t = list_pieces[i]
      t.x = t.x + t.vx
      t.y = t.y + t.vy
      t.rota = t.rota + t.vr
      
      -- calculate the coordinates of the tile cloud
      sumX = sumX + t.x
      sumY = sumY + t.y
      gloX = sumX/i
      gloY = sumY/i
      
      -- sides bounce
      local upBound = 0 + t.w
      local downBound = pWindowHeight - t.h
      local rightBound = pWindowWidth - t.w
      local leftBound = 0 + t.h
      if t.y > downBound then
        tempRand = math.random(-freeThreshold, -1)
        t.y = downBound
        t.vy = tempRand
      end
      if t.y < upBound then
        tempRand = math.random(1, freeThreshold)
        t.y = upBound
        t.vy = tempRand
      end
      if t.x > rightBound then
        tempRand = math.random(-freeThreshold, -1)
        t.x = rightBound
        t.vx = tempRand
      end
      if t.x < leftBound then
        tempRand = math.random(1, freeThreshold)
        t.x = leftBound
        t.vx = tempRand
      end
    end
  end

  -- drawing title mode
  if pTitleDrawing == true then
    local sumX = 0
    local sumY = 0
    
    for i = #list_pieces, 1, -1 do -- parse list backward for the removing
      -- movement through the screen
      local t = list_pieces[i]
      t.x = t.x + t.vx
      t.y = t.y + t.vy
      t.rota = t.rota + t.vr
      
      if i <= 121 then -- the extra particules is for the effect
        -- ratio to move the particule directly to the target
        local tempRatio = math.abs((t.targetY - t.y)/(t.targetX - t.x))
        
        -- glut to avoid the zero division : nan !!
        -- otherwise, particules simply will disapear
        if tempRatio > 2 then
          tempRatio = 2
        end
        
        -- each particule are going to their target
        if t.x > (t.targetX + t.w) then t.vx = -letterSpeed end
        if t.x < (t.targetX - t.w) then t.vx = letterSpeed end
        if t.y > (t.targetY + t.h) then t.vy = -letterSpeed*tempRatio end
        if t.y < (t.targetY - t.h) then t.vy = letterSpeed*tempRatio end
        
        -- near their target, we just fix the coordiinate values
        if t.x < (t.targetX + 3) and t.x > (t.targetX - 3) then
          t.x = t.targetX
          t.vx = 0
        end
        if t.y < (t.targetY + 3) and t.y > (t.targetY - 3) then
          t.y = t.targetY
          t.vy = 0
        end
      end
      
      -- for the extra particules, I just remove them
      if i > 121 then
        if t.x < 0 then table.remove(list_pieces, i) end
        if t.x > pWindowHeight then table.remove(list_pieces, i) end
        if t.y < 0 then table.remove(list_pieces, i) end
        if t.y > pWindowWidth then table.remove(list_pieces, i) end
      end
    end
  end

  
  
end

function Letter.Draw(pTitleDrawing)
  local i
  for i = 1, #list_pieces do
    local t = list_pieces[i]
    love.graphics.draw(t.sprite, t.x, t.y, t.rota, 1, 1, t.w/2, t.h/2)
    --love.graphics.print(i, t.x + 5, t.y + 5)
  end
  
  --love.graphics.print("number of pieces "..#list_pieces, 5, 5)
  
  -- draw the global center in white
  if pTitleDrawing == false then
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", gloX, gloY, 10, 6)
  end
end

return Letter