io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 675 -- default value

local pics = {}
pics.bg = {}
pics.sack = {}
pics.leaf = {}

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
  pics.sack.coorX = 150
  pics.sack.coorY = windowHeight - 1.3*pics.sack.h/pics.sack.scale
  
  -- tea leaves
  pics.leaf.src = love.graphics.newImage("pictures/teaLeaves.png")
  pics.leaf.w = pics.leaf.src:getWidth()
  pics.leaf.h = pics.leaf.src:getHeight()
  pics.leaf.scale = 12
  
  
  
end

function love.update(dt)
  -- TODO mouvement of the leafs with the mouse
  pics.leaf.coorX = 0
  pics.leaf.coorY = 0

end

function love.draw()
  love.graphics.draw(pics.bg.src, 0, 0, 0, 1/pics.bg.scale, 1/pics.bg.scale)
  love.graphics.draw(pics.sack.src, pics.sack.coorX, pics.sack.coorY, 0, 1/pics.sack.scale, 1/pics.sack.scale)
  
  love.graphics.draw(pics.leaf.src, pics.leaf.coorX, pics.leaf.coorY, 0, 1/pics.leaf.scale, 1/pics.leaf.scale)
  
  
end

function love.keypressed(key)
  
  print(key)
  
end