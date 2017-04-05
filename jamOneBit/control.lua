local Control = {}

local wallButtons = {}
local listButtons = {}
local buttonUp, buttonDown
local mouseClicked = {} 
local animeButton = false

function CreateButton(pId, pppWindowHeight)
  local item = {}
  
  item.id = pId
  item.x = 364 -- mini 300
  item.y = pppWindowHeight - 64/2 -- height of the bar menu
  item.lvl = 1 -- 1, 2, 4, or 8
  item.isEnabled = false
  item.position = "up"
  
  table.insert(listButtons, item)
end

function Control.Load()
  wallButtons.src = love.graphics.newImage("pictures/wallButtons.png")
  wallButtons.w = 64
  wallButtons.h = 32
  
  buttonUp = love.graphics.newQuad(0, 0, wallButtons.w, wallButtons.h, wallButtons.src:getDimensions())
  buttonDown = love.graphics.newQuad(0, wallButtons.h, wallButtons.w, wallButtons.h, wallButtons.src:getDimensions())
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    mouseClicked.on = true
    mouseClicked.x = x
    mouseClicked.y = y
  end
end

function Control.Update(ppDt, pIncrement, ppWindowHeight)
  if pIncrement > 10 and #listButtons < 1 then
    CreateButton(1, ppWindowHeight)
  end
end

function Control.Draw()
  love.graphics.setColor(255, 255, 255)
  local i
  for i = 1, #listButtons do
    local b = listButtons[i]
    love.graphics.draw(wallButtons.src, buttonUp,
                       b.x, b.y,
                       0, 1.5, 1.5,
                       wallButtons.w/2, wallButtons.h/2)
                     
      love.graphics.print(b.lvl, b.x - 35, b.y - 10)
  end
end

return Control