local DropList = {}
DropList.listItems = {} -- list of dropList items

local mouseClicked = {} -- to manage the mouse control

-- picture of the right cursor
local cursorItem = {}
cursorItem.src = love.graphics.newImage("pictures/cursorDropList_32x32.png")
cursorItem.w = cursorItem.src:getWidth()
cursorItem.h = cursorItem.src:getHeight()

-- to manage the highlight selection
local selection = {}
selection.border = 2

local colorDropList = {}
colorDropList.white = {255, 255, 255}
colorDropList.black = {0, 0, 0}
colorDropList.highlight = {200, 200, 200, 150}

-- to load the data for the dropLists
local myListItems = require("listitems")

-- create all the dropLists called by the options menu
function DropList.Load(pAnchorX, pAnchorY, pDropDownWidth, pFontSize, pContent, pTitle, pSelected)
  local item = {}
  
  item.id = #DropList.listItems + 1
  item.x = pAnchorX
  item.y = pAnchorY
  item.w = pDropDownWidth
  item.h = pFontSize
  item.isOpen = false
  item.listValues = myListItems[pContent]
  item.title = pTitle
  item.cursorSize = pFontSize/cursorItem.h
  item.selected = pSelected
  
  table.insert(DropList.listItems, item)  
end

-- manage the mouse control
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

function DropList.Update(pDt, pData)
  
  local i
  for i = 1, #DropList.listItems do
    local thatDropList = DropList.listItems[i]
    
    -- manage the dropList opening
    if thatDropList.isOpen == false and mouseClicked.on == true then
      if mouseClicked.x > thatDropList.x and             -- (   allow to click on the cursor too     ) 
         mouseClicked.x < thatDropList.x + thatDropList.w + (thatDropList.cursorSize * thatDropList.h) then
           if mouseClicked.y > thatDropList.y and
              mouseClicked.y < thatDropList.y + thatDropList.h then
                thatDropList.isOpen = true
                mouseClicked.on = false -- avoid mouse click repeat
            end
        end
    end
    
    -- manage the opened dropList
    if thatDropList.isOpen == true then
      selection.x, selection.y = love.mouse.getPosition()
      
      if selection.x > thatDropList.x and
         selection.x < thatDropList.x + thatDropList.w and
         selection.y > thatDropList.y and
         selection.y < thatDropList.y + #thatDropList.listValues * thatDropList.h then -- drop all the item in the list
          
          -- manage to higlight the selection
          selection.highlight = true
          selection.position = math.floor((selection.y - thatDropList.y) / thatDropList.h)
          
          -- manage to select the new item in the list and close the dropList
          if mouseClicked.on == true then
            thatDropList.selected = selection.position + 1
            pData = thatDropList.selected
            thatDropList.isOpen = false
          end
          
      else selection.highlight = false
      end
    end
    
    
  end
  
  return pData
end

function DropList.Draw(pWindowWidth)
  
  local i
  for i = 1, #DropList.listItems do
    local thisDropList = DropList.listItems[i]
    
    love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", thisDropList.h))
    
    -- draw the title of the dropList
    love.graphics.setColor(colorDropList.white)
    love.graphics.printf(thisDropList.title,
                         thisDropList.x, thisDropList.y - thisDropList.h * 1.25,
                         pWindowWidth,
                         "left")
    
    -- draw the cursor
    love.graphics.draw(cursorItem.src,
                       thisDropList.x + thisDropList.w + 2, thisDropList.y,
                       0,
                       thisDropList.cursorSize, thisDropList.cursorSize)

    -- manage the draw when the dropList is closed
    if thisDropList.isOpen == false then
      -- draw the black background
      love.graphics.setColor(colorDropList.black)
      love.graphics.rectangle("fill", thisDropList.x, thisDropList.y, thisDropList.w, thisDropList.h)
      
      -- draw the white outline
      love.graphics.setColor(colorDropList.white)
      love.graphics.rectangle("line", thisDropList.x, thisDropList.y, thisDropList.w, thisDropList.h)
      
      love.graphics.printf(
        thisDropList.listValues[thisDropList.selected][1].." x "..thisDropList.listValues[thisDropList.selected][2],
        thisDropList.x, thisDropList.y - 2,
        thisDropList.w, "center")
    end
    
    -- manage the draw when the dropList is opened
    if thisDropList.isOpen == true then
      -- draw the black background
      love.graphics.setColor(colorDropList.black)
      love.graphics.rectangle("fill", thisDropList.x, thisDropList.y, thisDropList.w, thisDropList.h * #thisDropList.listValues)
      
      -- draw the white outline
      love.graphics.setColor(colorDropList.white)
      love.graphics.rectangle("line", thisDropList.x, thisDropList.y, thisDropList.w, thisDropList.h * #thisDropList.listValues)
      
      -- manage the highlight draw
      if selection.highlight == true then
        love.graphics.setColor(colorDropList.highlight)
        love.graphics.rectangle("fill",
                                thisDropList.x + selection.border,
                                (thisDropList.y + selection.position * thisDropList.h) + selection.border,
                                thisDropList.w - 2 * selection.border,
                                thisDropList.h - 2 * selection.border)
      end
      
      
      love.graphics.setColor(colorDropList.white)
      -- draw all the items in the list
      local j
      for j = 1, #thisDropList.listValues do
        local value = thisDropList.listValues[j]
        love.graphics.printf(value[1].." x "..value[2],
                             thisDropList.x, thisDropList.y - 2 +
                             thisDropList.h * (j - 1), thisDropList.w, "center")
      end
      
    end
    
  end
  
end

return DropList