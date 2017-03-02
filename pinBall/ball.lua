local Ball = {}

Ball.param = {}
Ball.position = {}

function Ball.Load()
  Ball.src = love.graphics.newImage("pictures/yellowOrbs.png")
  Ball.param.w = Ball.src:getWidth()
  Ball.param.h = Ball.src:getHeight()
  Ball.param.scale = 0.04
  Ball.param.x = 100
  Ball.param.y = 100
  
end

function Ball.Update(dt, pField, ppWindowWidth, ppWindowHeight, pMapWidth, pMapHeight)
  Ball.position.column = math.ceil((Ball.param.x/ppWindowWidth)*pMapWidth)
  Ball.position.line = math.ceil((Ball.param.y/ppWindowHeight)*pMapHeight)
  
  local id = pField.Map.Grid[Ball.position.line][Ball.position.column]
  if not pField.Map.IsSolid(id) then
    Ball.param.y = Ball.param.y + 3
  end
  
  --print(Ball.position.column, Ball.position.line)
  
  
end

function Ball.Draw()
  love.graphics.draw(Ball.src,
                     Ball.param.x, Ball.param.y,
                     0,
                     Ball.param.scale, Ball.param.scale,
                     Ball.param.w/2, Ball.param.h/2)
  
end


return Ball