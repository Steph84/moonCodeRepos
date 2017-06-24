math.randomseed(os.time())
io.stdout:setvbuf('no')
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local nbCubes = 10
local sizeCube = 16
local listCubes = {}
local cubesInTheBucket = {}
local cubesFleeing = {}
local bucket = {}
local cursorX, cursorY
local flee = 1
local timeElpased = 0
local faster = false

local myMouse = require("mouseControls")

function CreateCube(pId)
  local item = {}
  
  item.id = pId
  item.x = math.random(windowWidth * 0.1, windowWidth * 0.9)
  item.y = math.random(0, windowHeight * 0.4)
  item.w = sizeCube
  item.h = sizeCube
  item.hold = false
  
  table.insert(listCubes, item)
end

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Fill the bucket")
  
  local i
  for i = 1, nbCubes do CreateCube(i) end
  
  bucket.x = windowWidth * 0.1
  bucket.y = windowHeight * 0.7
  bucket.w = windowWidth * 0.2
  bucket.h = windowHeight * 0.2
  
end

function love.update(dt)
  cursorX, cursorY = love.mouse.getPosition()
  
  local i
  for i = 1, #listCubes do
    local c = listCubes[i]
    
    if #cubesInTheBucket < nbCubes - 1 then
      if c.hold == false then
        if myMouse.ClickOnObject(c) then
          c.hold = true
        end
      end
      if c.hold == true then
        c.x = cursorX - sizeCube/2
        c.y = cursorY - sizeCube/2
      end
      
      if c.hold == true then
        if myMouse.ClickOnObject(bucket) then
          c.hold = false
          c.x = math.random(bucket.x + sizeCube/2, bucket.x + bucket.w - sizeCube * 1.5)
          c.y = math.random(bucket.y + sizeCube/2, bucket.y + bucket.h - sizeCube * 1.5)
          table.insert(cubesInTheBucket, c)
        end
      end
    end
    
    if #cubesInTheBucket > (nbCubes * flee * 0.1) and flee < 9 then
      local choice = math.random(1, #cubesInTheBucket)
      cubesInTheBucket[choice].x = math.random(windowWidth/2, windowHeight * 0.9)
      cubesInTheBucket[choice].y = math.random(windowHeight/2, windowHeight * 0.8)
      table.remove(cubesInTheBucket, choice)
      table.insert(cubesFleeing, choice)
      flee = flee * 2
    end
    
    if #cubesInTheBucket == (nbCubes - 1) then
      timeElpased = timeElpased + dt
    end
    if timeElpased > 0.01 then faster = true else faster = false end
    if timeElpased > 20 then
      cubesInTheBucket = {}
      cubesFleeing = {}
      listCubes = {}
      timeElpased = 0
      
      local j
      for j = 1, nbCubes do CreateCube(j) end
    end
  end
end

function love.draw()
  love.graphics.printf("fill the bucket with the cubes", windowWidth/2, windowHeight * 0.85, windowWidth, "left")
  love.graphics.printf("click on the cube then click on the bucket", windowWidth/2, windowHeight * 0.9, windowWidth, "left")
  love.graphics.printf("You have "..#cubesInTheBucket.." cubes in the bucket", windowWidth/2, windowHeight * 0.95, windowWidth, "left")
  
  local i
  for i = 1, #listCubes do
    local c = listCubes[i]
    love.graphics.rectangle("fill", c.x, c.y, c.w, c.h, 5, 5)
  end
  
  -- draw the bucket
  love.graphics.line(bucket.x, bucket.y,
                 bucket.x, bucket.y + bucket.h,
                 bucket.x + bucket.w, bucket.y + bucket.h,
                 bucket.x + bucket.w, bucket.y)
  
  if faster == true then
    love.graphics.setColor(255, 0, 0)
    love.graphics.printf("FASTER !!!!   FASTER !!!!   FASTER !!!!   FASTER !!!!", 0, windowHeight/2, windowWidth, "center")
    love.graphics.setColor(255, 255, 255)
  end
  
end
