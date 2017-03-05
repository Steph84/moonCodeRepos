local Ball = {}

Ball.param = {}
Ball.position = {}
local leftCollision = false
local rightCollision = false

function Ball.Collide(a1X, a1Y, a1W, a1H, a2X, a2Y, a2W, a2H)
  -- calcul du delta selon x et y
  local dx = a1X - a2X
  local dy = a1Y - a2Y
  --si le delta < la somme des dimensions de l image de chaque objet
  if (math.abs(dx) < a1W+a2W) then
    if (math.abs(dy) < a1H+a2H) then
      -- si les 2 condition sont verifiees --> collision
      return true
    end
  end
  -- si uniquement la premiere condition est verifiee --> pas de collision
  return false
end

function Ball.Bounce(flipX1, flipX2, flipY1, flipY2, ballX, ballY)
  if ballX < flipX2 and ballX > flipX1 then
    local coeffDir = (flipY2 - flipY1)/(flipX2 - flipX1)
    local ordOrig = flipY1/(coeffDir*flipX1)
    
    local ballYTheoric = coeffDir * ballX + ordOrig
    if ballYTheoric - ballY > 0 then return true end
  end
  return false
end

function Ball.Load()
  Ball.src = love.graphics.newImage("pictures/yellowOrbs.png")
  Ball.param.w = Ball.src:getWidth()
  Ball.param.h = Ball.src:getHeight()
  Ball.param.scale = 0.04
  Ball.param.x = 200
  Ball.param.y = 300
  Ball.param.vx = 0
  Ball.param.vy = 0
  
end

function Ball.Update(dt, pField, ppWindowWidth, ppWindowHeight, pMapWidth, pMapHeight, pTILE_SIZE, myField)
  Ball.position.column = math.ceil((Ball.param.x/ppWindowWidth)*pMapWidth)
  Ball.position.line = math.ceil((Ball.param.y/ppWindowHeight)*pMapHeight)
  
  Ball.param.x = Ball.param.x + Ball.param.vx
  Ball.param.y = Ball.param.y + Ball.param.vy
  
  
  if love.keyboard.isDown("space") then
    Ball.param.vx = -2
    Ball.param.vy = -5
  end
  
  --[[
  local id = pField.Map.Grid[Ball.position.line][Ball.position.column]
  if pField.Map.IsSolid(id) then
  end
--]]
  
  if Ball.param.x < (0 + pTILE_SIZE + (Ball.param.w*Ball.param.scale)/2) or
     Ball.param.x > (ppWindowWidth - pTILE_SIZE - (Ball.param.w*Ball.param.scale)/2) then
       Ball.param.vx = 0 - Ball.param.vx
  end
  
  if Ball.param.y < (0 + pTILE_SIZE + (Ball.param.h*Ball.param.scale)/2) or
     Ball.param.y > (ppWindowHeight - pTILE_SIZE - (Ball.param.h*Ball.param.scale)/2) then
       Ball.param.vy = 0 - Ball.param.vy
  end
  
  Ball.param.vy = Ball.param.vy + 9.81*dt
  
  --[[
  leftCollision = Ball.Collide(myField.Flipper.leftX, myField.Flipper.leftY, myField.Flipper.w, myField.Flipper.h,
                               Ball.param.x, Ball.param.y, (Ball.param.w*Ball.param.scale)/2, (Ball.param.h*Ball.param.scale)/2)
  if leftCollision == true then Ball.param.vy = 0 - Ball.param.vy end
  --]]
  
  local truc = Ball.Bounce(myField.Flipper.leftX, myField.Flipper.leftEndX,
              myField.Flipper.leftY, myField.Flipper.leftEndY,
              Ball.param.x, Ball.param.y)
            
  local machin = Ball.Bounce(myField.Flipper.rightEndX, myField.Flipper.rightX,
              myField.Flipper.rightEndY, myField.Flipper.rightY,
              Ball.param.x, Ball.param.y)
  
  print(truc, machin)
  
end

function Ball.Draw()
  love.graphics.draw(Ball.src,
                     Ball.param.x, Ball.param.y,
                     0,
                     Ball.param.scale, Ball.param.scale,
                     Ball.param.w/2, Ball.param.h/2)
  
end

return Ball