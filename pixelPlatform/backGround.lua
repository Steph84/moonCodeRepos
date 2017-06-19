local BackGround = {}

function BackGround.Load()
  BackGround.layer1 = love.graphics.newImage("pictures/backGround.png")
end

function BackGround.Draw()
  love.graphics.draw(BackGround.layer1, 0, 0)
end

return BackGround