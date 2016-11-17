io.stdout:setvbuf('no')

if arg[#arg] == "-debug" then require("mobdebug").start() end

-- proportion human body
body =  {}
body.pixel = 50
body.head = 1
body.torso = 3
body.legs = 4
body.arms = 2
body.hands = 0.5
body.feet = 0.5

ground = {}
ground.x = 0
ground.y = 0
ground.width = 0
ground.height = 0
ground.offset = 10

torso = {}
torso.x = 0
torso.y = 0
torso.width = 0
torso.height = 0

legs = {}
legs.width = 0
legs.height = 0

legsLeft = {}
legsLeft.x = 0
legsLeft.y = 0
legsLeft.width = 0
legsLeft.height = 0

legsRight = {}
legsRight.x = 0
legsRight.y = 0
legsRight.width = 0
legsRight.height = 0

arms = {}
arms.width = 0
arms.height = 0

armsLeft = {}
armsLeft.x = 0
armsLeft.y = 0
armsLeft.width = 0
armsLeft.height = 0

armsRight = {}
armsRight.x = 0
armsRight.y = 0
armsRight.width = 0
armsRight.height = 0


local angle = 0
local offsetAngle = 10
local legsToLeft = true
local legsToRight = false
local difAngle = 0.01
local onTheMove = false
local thresholdAngle = 0.05
local maxAngleWalk = 0.5
local speedWalk = 2


function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   end
end

function love.load()
  
  windowWidth = love.graphics.getWidth() -- 800
  windowHeight = love.graphics.getHeight() -- 600
  
  ground.height = 50
  ground.width = windowWidth - ground.offset
  ground.x = ground.offset/2
  ground.y = windowHeight - ground.height - ground.offset/2
  
  legs.width = body.pixel
  legs.height = body.legs * body.pixel
  
  legsLeft.x = windowWidth/2 - legs.width/2
  legsLeft.y = windowHeight - ground.height - ground.offset - legs.height

  legsRight.x = windowWidth/2 - legs.width/2
  legsRight.y = windowHeight - ground.height - ground.offset - legs.height
  
  torso.width = body.pixel * 2
  torso.height = body.torso * body.pixel
  torso.x = windowWidth/2 - torso.width/2
  torso.y = legsLeft.y - (torso.height - offsetAngle*2)
    
  arms.width = body.pixel
  arms.height = body.arms * body.pixel
  
  armsLeft.x = windowWidth/2 - arms.width/2
  armsLeft.y = torso.y

  armsRight.x = windowWidth/2 - arms.width/2
  armsRight.y = torso.y
  
  
end

-- manage keyboard
function updateMove(dt)
  if love.keyboard.isDown("right") or love.keyboard.isDown("left") then
    onTheMove = true
    angle = angle + difAngle
    
    if angle > maxAngleWalk and legsToLeft == true then
      legsToLeft = false
      legsToRight = true
      difAngle = - 0.01
    end
    if angle < - maxAngleWalk and legsToRight == true then
      legsToLeft = true
      legsToRight = false
      difAngle = 0.01
    end
   end
  
   if love.keyboard.isDown("right") then
    legsLeft.x = legsLeft.x + speedWalk
    legsRight.x = legsRight.x + speedWalk
    torso.x = torso.x + speedWalk
    armsLeft.x = armsLeft.x + speedWalk
    armsRight.x = armsRight.x + speedWalk
  end
  if love.keyboard.isDown("left") then
    legsLeft.x = legsLeft.x - speedWalk
    legsRight.x = legsRight.x - speedWalk
    torso.x = torso.x - speedWalk
    armsLeft.x = armsLeft.x - speedWalk
    armsRight.x = armsRight.x - speedWalk
  end
  
  if love.keyboard.isDown("space") then
    print("space")
    -- TODO
  end
  if love.keyboard.isDown("r") then
    love.graphics.rotate(angle)
  end
  if not love.keyboard.isDown("right") and not love.keyboard.isDown("left") then
    love.timer.sleep(.01)
    if angle > thresholdAngle then
      angle = angle - dt
    
    elseif angle < - thresholdAngle then
      angle = angle + dt
    
    elseif angle < thresholdAngle or angle > - thresholdAngle then
      onTheMove = false
      angle = 0
    end
    
  end
end

function love.update(dt)
  updateMove(dt)
    
end

function love.draw()
  -- draw ground
  love.graphics.setColor(255, 255, 255) -- white
  love.graphics.rectangle("fill", ground.x, ground.y, ground.width, ground.height)
  
  -- draw body
  love.graphics.push()
  love.graphics.translate(armsRight.x + arms.width/2, armsRight.y + offsetAngle)
	love.graphics.rotate(angle)
	love.graphics.translate(-armsRight.x - arms.width/2, -armsRight.y - offsetAngle)
  love.graphics.setColor(255, 128, 0) -- orange
  love.graphics.rectangle("fill", armsRight.x, armsRight.y, arms.width, arms.height)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.translate(legsRight.x + legs.width/2, legsRight.y + offsetAngle)
	love.graphics.rotate(angle)
	love.graphics.translate(-legsRight.x - legs.width/2, -legsRight.y - offsetAngle)
  love.graphics.setColor(0, 255, 0) -- green
  love.graphics.rectangle("fill", legsRight.x, legsRight.y, legs.width, legs.height)
  love.graphics.pop()
  
  
  love.graphics.push()
  love.graphics.setColor(255, 0, 0) -- red
  love.graphics.rectangle("fill", torso.x, torso.y, torso.width, torso.height)
  love.graphics.pop()
  
  
  love.graphics.push()
  love.graphics.translate(legsLeft.x + legs.width/2, legsLeft.y + offsetAngle)
	love.graphics.rotate(-angle)
	love.graphics.translate(-legsLeft.x - legs.width/2, -legsLeft.y - offsetAngle)
  love.graphics.setColor(0, 0, 255) -- blue
  love.graphics.rectangle("fill", legsLeft.x, legsLeft.y, legs.width, legs.height)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.translate(armsLeft.x + arms.width/2, armsLeft.y + offsetAngle)
	love.graphics.rotate(-angle)
	love.graphics.translate(-armsLeft.x - arms.width/2, -armsLeft.y - offsetAngle)
  love.graphics.setColor(255, 0, 255) -- pink
  love.graphics.rectangle("fill", armsLeft.x, armsLeft.y, arms.width, arms.height)
  love.graphics.pop()
  
  
  
  -- back to black
  love.graphics.setColor(0, 0, 0)
  
end
