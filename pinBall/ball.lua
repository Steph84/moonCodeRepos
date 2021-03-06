local Ball = {}

Ball.param = {}
Ball.position = {}
local leftCollision = false
local rightCollision = false

-- manage the collision between the ball and a flipper
function Ball.Bounce(flipX1, flipX2, flipY1, flipY2, ballX, ballY, ballW, ballH, ballSc) --flip left part X1Y1; flip right part X2/Y2
  if (ballX + ballW*ballSc/2) < flipX2 and (ballX + ballW*ballSc/2) > flipX1 then -- if the ball is in the good range along x
    local coeffDir = (flipY2 - flipY1)/(flipX2 - flipX1) -- calculate the gradient
    local ordOrig = flipY1 - (coeffDir*flipX1) -- calculate the y-intercept
    if ordOrig == math.huge then ordOrig = flipY1 end -- to manage infinite result
    local ballYTheoric = coeffDir * ballX + ordOrig -- with x calculate the y on the line
    if (ballY + ballH*ballSc/2) > ballYTheoric then return true end -- if the ball is under the line then collision
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
  
  -- calculate the coordinate in case coordinate system
  -- for the wall collision but didn't use it actually
  --Ball.position.column = math.ceil((Ball.param.x/ppWindowWidth)*pMapWidth)
  --Ball.position.line = math.ceil((Ball.param.y/ppWindowHeight)*pMapHeight)
  
  -- movement of the ball
  Ball.param.x = Ball.param.x + Ball.param.vx
  Ball.param.y = Ball.param.y + Ball.param.vy
  
  -- cheat impulse for the ball
  if love.keyboard.isDown("space") then
    Ball.param.vx = -2
    Ball.param.vy = -5
  end
  
  -- if the ball hit the walls then bounces
  if Ball.param.x < (0 + pTILE_SIZE + (Ball.param.w*Ball.param.scale)/2) or
     Ball.param.x > (ppWindowWidth - pTILE_SIZE - (Ball.param.w*Ball.param.scale)/2) then
       Ball.param.vx = 0 - Ball.param.vx
  end
  if Ball.param.y < (0 + pTILE_SIZE + (Ball.param.h*Ball.param.scale)/2) or
     Ball.param.y > (ppWindowHeight - pTILE_SIZE - (Ball.param.h*Ball.param.scale)/2) then
       Ball.param.vy = 0 - Ball.param.vy
  end
  
  -- fall of the ball, just gravity not inclined plane
  Ball.param.vy = Ball.param.vy + 9.81*dt
  
  -- call the function for the ball/flipper collision
  local isLeftFlipCollision = Ball.Bounce(myField.Flipper.leftX, myField.Flipper.leftEndX,
                                          myField.Flipper.leftY, myField.Flipper.leftEndY,
                                          Ball.param.x, Ball.param.y,
                                          Ball.param.w, Ball.param.h, Ball.param.scale)
            
  local isRightFlipCollision = Ball.Bounce(myField.Flipper.rightEndX, myField.Flipper.rightX,
                                           myField.Flipper.rightEndY, myField.Flipper.rightY,
                                           Ball.param.x, Ball.param.y,
                                           Ball.param.w, Ball.param.h, Ball.param.scale)
  
  -- rebound from the flippers collision
  if isLeftFlipCollision == true then Ball.param.vy = 0 - Ball.param.vy end
  if isRightFlipCollision == true then Ball.param.vy = 0 - Ball.param.vy end
  
end

function Ball.Draw()
  love.graphics.draw(Ball.src,
                     Ball.param.x, Ball.param.y,
                     0,
                     Ball.param.scale, Ball.param.scale,
                     Ball.param.w/2, Ball.param.h/2)
end

return Ball