local Game = {}

local castlePic

function Game.Load()
  castlePic = love.graphics.newImage("pictures/castleMap.png")
  print("load game")
end

function Game.Draw()
  print("draw game")
  love.graphics.draw(castlePic, 0, 0)
end

return Game