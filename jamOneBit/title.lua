local Title = {}

local bgPic = nil
local buttonPics = {}
local buttonStand = {}
local buttonPressed = {}
local mouseClicked = {} 
local animeButton = false
local timeElapsed = 0

function Title.Load(pWindowWidth)
  bgPic = love.graphics.newImage("pictures/oneBitTitle.png")
  buttonPics.src = love.graphics.newImage("pictures/oneBitTitleButtons.png")
  buttonPics.w = 256
  buttonPics.h = 64
  buttonPics.x = pWindowWidth/2
  buttonPics.y = 550
  
  buttonStand = love.graphics.newQuad(0, 0, buttonPics.w, buttonPics.h, buttonPics.src:getDimensions())
  buttonPressed = love.graphics.newQuad(0, buttonPics.h, buttonPics.w, buttonPics.h, buttonPics.src:getDimensions())
end

--[[
function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    mouseClicked.on = true
    mouseClicked.x = x
    mouseClicked.y = y
  end
end
--]]

function Title.Update(pDt)
  local signal = "title"
  
  -- modification from love.mousepressed to love.mouse.isDown function because it didn t work anymore...
  if love.mouse.isDown(1) then
    if love.mouse.getX() > buttonPics.x - buttonPics.w/2 and
       love.mouse.getX() < buttonPics.x + buttonPics.w/2 then
         if love.mouse.getY() > buttonPics.y - buttonPics.h/2 and
            love.mouse.getY() < buttonPics.y + buttonPics.h/2 then
    
  --[[
  if mouseClicked.on == true then
    if mouseClicked.x > buttonPics.x - buttonPics.w/2 and
       mouseClicked.x < buttonPics.x + buttonPics.w/2 then
         if mouseClicked.y > buttonPics.y - buttonPics.h/2 and
            mouseClicked.y < buttonPics.y + buttonPics.h/2 then
            --]]
              animeButton = true
              --[[
              mouseClicked.x = nil
              mouseClicked.y = nil
              mouseClicked.on = false
              --]]
         end
    end
  end
  
  if animeButton == true then
    timeElapsed = timeElapsed + pDt
    if timeElapsed > 3 then
      signal = "game"
    end
  end
  
  return signal
end

function Title.Draw(pWindowWidth)
  love.graphics.draw(bgPic, 0, 0)
  
  if animeButton == false then
    love.graphics.draw(buttonPics.src, buttonStand,
                       buttonPics.x, buttonPics.y,
                       0, 1, 1,
                       buttonPics.w/2, buttonPics.h/2)
  elseif animeButton == true then
    love.graphics.draw(buttonPics.src, buttonPressed,
                       buttonPics.x, buttonPics.y,
                       0, 1, 1,
                       buttonPics.w/2, buttonPics.h/2)
  end
    -- TODO if button clicked then change pic to buttonPressed
  -- wait a little bit then switch to following screen

end

return Title