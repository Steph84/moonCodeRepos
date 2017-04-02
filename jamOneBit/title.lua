local Title = {}

local bgPic = nil
local buttonPics = {}
local buttonStand = {}
local buttonPressed = {}

function Title.Load()
  bgPic = love.graphics.newImage("pictures/oneBitTitle.png")
  buttonPics = love.graphics.newImage("pictures/oneBitTitleButtons.png")
  buttonStand = love.graphics.newQuad(0, 0, 256, 64, buttonPics:getDimensions())
  buttonPressed = love.graphics.newQuad(0, 64, 256, 64, buttonPics:getDimensions())
end

function Title.Draw(pWindowWidth)
  love.graphics.draw(bgPic, 0, 0)
  love.graphics.draw(buttonPics, buttonStand,
                     pWindowWidth/2, 550,
                     0, 1, 1,
                     256/2, 64/2)
  -- TODO if button clicked then change pic to buttonPressed
  -- wait a little bit then switch to following screen

end

return Title