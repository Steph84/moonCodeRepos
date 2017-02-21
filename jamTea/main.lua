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

local button = 0
local mouseHoldX = 0
local mouseHoldY = 0
local mouseReleaseX = 0
local mouseReleaseY = 0
local holding = "nothing"

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
        pics.waBo.coorX = -100
        pics.waBo.coorY = -100
      end
    elseif holding == "cup" then
      pics.emCu.coorX = cursorX
      pics.emCu.coorY = cursorY
    elseif holding == "teapot" then
      pics.tePo.coorX = cursorX
      pics.tePo.coorY = cursorY
    end
  end
  
  -- to modify
  if mouseHoldX > cooker.xMin and
       mouseHoldX < cooker.xMax and
       mouseHoldY > cooker.yMin and
       mouseHoldY < cooker.yMax then
        print("HOT !!")
        mouseHoldX = 0
        mouseHoldY = 0
    end
    
end

function love.draw()
  love.graphics.draw(pics.bg.src, 0, 0, 0, 1/pics.bg.scale, 1/pics.bg.scale)
  love.graphics.draw(pics.sack.src, pics.sack.coorX, pics.sack.coorY, 0, 1/pics.sack.scale, 1/pics.sack.scale, pics.sack.w/2, pics.sack.h/2)
  
  love.graphics.draw(pics.emCu.src, pics.emCu.coorX, pics.emCu.coorY, 0, -1/pics.emCu.scale, 1/pics.emCu.scale, pics.emCu.w/2, pics.emCu.h/2)
  --love.graphics.draw(pics.fuCu.src, pics.leaf.coorX, pics.fuCu.coorY, 0, 1/pics.fuCu.scale, 1/pics.fuCu.scale, pics.fuCu.w/2, pics.fuCu.h/2)
  love.graphics.draw(pics.tePo.src, pics.tePo.coorX, pics.tePo.coorY, 0, -1/pics.tePo.scale, 1/pics.tePo.scale, pics.tePo.w/2, pics.tePo.h/2)
  love.graphics.draw(pics.leaf.src, pics.leaf.coorX, pics.leaf.coorY, 0, 1/pics.leaf.scale, 1/pics.leaf.scale, pics.leaf.w/2, pics.leaf.h/2)
  love.graphics.draw(pics.waBo.src, pics.waBo.coorX, pics.waBo.coorY, 0, 1/pics.waBo.scale, 1/pics.waBo.scale, pics.waBo.w/2, pics.waBo.h/2)
  
end

function love.keypressed(key)
  
  print(key)
  
end