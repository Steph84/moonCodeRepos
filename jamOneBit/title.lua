local Title = {}

local bgPic = nil

function Title.Load()
  bgPic = love.graphics.newImage("pictures/oneBitTitle.png")
end

function Title.Draw()
  love.graphics.draw(bgPic, 0, 0)
end

return Title