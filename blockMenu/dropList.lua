local DropList = {}

local cursorPic = nil
local mouseClicked = {}
DropList.listItems = {}
local cursorItem = {}
cursorItem.src = love.graphics.newImage("pictures/cursorDropList_32x32.png")
cursorItem.w = cursorItem.src:getWidth()
cursorItem.h = cursorItem.src:getHeight()

function DropList.Load(pAnchorX, pAnchorY, pDropDownWidth, pFontSize, pContent, pTitle)
  local item = {}
  
  item.id = #DropList.listItems + 1
  item.x = pAnchorX
  item.y = pAnchorY
  item.w = pDropDownWidth
  item.h = pFontSize
  item.isOpen = false
  item.listValues = pContent
  item.title = pTitle
  item.cursorSize = pFontSize/cursorItem.h
  
  table.insert(DropList.listItems, item)  
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

function DropList.Update(pDt)
    
  local i
  for i = 1, #DropList.listItems do
    local thatDropList = DropList.listItems[i]
    if mouseClicked.on == true then
          if mouseClicked.x > thatDropList.x and
             mouseClicked.x < thatDropList.x + thatDropList.w then
               if mouseClicked.y > thatDropList.y and
                  mouseClicked.y < thatDropList.y + thatDropList.h then
                    print("fuck it")
                    mouseClicked.x = 0
                    mouseClicked.y = 0
                    
                  end
                end
              end
            end
      
end

function DropList.Draw()
  
  local i
  for i = 1, #DropList.listItems do
    local thisDropList = DropList.listItems[i]
    
    love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", thisDropList.h))
    
    -- draw the title of the dropList
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf(thisDropList.title, thisDropList.x, thisDropList.y - thisDropList.h * 1.25, thisDropList.w + cursorItem.w, "left")
    
    -- draw the black background
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", thisDropList.x, thisDropList.y, thisDropList.w, thisDropList.h)
    
    -- draw the white outline
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", thisDropList.x, thisDropList.y, thisDropList.w, thisDropList.h)
    
    -- draw the cursor
    love.graphics.draw(cursorItem.src,
                       thisDropList.x + thisDropList.w + 2, thisDropList.y,
                       0,
                       thisDropList.cursorSize, thisDropList.cursorSize)
                     
    love.graphics.printf("800 x 600", thisDropList.x, thisDropList.y - 2, thisDropList.w, "center")
    
  end
end

return DropList