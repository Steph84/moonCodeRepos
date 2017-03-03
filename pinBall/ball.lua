local Ball = {}

Ball.param = {}
Ball.position = {}

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

function Ball.Update(dt, pField, ppWindowWidth, ppWindowHeight, pMapWidth, pMapHeight, pTILE_SIZE)
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
  
  
  
end

function Ball.Draw()
  love.graphics.draw(Ball.src,
                     Ball.param.x, Ball.param.y,
                     0,
                     Ball.param.scale, Ball.param.scale,
                     Ball.param.w/2, Ball.param.h/2)
  
end

return Ball