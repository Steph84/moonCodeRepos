local myMenu = require("menu")

local Letter = {}

local tile8 = love.graphics.newImage("pictures/titleTile8x8.png")
local tile16 = love.graphics.newImage("pictures/coloredBall_16x16.png")
local tile32 = love.graphics.newImage("pictures/titleTile32x32.png")

local list_pieces = {}

local numPieces = 2
local freeThreshold = 5
local letterSpeed = 2
local gloX = 0
local gloY = 0

function createPiece(pId, pSprite, pX, pY, pRotate)
  local piece = {}
  local tempRandVX = 0
  local tempRandVY = 0
  
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
  local tempRandW = 0
  local tempRandH = 0
  
  for i = 1, numPieces do
    createPiece(i, tile16, pWindowWidth/2, pWindowHeight/2, i * 20)
  end
  
  myMenu.Load(pWindowWidth, pWindowHeight, tile16, list_pieces)
  
  --[[
  list_pieces[1].targetX = 100
  list_pieces[1].targetY = 100
  list_pieces[2].targetX = 400
  list_pieces[2].targetY = 400
  --]]
end

function Letter.Update(dt, pWindowWidth, pWindowHeight, pTitleDrawing)
  local i
  local tempRand = 0
  
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

  if pTitleDrawing == true then
    local sumX = 0
    local sumY = 0
    for i = 1, numPieces do
      -- movement through the screen
      local t = list_pieces[i]
      t.x = t.x + t.vx
      t.y = t.y + t.vy
      t.rota = t.rota + t.vr
      
      -- ratio to move the particule directly to the target
      local tempRatio = math.abs((t.targetY - t.y)/(t.targetX - t.x))
      print(tempRatio)
      
      if t.x > (t.targetX + t.w) then t.vx = -letterSpeed end
      if t.x < (t.targetX - t.w) then t.vx = letterSpeed end
      if t.y > (t.targetY + t.h) then t.vy = -letterSpeed*tempRatio end
      if t.y < (t.targetY - t.h) then t.vy = letterSpeed*tempRatio end
      
      if t.x < (t.targetX + 3) and t.x > (t.targetX - 3) then
        t.vx = 0
        t.x = t.targetX
      end
      if t.y < (t.targetY + 3) and t.y > (t.targetY - 3) then
        t.vy = 0
        t.y = t.targetY
      end
      
    end
  end

  
  
end

function Letter.Draw(pTitleDrawing)
  local i
  for i = 1, numPieces do
    local t = list_pieces[i]
    love.graphics.draw(t.sprite, t.x, t.y, t.rota, 1, 1, t.w/2, t.h/2)
  end
  
  if pTitleDrawing == false then
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", gloX, gloY, 10, 6)
  end
end


return Letter