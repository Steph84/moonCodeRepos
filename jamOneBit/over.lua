local Over = {}

function Over.Draw(pWindowWidth, pWindowHeight)
  love.graphics.setBackgroundColor(255, 255, 255)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("GAME OVER", pWindowWidth/2 - 140, pWindowHeight/2, 0, 3, 3)
end

return Over