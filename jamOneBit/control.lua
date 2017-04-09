local Control = {}

local buttonPics = {}
buttonPics.tileSheet = {}
buttonPics.tileTextures = {}
local tileWidth = 96
local tileHeight = 48

local listButtons = {}
local mouseClicked = {}

function CreateButton(pId, pppWindowHeight)
  local item = {}
  
  item.id = pId
  if pId > 2 then item.x = - 50 + pId * 150 end
  if pId < 3 then item.x = - 70 + pId * 150 end
  item.y = pppWindowHeight - 64/2 -- height of the bar menu
  if pId == 1 then item.isEnabled = true else item.isEnabled = false end
  item.position = "up"
  
  table.insert(listButtons, item)
end

function Control.Load(ppWindowHeight)
  buttonPics.tileSheet = love.graphics.newImage("pictures/buttonsTileSheet.png")
  
  -- get all the tiles in the tile sheet
  local l, c
  local id = 1
  local nbLines = 2
  local nbColumns = 6
  buttonPics.tileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    buttonPics.tileTextures[id] = love.graphics.newQuad(
                              (c-1)*tileWidth,
                              (l-1)*tileHeight,
                              tileWidth,
                              tileHeight,
                              buttonPics.tileSheet:getDimensions()
                              )
    id = id + 1
    end
  end
  
  
  local j
  for j = 1, 6 do
    CreateButton(j, ppWindowHeight)
  end
  
  
  
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    mouseClicked.on = true
    mouseClicked.x = x
    mouseClicked.y = y
  end
end

function love.mousereleased(x, y, button, istouch)
  if button == 1 then
    mouseClicked.on = false
    mouseClicked.x = nil
    mouseClicked.y = nil
  end
end

function Control.Update(ppDt, pIncrement)
  
  local i
  for i = 1, #listButtons do
    local b = listButtons[i]
    --if b.isEnabled == true then -- if the button is showing
      if mouseClicked.on == true then -- if the player click
        if mouseClicked.x > b.x - tileWidth/2 and
           mouseClicked.x < b.x + tileWidth/2 then
             if mouseClicked.y > b.y - tileHeight/2 and
                mouseClicked.y < b.y + tileHeight/2 then
                  b.position = "down" -- if the button is clicked, button down
                  if b.id == 1 then pIncrement = pIncrement + 1 end
             end
        end
      else b.position = "up" end -- if the player doesn t click, button back up
    --end
  end
  
  return pIncrement
end

function Control.Draw()
  love.graphics.setColor(255, 255, 255)
  local i
  for i = 1, #listButtons do
    local b = listButtons[i]
    -- manage the showing of the button
    --if b.isEnabled == true then
      local tempTextId
      -- manage the animation up and down of the button
      if b.position == "up" then tempTextId = b.id elseif b.position == "down" then tempTextId = b.id + 6 end
      
      love.graphics.draw(buttonPics.tileSheet, buttonPics.tileTextures[tempTextId],
                         b.x, b.y,
                         0, 1, 1,
                         tileWidth/2, tileHeight/2)
    --end
  
  end
end

return Control