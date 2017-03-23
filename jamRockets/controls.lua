local Controls = {}

local listButtons = {}

local selection = {}

function Controls.Load()
  selection.x = 0
  selection.y = 0
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    selection.x = x
    selection.y = y
  end
end

function Controls.Update(ppDt, pCanPlay, pForceHome)
  
  -- manage the creation of the buttons
  if pCanPlay == true and #listButtons ~= 4 then
    local i
    for i = 1, 4 do
      local item = {}
      item.id = i + 1
      item.x = 30 + 50 * i
      item.y = 50
      item.w = 30
      item.h = 30
      table.insert(listButtons, item)
    end
  end
  
  -- manage the button selection
  if pCanPlay == true then
    local i
    for i = #listButtons, 1, -1 do
      local b = listButtons[i]
      if selection.x > b.x and selection.x < (b.x + b.w) then
        if selection.y > b.y and selection.y < (b.y + b.h) then
          pCanPlay = false
          pForceHome = b.id
        end
      end
    end
  end
  
  -- erase the buttons
  if pCanPlay == false then
    local i
    for i = #listButtons, 1, -1 do
      table.remove(listButtons, i)
    end
    selection.x = 0
    selection.y = 0
  end
  
  return pCanPlay, pForceHome
end

function Controls.Draw()
  local i
  for i = 1, #listButtons do
    local b = listButtons[i]
    love.graphics.setColor(0, 0, 255)
    love.graphics.rectangle("fill", b.x, b.y, b.w, b.h) -- draw the buttons
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(b.id, b.x + 10, b.y + 9) -- draw the force value
  end
  love.graphics.setColor(255, 255, 255)
end


return Controls