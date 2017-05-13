 math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1300 -- max value
local windowHeight = 675 -- max value

local shot = 2
local hitCount = 0
local stuffCount = 0
local launch = false
local rocketSpeed = 100
local targetHit = false

local rocketPic = {}
local explosionPic = {}
local listTargets = {}
local listRockets = {}

local myColors = {}
myColors.white = {255, 255, 255}
myColors.red = {255, 0, 0}

local mouseClicked = {}

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("OneHourGameJamRockets")
  
  -- load rocket picture
  rocketPic.src = love.graphics.newImage("pictures/rocketV2.png")
  rocketPic.w = rocketPic.src:getWidth()
  rocketPic.h = rocketPic.src:getHeight()
  
  -- load explosion picture
  explosionPic.src = love.graphics.newImage("pictures/explosion.png")
  explosionPic.w = explosionPic.src:getWidth()
  explosionPic.h = explosionPic.src:getHeight()
  
  -- load targets
  local i
  for i = 1, shot do
    local target = {}
    
    target.id = i
    target.x = math.random(windowWidth * 0.1, windowWidth * 0.9)
    target.y = math.random(windowHeight * 0.1, windowHeight * 0.4)
    target.size = 50
    target.explode = false
    
    table.insert(listTargets, target)
  end
  
end

function createRocket(pX, pY)
  local rocket = {}
  
  rocket.id = #listRockets + 1
  rocket.x = pX
  rocket.y = pY
  rocket.scale = 0.2
  rocket.explode = false
  
  table.insert(listRockets, rocket)
end

function explodeTarget(pTargetId, pRocketId)
  listTargets[pTargetId].explode = true
  listRockets[pRocketId].explode = true
  hitCount = hitCount + 1
  stuffCount = stuffCount + 1
  --table.remove(listTargets, pTargetId)
  --table.remove(listRockets, pRocketId)
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

function love.update(dt)
  
  -- manage the rockets placement
  if mouseClicked.on == true then
    if mouseClicked.y > windowHeight/2 then
      if #listRockets < shot then
        createRocket(mouseClicked.x, mouseClicked.y)
        mouseClicked.on = false
      end
    end
  end
  
  -- manage the launching
  if love.keyboard.isDown("space") then
    launch = true
  end
  
  -- manage the flight
  if launch == true then
    local k
    for k = 1, #listRockets do
      local ro = listRockets[k]
      ro.y = ro.y - rocketSpeed * dt
      
      if ro.y < 0 then
        -- bug for removing, don t have time
        --table.remove(listRockets, ro.id)
        stuffCount = stuffCount + 1
      end
      
      local l
      for l = 1, #listTargets do
        local ta = listTargets[l]
        if ro.x > ta.x - ta.size and ro.x + rocketPic.w*ro.scale < ta.x + ta.size then
          if ro.y < ta.y then
            explodeTarget(ta.id, ro.id)
          end
        end
      end
    end
  end
end

function love.draw()
  love.graphics.setBackgroundColor(0, 0, 100)
  
  -- draw the targets
  local i
  for i = 1, #listTargets do
    local t = listTargets[i]
    if t.explode == false then
      love.graphics.setColor(myColors.red)
      love.graphics.circle("fill", t.x, t.y, t.size)
      love.graphics.setColor(myColors.white)
      love.graphics.circle("fill", t.x, t.y, t.size - 10)
      love.graphics.setColor(myColors.red)
      love.graphics.circle("fill", t.x, t.y, t.size - 20)
      love.graphics.setColor(myColors.white)
      love.graphics.circle("fill", t.x, t.y, t.size - 30)
      love.graphics.setColor(myColors.red)
      love.graphics.circle("fill", t.x, t.y, t.size - 40)
    elseif t.explode == true then
      love.graphics.setColor(myColors.white)
      love.graphics.draw(explosionPic.src, t.x, t.y, 0, 1, 1, explosionPic.w/2, explosionPic.h/2)
    end
    
  end
  
  -- draw the rockets
  love.graphics.setColor(myColors.white)
  local j
  for j = 1, #listRockets do
    local r = listRockets[j]
    if r.explode == false then
      love.graphics.draw(rocketPic.src, r.x, r.y, 0, r.scale, r.scale, rocketPic.w/2, rocketPic.h/2)
    end
  end
  
  -- manage the game help instructions
  if launch == false then
    
    -- draw the limit for rocket creation
    love.graphics.line(0, windowHeight/2, windowWidth, windowHeight/2)
    
    -- draw the launching instructions
    love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", 32))
    if #listRockets == shot then
      love.graphics.printf("press space to launch", 32, windowHeight - 64, windowWidth, "left")
    else
      love.graphics.printf("click to create rockets under the line", 32, windowHeight - 64, windowWidth, "left")
    end
  end
  if launch == true and stuffCount == shot then
    -- draw the result
    love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", 32))
    love.graphics.printf("you exploded "..hitCount.." out of  "..shot.." targets", 32, windowHeight - 64, windowWidth, "center")
  end
  
end