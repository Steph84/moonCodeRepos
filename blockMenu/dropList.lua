local DropList = {}
DropList.listItems = {} -- list of dropList items

local myMouse = require("mouseControls")

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
local myListItems = require("dropListItems")

-- create all the dropLists called by the options menu
function DropList.Load(pTitle, pDataList, pSelected, pAnchorX, pAnchorY, pDropDownWidth, pFontSize)
  local item = {}
  item.cursor = {}
  
  item.id = #DropList.listItems + 1
  item.x = pAnchorX
  item.y = pAnchorY
  item.w = pDropDownWidth
  item.h = pFontSize
  item.isOpen = false
  item.listValues = pDataList
  -- get the data type
  item.type = #item.listValues[1]
  item.title = pTitle
  item.cursorSize = pFontSize/cursorItem.h
  item.selected = pSelected
  
  item.cursor.x = item.x + item.w
  item.cursor.y = item.y
  item.cursor.w = item.cursorSize * 32
  item.cursor.h = item.cursorSize * 32
  
  table.insert(DropList.listItems, item)  
end

function DropList.Update(dt, pData)
  
  local i
  for i = 1, #DropList.listItems do
    local thatDropList = DropList.listItems[i]
    
    -- manage the dropList opening
    if thatDropList.isOpen == false then
      local dropOpening1 = myMouse.ClickOnObject(thatDropList)
      local dropOpening2 = myMouse.ClickOnObject(thatDropList.cursor)
      if dropOpening1 == true or dropOpening2 == true then
        thatDropList.isOpen = true
      end
    end
    
    -- manage the opened dropList
    if thatDropList.isOpen == true then
      
      thatDropList.h = thatDropList.h * #thatDropList.listValues -- extend the height of the item
      local isHovering = false
      isHovering, selection.x, selection.y = myMouse.HoverOnObject(thatDropList)
      thatDropList.h = thatDropList.h / #thatDropList.listValues -- item height back to normal
      
      if isHovering == true then
        selection.highlight = true
        selection.position = math.floor((selection.y - thatDropList.y) / thatDropList.h)
        
        -- manage to select the new item in the list and close the dropList
        if myMouse.clicked == true then
          thatDropList.selected = selection.position + 1
          pData = thatDropList.selected
          thatDropList.isOpen = false
          myMouse.clicked = false -- avoid stay open if click on the actual selection
        end
        
      else selection.highlight = false
      end
    end
  
  end
  
  
  return pData
end

function DropList.Draw()
  
  local i
  for i = 1, #DropList.listItems do
    local thisDropList = DropList.listItems[i]
    
    love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", thisDropList.h))
    
    -- draw the title of the dropList
    love.graphics.setColor(colorDropList.white)
    love.graphics.printf(thisDropList.title,
                         thisDropList.x, thisDropList.y - thisDropList.h * 1.25,
                         thisDropList.w,
                         "left")
    
    -- draw the cursor
    love.graphics.draw(cursorItem.src,
                       thisDropList.cursor.x + 2, thisDropList.cursor.y,
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
      
      if thisDropList.type == 2 then
        love.graphics.printf(
          thisDropList.listValues[thisDropList.selected][1].." x "..thisDropList.listValues[thisDropList.selected][2],
          thisDropList.x, thisDropList.y - 2,
          thisDropList.w, "center")
      end
      
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
        
        if thisDropList.type == 2 then
          love.graphics.printf(value[1].." x "..value[2],
                               thisDropList.x, thisDropList.y - 2 + thisDropList.h * (j - 1),
                               thisDropList.w, "center")
        end
        
      end
      
    end
    
  end
  
end

return DropList