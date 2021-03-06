io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 675 -- default value

local pics = {}
pics.bg = {}
pics.sack = {}
pics.leaf = {}
pics.emCu = {}
pics.fuCu = {}
pics.tePo = {}
pics.waBo = {}

local cooker = {}
local table = {}

local sequence = {leaves = false, water = false, hot = false, cup = false, served = false}
local teaPotOnCooker = false

local button = 0
local mouseHoldX = 0
local mouseHoldY = 0
local mouseReleaseX = 0
local mouseReleaseY = 0
local holding = "nothing"
local timeElapsed = 0

function love.load()
  -- background and window
  pics.bg.src = love.graphics.newImage("pictures/kitchenBackground.png")
  pics.bg.w = pics.bg.src:getWidth()
  pics.bg.h = pics.bg.src:getHeight()
  local ratio = pics.bg.w/pics.bg.h
  windowWidth = windowHeight * ratio
  pics.bg.scale = pics.bg.h/windowHeight
  
  love.window.setMode(windowWidth, windowHeight)
  
  -- tea sack
  pics.sack.src = love.graphics.newImage("pictures/TeaSack01.png")
  pics.sack.w = pics.sack.src:getWidth()
  pics.sack.h = pics.sack.src:getHeight()
  pics.sack.scale = 5
  pics.sack.coorX = 225
  pics.sack.coorY = 575
  
  -- tea leaves
  pics.leaf.src = love.graphics.newImage("pictures/teaLeaves.png")
  pics.leaf.w = pics.leaf.src:getWidth()
  pics.leaf.h = pics.leaf.src:getHeight()
  pics.leaf.scale = 12
  pics.leaf.coorX = -100
  pics.leaf.coorY = -100
  
  -- empty cup
  pics.emCu.src = love.graphics.newImage("pictures/emptyCup.png")
  pics.emCu.w = pics.emCu.src:getWidth()
  pics.emCu.h = pics.emCu.src:getHeight()
  pics.emCu.scale = 6
  pics.emCu.coorX = 700
  pics.emCu.coorY = 140
  
  -- full cup
  pics.fuCu.src = love.graphics.newImage("pictures/fullCup.png")
  pics.fuCu.w = pics.fuCu.src:getWidth()
  pics.fuCu.h = pics.fuCu.src:getHeight()
  pics.fuCu.scale = 6
  pics.fuCu.coorX = -100
  pics.fuCu.coorY = -100
  
  -- teapot
  pics.tePo.src = love.graphics.newImage("pictures/teaPot.png")
  pics.tePo.w = pics.tePo.src:getWidth()
  pics.tePo.h = pics.tePo.src:getHeight()
  pics.tePo.scale = 3
  pics.tePo.coorX = 875
  pics.tePo.coorY = 200
  
  -- water bottle
  pics.waBo.src = love.graphics.newImage("pictures/bottle.png")
  pics.waBo.w = pics.waBo.src:getWidth()
  pics.waBo.h = pics.waBo.src:getHeight()
  pics.waBo.scale = 0.6
  pics.waBo.coorX = 350
  pics.waBo.coorY = 375
  
  -- cooker area
  cooker.xMin = 435
  cooker.xMax = 435 + 150
  cooker.yMin = 195
  cooker.yMax = 195 + 50
  --love.graphics.rectangle("line", 435, 195, 150, 50)
  
  -- table area
  table.xMin = 180
  table.xMax = 180 + 500
  table.yMin = 335
  table.yMax = 335 + 100
  --love.graphics.rectangle("line", 180, 335, 500, 100)
  
  
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 and holding == "nothing" then
    mouseHoldX = x
    mouseHoldY = y
  end
  if button == 2 and holding ~= "nothing" then
    mouseReleaseX = x
    mouseReleaseY = y
  end
end

function love.update(dt)
  local range = 50
  local cursorX, cursorY
  timeElapsed = timeElapsed + dt

  if holding == "nothing" then
    if mouseHoldX > pics.sack.coorX - range and
     mouseHoldX < pics.sack.coorX + range and
     mouseHoldY > pics.sack.coorY - range and
     mouseHoldY < pics.sack.coorY + range then
        print("you've got the tea leaves")
        holding = "leaves"
        mouseHoldX = 0
        mouseHoldY = 0
    end
    
    if mouseHoldX > pics.tePo.coorX - range and
       mouseHoldX < pics.tePo.coorX + range and
       mouseHoldY > pics.tePo.coorY - range and
       mouseHoldY < pics.tePo.coorY + range then
          print("you've got the teapot")
          holding = "teapot"
          mouseHoldX = 0
          mouseHoldY = 0
          teaPotOnCooker = false
    end
    
    if mouseHoldX > pics.emCu.coorX - range and
       mouseHoldX < pics.emCu.coorX + range and
       mouseHoldY > pics.emCu.coorY - range and
       mouseHoldY < pics.emCu.coorY + range then
          print("you've got the cup")
          holding = "cup"
          mouseHoldX = 0
          mouseHoldY = 0
    end
    
    if mouseHoldX > pics.waBo.coorX - range and
       mouseHoldX < pics.waBo.coorX + range and
       mouseHoldY > pics.waBo.coorY - range and
       mouseHoldY < pics.waBo.coorY + range then
          print("you've got the water bottle")
          holding = "bottle"
          mouseHoldX = 0
          mouseHoldY = 0
    end
  else
    cursorX, cursorY = love.mouse.getPosition()
    if holding == "leaves" then
      pics.leaf.coorX = cursorX
      pics.leaf.coorY = cursorY
      if mouseReleaseX == cursorX and
         mouseReleaseX > pics.tePo.coorX - range and
         mouseReleaseX < pics.tePo.coorX + range and
         mouseReleaseY > pics.tePo.coorY - range and
         mouseReleaseY < pics.tePo.coorY + range then
        print("the tea leaves are in the teapot")
        holding = "nothing"
        pics.leaf.coorX = -100
        pics.leaf.coorY = -100
        sequence.leaves = true
        mouseReleaseX = 0
        mouseReleaseY = 0
      end
    elseif holding == "bottle" then
      pics.waBo.coorX = cursorX
      pics.waBo.coorY = cursorY
      if mouseReleaseX == cursorX and
         mouseReleaseX > pics.tePo.coorX - range and
         mouseReleaseX < pics.tePo.coorX + range and
         mouseReleaseY > pics.tePo.coorY - range and
         mouseReleaseY < pics.tePo.coorY + range then
              print("the water is in the teapot")
              holding = "nothing"
              mouseReleaseX = 0
              mouseReleaseY = 0
              pics.waBo.coorX = -100
              pics.waBo.coorY = -100
              sequence.water = true
      end
    elseif holding == "cup" then
      pics.emCu.coorX = cursorX
      pics.emCu.coorY = cursorY
      if mouseReleaseX > table.xMin and
         mouseReleaseX < table.xMax and
         mouseReleaseY > table.yMin and
         mouseReleaseY < table.yMax then
              print("The cup is on the table")
              pics.emCu.coorX = mouseReleaseX
              pics.emCu.coorY = mouseReleaseY
              holding = "nothing"
              mouseReleaseX = 0
              mouseReleaseY = 0
              sequence.cup = true
      end
    elseif holding == "teapot" then
      pics.tePo.coorX = cursorX
      pics.tePo.coorY = cursorY
      
      if sequence.hot == false and
         sequence.water == true and
         mouseReleaseX > cooker.xMin and
         mouseReleaseX < cooker.xMax and
         mouseReleaseY > cooker.yMin and
         mouseReleaseY < cooker.yMax then
              print("The teapot is on the cooker")
              pics.tePo.coorX = mouseReleaseX
              pics.tePo.coorY = mouseReleaseY
              holding = "nothing"
              mouseReleaseX = 0
              mouseReleaseY = 0
              teaPotOnCooker = true
              timeElapsed = 0
      elseif sequence.hot == false and
             sequence.water == true and
             mouseReleaseX > table.xMin and
             mouseReleaseX < table.xMax and
             mouseReleaseY > table.yMin and
             mouseReleaseY < table.yMax then
                    print("The teapot is on the table")
                    pics.tePo.coorX = mouseReleaseX
                    pics.tePo.coorY = mouseReleaseY
                    holding = "nothing"
                    mouseReleaseX = 0
                    mouseReleaseY = 0
      end
      if sequence.hot == true then
        if sequence.cup == true and
           mouseReleaseX > pics.emCu.coorX - range and
           mouseReleaseX < pics.emCu.coorX + range and
           mouseReleaseY > pics.emCu.coorY - range and
           mouseReleaseY < pics.emCu.coorY + range then
                print("The cup is full")
                sequence.served = true
                pics.emCu.coorX = -100
                pics.emCu.coorY = -100
                pics.fuCu.coorX = mouseReleaseX
                pics.fuCu.coorY = mouseReleaseY
                mouseReleaseX = 0
                mouseReleaseY = 0
        elseif mouseReleaseX > table.xMin and
               mouseReleaseX < table.xMax and
               mouseReleaseY > table.yMin and
               mouseReleaseY < table.yMax then
                    print("The hot teapot is on the table")
                    pics.tePo.coorX = mouseReleaseX
                    pics.tePo.coorY = mouseReleaseY
                    holding = "nothing"
                    mouseReleaseX = 0
                    mouseReleaseY = 0
        end
        
      end
      
    end
    
  end
  
  if sequence.water == true and sequence.hot == false and teaPotOnCooker == true and timeElapsed > 5 then
    print("It's hot")
    sequence.hot = true
  elseif sequence.water == false and sequence.hot == false and teaPotOnCooker == true then
    print("That's not right")
  end
    
    
end

function love.draw()
  love.graphics.draw(pics.bg.src, 0, 0, 0, 1/pics.bg.scale, 1/pics.bg.scale)
  love.graphics.draw(pics.sack.src, pics.sack.coorX, pics.sack.coorY, 0, 1/pics.sack.scale, 1/pics.sack.scale, pics.sack.w/2, pics.sack.h/2)
  love.graphics.draw(pics.emCu.src, pics.emCu.coorX, pics.emCu.coorY, 0, -1/pics.emCu.scale, 1/pics.emCu.scale, pics.emCu.w/2, pics.emCu.h/2)
  love.graphics.draw(pics.fuCu.src, pics.fuCu.coorX, pics.fuCu.coorY, 0, 1/pics.fuCu.scale, 1/pics.fuCu.scale, pics.fuCu.w/2, pics.fuCu.h/2)
  love.graphics.draw(pics.tePo.src, pics.tePo.coorX, pics.tePo.coorY, 0, -1/pics.tePo.scale, 1/pics.tePo.scale, pics.tePo.w/2, pics.tePo.h/2)
  love.graphics.draw(pics.leaf.src, pics.leaf.coorX, pics.leaf.coorY, 0, 1/pics.leaf.scale, 1/pics.leaf.scale, pics.leaf.w/2, pics.leaf.h/2)
  love.graphics.draw(pics.waBo.src, pics.waBo.coorX, pics.waBo.coorY, 0, 1/pics.waBo.scale, 1/pics.waBo.scale, pics.waBo.w/2, pics.waBo.h/2)
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Let's make us some jasmine tea.", windowWidth/3, windowHeight - 60, 0, 1.5, 1.5)
  if sequence.leaves == true and
     sequence.water == true and
     sequence.hot == true and
     sequence.cup == true and
     sequence.served == true then
          love.graphics.print("You've done it. Take a sip.", 30, 30, 0, 1.5, 1.5)
  elseif sequence.served == true then love.graphics.print("Something is not right. Do it again please.", 30, 30, 0, 1.5, 1.5)
  else
    love.graphics.setColor(0, 0, 0)
    if holding == "leaves" then love.graphics.print("You have the tea leaves.", 30, 30, 0, 1.5, 1.5) end
    if holding == "cup" then love.graphics.print("You have the cup.", 30, 30, 0, 1.5, 1.5) end
    if holding == "teapot" then love.graphics.print("You have the teapot.", 30, 30, 0, 1.5, 1.5) end
    if holding == "bottle" then love.graphics.print("You have the bottle.", 30, 30, 0, 1.5, 1.5) end
    if teaPotOnCooker == true then love.graphics.print("The teapot is on the cooker.", 600, 200, 0, 1.5, 1.5) end
    
    if sequence.leaves == true then love.graphics.print("The tea leaves are in the teapot.", 30, 60, 0, 1.5, 1.5) end
    if sequence.water == true then love.graphics.print("The water is in the teapot.", 30, 90, 0, 1.5, 1.5) end
    if sequence.hot == true then love.graphics.print("The teapot is now hot enough.", 30, 120, 0, 1.5, 1.5) end
    if sequence.cup == true then love.graphics.print("The cup is on the table.", 30, 150, 0, 1.5, 1.5) end
  end
  love.graphics.setColor(255, 255, 255)
  
  
end

function love.keypressed(key)
  
  print(key)
  
end