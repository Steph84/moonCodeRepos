-- initialiser le random
math.randomseed(os.time())
local Control = {}

local buttonPics = {}
buttonPics.tileSheet = {}
buttonPics.tileTextures = {}
local tileWidth = 96
local tileHeight = 48

local peoplePics = {}

local listButtons = {}
local listPeople = {}
local mouseClicked = {}

local peopleCost = 10
local peopleIncome = 10
local peopleTime = 1
local timeElapsed = 0

local wallLvl1Cost = 10
local wallLvl2Cost = 20
local wallLvl4Cost = 40
local wallLvl8Cost = 80


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

function CreatePeople(pId)
  local item = {}
  
  item.id = pId
  -- 1st row Id 1, 2, 3, 4
  if pId < 5 then
    item.x = 85 + pId * 30
    item.y = 100
  end
  -- 2nd row Id 5, 6, 7, 8
  if pId > 4 and pId < 9 then
    item.x = 85 + (pId - 4) * 30
    item.y = 100 + 1 * 70
  end
  -- 3rd row Id 9, 10, 11, 12
  if pId > 8 and pId < 13 then
    item.x = 85 + (pId - 8) * 30
    item.y = 100 + 2 * 70
  end
  -- 4th row Id 13, 14, 15, 16
  if pId > 12 and pId < 17 then
    item.x = 85 + (pId - 12) * 30
    item.y = 100 + 3 * 70
  end
  -- 5th row Id 17, 18, 19, 20
  if pId > 16 and pId < 21 then
    item.x = 85 + (pId - 16) * 30
    item.y = 100 + 4 * 70
  end
  -- 6th row Id 21, 22, 23, 24
  if pId > 20 and pId < 25 then
    item.x = 85 + (pId - 20) * 30
    item.y = 100 + 5 * 70
  end
  
  local gender = math.random(1, 2)
  if gender == 1 then item.gender = "male" else item.gender = "female" end
  
  table.insert(listPeople, item)
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
  
  peoplePics.male = love.graphics.newImage("pictures/maleBlack.png")
  peoplePics.female = love.graphics.newImage("pictures/femaleBlack.png")
  
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

function Control.Update(ppDt, pIncrement, pWallSignal, pWallLevel)
  local i
  for i = 1, #listButtons do
    local b = listButtons[i]
    if b.isEnabled == true then -- if the button is showing
      -- if the player click
      -- have to stay here to keep the animation
      if mouseClicked.on == true then
        if mouseClicked.x > b.x - tileWidth/2 and
           mouseClicked.x < b.x + tileWidth/2 then
             if mouseClicked.y > b.y - tileHeight/2 and
                mouseClicked.y < b.y + tileHeight/2 then
                  
                  b.position = "down" -- if the button is clicked, button down
                  
                  if b.id == 1 then
                    pIncrement = pIncrement + 1
                    -- to stop increment without stopping animation
                    mouseClicked.x = 0
                    mouseClicked.y = 0
                  end
                  
                  if b.id == 2 then
                    pIncrement = pIncrement - peopleCost
                    CreatePeople(#listPeople + 1)
                    mouseClicked.x = 0
                    mouseClicked.y = 0
                  end
                  
                  if b.id == 3 then
                    pIncrement = pIncrement - wallLvl1Cost
                    pWallSignal = true
                    pWallLevel = 1
                    mouseClicked.x = 0
                    mouseClicked.y = 0
                  end
                  
                  if b.id == 4 then
                    pIncrement = pIncrement - wallLvl2Cost
                    pWallSignal = true
                    pWallLevel = 2
                    mouseClicked.x = 0
                    mouseClicked.y = 0
                  end
                  
                  if b.id == 5 then
                    pIncrement = pIncrement - wallLvl4Cost
                    pWallSignal = true
                    pWallLevel = 4
                    mouseClicked.x = 0
                    mouseClicked.y = 0
                  end
                  
                  if b.id == 6 then
                    pIncrement = pIncrement - wallLvl8Cost
                    pWallSignal = true
                    pWallLevel = 8
                    mouseClicked.x = 0
                    mouseClicked.y = 0
                  end
                  
             end
        end
      else b.position = "up" end -- if the player doesn t click, button back up
    end
  end
  
  -- manage the people button
  if pIncrement > peopleCost and #listPeople < 24 then listButtons[2].isEnabled = true else listButtons[2].isEnabled = false end
  if #listPeople > 0 then timeElapsed = timeElapsed + ppDt end
  if timeElapsed > peopleTime then
    pIncrement = pIncrement + #listPeople * peopleIncome
    timeElapsed = 0
  end
  
  -- manage the wall buttons
  if pIncrement > wallLvl1Cost then listButtons[3].isEnabled = true else listButtons[3].isEnabled = false end
  if pIncrement > wallLvl2Cost then listButtons[4].isEnabled = true else listButtons[4].isEnabled = false end
  if pIncrement > wallLvl4Cost then listButtons[5].isEnabled = true else listButtons[5].isEnabled = false end
  if pIncrement > wallLvl8Cost then listButtons[6].isEnabled = true else listButtons[6].isEnabled = false end
  
  return pIncrement, pWallSignal, pWallLevel
end

function Control.Draw()
  love.graphics.setColor(255, 255, 255)
  local i
  for i = 1, #listButtons do
    local b = listButtons[i]
    -- manage the showing of the button
    if b.isEnabled == true then
      local tempTextId
      -- manage the animation up and down of the button
      if b.position == "up" then tempTextId = b.id elseif b.position == "down" then tempTextId = b.id + 6 end
      
      love.graphics.draw(buttonPics.tileSheet, buttonPics.tileTextures[tempTextId],
                         b.x, b.y,
                         0, 1, 1,
                         tileWidth/2, tileHeight/2)
    end
  end
  
  local j
  for j = 1, #listPeople do
    local p = listPeople[j]
    if p.gender == "male" then love.graphics.draw(peoplePics.male, p.x, p.y) end
    if p.gender == "female" then love.graphics.draw(peoplePics.female, p.x, p.y) end
  end
end

return Control