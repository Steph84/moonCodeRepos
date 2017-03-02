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

function Ball.Update(dt, pField, ppWindowWidth, ppWindowHeight, pTileSize)
  Ball.param.y = Ball.param.y + 3
  Ball.position.column = math.floor((Ball.param.x/ppWindowWidth)*pTileSize)
  Ball.position.line = math.floor((Ball.param.y/ppWindowHeight)*pTileSize)
  print(Ball.position.column, Ball.position.line)
  
  
  
  --[[
  local id = pField.Map.Grid[Ball.param.x][Ball.param.y]
    if pField.isSolid(id) then
      print("collision avec une tuile solide !!")
    end
  --]]
end

function Ball.Draw()
  love.graphics.draw(Ball.src, Ball.param.x, Ball.param.y, 0, Ball.param.scale, Ball.param.scale)
end


return Ball