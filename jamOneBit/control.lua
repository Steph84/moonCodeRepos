local Control = {}

local buttonPics = {}
buttonPics.tileSheet = {}
buttonPics.tileTextures = {}
local tileWidth = 96
local tileHeight = 48

local listButtons = {}
local buttonUp, buttonDown
local mouseClicked = {} 
local animeButton = false

function CreateButton(pId, pppWindowHeight)
  local item = {}
  
  item.id = pId
  if pId > 2 then item.x = - 50 + pId * 150 end
  if pId < 3 then item.x = - 70 + pId * 150 end
  item.y = pppWindowHeight - 64/2 -- height of the bar menu
  item.isEnabled = false
  item.position = "up"
  
  table.insert(listButtons, item)
end

function Control.Load()
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
  
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    mouseClicked.on = true
    mouseClicked.x = x
    mouseClicked.y = y
  end
end

function Control.Update(ppDt, pIncrement, ppWindowHeight)
  if pIncrement > 10 and #listButtons < 6 then
    CreateButton(1, ppWindowHeight)
    CreateButton(2, ppWindowHeight)
    CreateButton(3, ppWindowHeight)
    CreateButton(4, ppWindowHeight)
    CreateButton(5, ppWindowHeight)
    CreateButton(6, ppWindowHeight)
  end
end

function Control.Draw()
  love.graphics.setColor(255, 255, 255)
  local i
  for i = 1, #listButtons do
    local b = listButtons[i]
    love.graphics.draw(buttonPics.tileSheet, buttonPics.tileTextures[b.id],
                       b.x, b.y,
                       0, 1, 1,
                       tileWidth/2, tileHeight/2)
  
  
  end
end

return Control
