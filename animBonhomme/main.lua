io.stdout:setvbuf('no')

if arg[#arg] == "-debug" then require("mobdebug").start() end

require"listLoad"

local angle = 0
local offsetAngle = 10
local legsToLeft = true
local legsToRight = false
local difAngle = 0.01
local onTheMove = false
local onTheJump = false
local thresholdAngle = 0.05
local maxAngleWalk = 0.5
local speedWalk = 3
local speedJump = 0

function bodyVolume()
  legs.width = body.pixel
  legs.height = body.legs * body.pixel
  torso.width = body.pixel * 1.3
  torso.height = body.torso * body.pixel
  arms.width = body.pixel
  arms.height = body.arms * body.pixel
  head.radius = body.pixel*0.55
end

function xReset()
  legsLeft.x = windowWidth/2 - legs.width/2
  legsRight.x = windowWidth/2 - legs.width/2
  
  torso.x = windowWidth/2 - torso.width/2
    
  armsLeft.x = windowWidth/2 - arms.width/2
  armsRight.x = windowWidth/2 - arms.width/2
  
  head.x = windowWidth/2
end

function love.load()
  
  windowWidth = love.graphics.getWidth() -- 800
  windowHeight = love.graphics.getHeight() -- 600
  
  ground.height = 50
  ground.width = windowWidth - ground.offset
  ground.x = ground.offset/2
  ground.y = windowHeight - ground.height - ground.offset/2
  
  bodyVolume()
  
  xReset()
  
  yReset()
  
  -- play background music
  bgm = love.audio.newSource("dkTheme.mp3", "stream")
  bgm:setLooping(true)
  bgm:setVolume(0.5)
  bgm:play()
  
end

function yReset()
  legsLeft.y = windowHeight - ground.height - ground.offset - legs.height
  legsRight.y = windowHeight - ground.height - ground.offset - legs.height
  
  torso.y = legsLeft.y - (torso.height - offsetAngle*2)
    
  armsLeft.y = torso.y
  armsRight.y = torso.y
  
  head.y = torso.y - head.radius
  
  onTheJump = false
  speedJump = 5
end

function walkingX(s)
  legsLeft.x = legsLeft.x + s
  legsRight.x = legsRight.x + s
  torso.x = torso.x + s
  armsLeft.x = armsLeft.x + s
  armsRight.x = armsRight.x + s
  head.x = head.x + s
end

function jumpingY(s)
  legsLeft.y = legsLeft.y - s
  legsRight.y = legsRight.y - s
  torso.y = torso.y - s
  armsLeft.y = armsLeft.y - s
  armsRight.y = armsRight.y - s
  head.y = head.y - s
end

function stuckBoundary(bound)
  legsLeft.x = bound - legs.width/2
  legsRight.x = bound - legs.width/2
  torso.x = bound - torso.width/2
  armsLeft.x = bound - arms.width/2
  armsRight.x = bound - arms.width/2
  head.x = bound
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
    walkingX(speedWalk)
  end
  if love.keyboard.isDown("left") then
    walkingX(-speedWalk)
  end
  
  if love.keyboard.isDown("space") then
    onTheJump = true
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
  
  if onTheJump == true then
    jumpingY(speedJump)
    speedJump = speedJump - dt*9.81
  end
  
  if legsLeft.y > (windowHeight - ground.height - ground.offset - legs.height) + 1 then
    yReset()
  end
  
  if head.x > windowWidth then
    stuckBoundary(windowWidth)
  end
  
  if head.x < 0 then
    stuckBoundary(0)
  end
  
end

function updateTransformation(dt)
  if love.keyboard.isDown("up") and ((legsLeft.y + legs.height) - (head.y - head.radius)) < (windowHeight - ground.height - ground.offset - 5) then -- margin 10 for the ceiling
    body.pixel = body.pixel + 0.5
    bodyVolume()
    xReset()
    yReset()
    print((legsLeft.y + legs.height) - (head.y - head.radius))
  end
  if love.keyboard.isDown("down") and ((legsLeft.y + legs.height) - (head.y - head.radius)) > (50 + 5) then
    body.pixel = body.pixel - 0.5
    bodyVolume()
    xReset()
    yReset()
  end
end

function love.update(dt)
  updateMove(dt)
  updateTransformation(dt)
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
  love.graphics.rectangle("fill", armsRight.x, armsRight.y, arms.width, arms.height, body.radius, body.radius)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.translate(legsRight.x + legs.width/2, legsRight.y + offsetAngle)
	love.graphics.rotate(angle)
	love.graphics.translate(-legsRight.x - legs.width/2, -legsRight.y - offsetAngle)
  love.graphics.setColor(0, 255, 0) -- green
  love.graphics.rectangle("fill", legsRight.x, legsRight.y, legs.width, legs.height, body.radius, body.radius)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.setColor(255, 0, 0) -- red
  love.graphics.rectangle("fill", torso.x, torso.y, torso.width, torso.height, body.radius, body.radius)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.setColor(255, 255, 0) -- yellow
  --love.graphics.rectangle("fill", head.x, head.y, head.width, head.height, body.radius, body.radius)
  love.graphics.circle("fill", head.x, head.y, head.radius)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.translate(legsLeft.x + legs.width/2, legsLeft.y + offsetAngle)
	love.graphics.rotate(-angle)
	love.graphics.translate(-legsLeft.x - legs.width/2, -legsLeft.y - offsetAngle)
  love.graphics.setColor(0, 0, 255) -- blue
  love.graphics.rectangle("fill", legsLeft.x, legsLeft.y, legs.width, legs.height, body.radius, body.radius)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.translate(armsLeft.x + arms.width/2, armsLeft.y + offsetAngle)
	love.graphics.rotate(-angle)
	love.graphics.translate(-armsLeft.x - arms.width/2, -armsLeft.y - offsetAngle)
  love.graphics.setColor(255, 0, 255) -- pink
  love.graphics.rectangle("fill", armsLeft.x, armsLeft.y, arms.width, arms.height, body.radius, body.radius)
  love.graphics.pop()
  
  
  -- back to black
  love.graphics.setColor(0, 0, 0)
  
end
