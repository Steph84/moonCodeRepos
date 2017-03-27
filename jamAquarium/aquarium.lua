local Aqua = {}

Aqua.background = {}

function Aqua.Load(pWindowWidth, pWindowHeight)
  
  Aqua.background.src = love.graphics.newImage("pictures/underwater.png")
  Aqua.background.w = Aqua.background.src:getWidth() -- 1024
  Aqua.background.h = Aqua.background.src:getHeight() -- 768
  
  Aqua.background.scale = pWindowHeight / Aqua.background.h
  
end


function Aqua.Draw()
  love.graphics.draw(Aqua.background.src, 0, 0, 0, Aqua.background.scale, Aqua.background.scale)
  love.graphics.draw(Aqua.background.src, Aqua.background.w * Aqua.background.scale, 0, 0, Aqua.background.scale, Aqua.background.scale)
end

return Aqua