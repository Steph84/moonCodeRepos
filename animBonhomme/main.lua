io.stdout:setvbuf('no')

if arg[#arg] == "-debug" then require("mobdebug").start() end

require"listLoad"

-- geometry of the body
function bodyVolume()
  legs.width = body.pixel
  legs.height = body.legs * body.pixel
  torso.width = body.pixel * 1.3
  torso.height = body.torso * body.pixel
  arms.width = body.pixel
  arms.height = body.arms * body.pixel
  head.radius = body.pixel*body.head/2
  nose.radius = body.pixel*body.nose
end

-- allow to center the body in the window
function xReset()
  legsLeft.x = windowWidth/2 - legs.width/2
  legsRight.x = windowWidth/2 - legs.width/2
  torso.x = windowWidth/2 - torso.width/2
  armsLeft.x = windowWidth/2 - arms.width/2
  armsRight.x = windowWidth/2 - arms.width/2
  head.x = windowWidth/2
  nose.x = windowWidth/2 + head.radius + nose.radius
end

-- allow to get back the body on the ground
function yReset()
  legsLeft.y = windowHeight - ground.height - ground.offset - legs.height
  legsRight.y = windowHeight - ground.height - ground.offset - legs.height
  torso.y = legsLeft.y - (torso.height - ground.offset*2)
  armsLeft.y = torso.y
  armsRight.y = torso.y
  head.y = torso.y - head.radius
  nose.y = head.y
end

-- allow to play the background music
function backgroundMusic()
  bgm = love.audio.newSource("dkTheme.mp3", "stream")
  bgm:setLooping(true)
  bgm:setVolume(0.25)
  bgm:play()
end

function love.load()
  windowWidth = love.graphics.getWidth() -- 800
  windowHeight = love.graphics.getHeight() -- 600
  
  -- build the ground
  ground.width = windowWidth - ground.offset
  ground.x = ground.offset/2
  ground.y = windowHeight - ground.height - ground.offset/2
  
  -- load the coordinates and the size of the body
  bodyVolume()
  xReset()
  yReset()
  
  -- play background music
  --backgroundMusic()
  
end

-- manage the x coordinate movement
function movementX(speedX)
  legsLeft.x = legsLeft.x + speedX
  legsRight.x = legsRight.x + speedX
  torso.x = torso.x + speedX
  armsLeft.x = armsLeft.x + speedX
  armsRight.x = armsRight.x + speedX
  head.x = head.x + speedX
  nose.x = nose.x + speedX
end

-- manage the y coordinate movement
function movementY(speedY)
  legsLeft.y = legsLeft.y - speedY
  legsRight.y = legsRight.y - speedY
  torso.y = torso.y - speedY
  armsLeft.y = armsLeft.y - speedY
  armsRight.y = armsRight.y - speedY
  head.y = head.y - speedY
  nose.y = nose.y - speedY
end

-- manage the right and left boundaries
function stuckBoundary(bound)
  legsLeft.x = bound - legs.width/2
  legsRight.x = bound - legs.width/2
  torso.x = bound - torso.width/2
  armsLeft.x = bound - arms.width/2
  armsRight.x = bound - arms.width/2
  head.x = bound
  nose.x = bound + head.radius + nose.radius
end

-- manage the legs movement while walk or run
function legsScissoring(speedScissor)
  if moving.supportingFoot == "left" then
    moving.angleScissor = moving.angleScissor + speedScissor
  elseif moving.supportingFoot == "right" then
    moving.angleScissor = moving.angleScissor - speedScissor
  end
end

-- procedural movement
function updateMove(dt)
  -- y coordinate of the lower part of the body
  body.bottomY = legsLeft.y + legs.height
  
  -- state of the movement
  if love.keyboard.isDown("space") or body.bottomY < ground.y - 10 then -- if "space" key or the body is in the air
    moving.onTheJump = true
    moving.onTheCrouch = false
    moving.onTheGround = false
    moving.standStill = false
  elseif love.keyboard.isDown("c") then
    moving.onTheJump = false
    moving.onTheCrouch = true
    moving.onTheGround = false
    moving.standStill = false
  elseif (love.keyboard.isDown("right") or love.keyboard.isDown("left")) and not love.keyboard.isDown("lshift") then
    moving.onTheWalk = true
    moving.onTheRun = false
    moving.onTheGround = true
    moving.standStill = false
  elseif (love.keyboard.isDown("right") or love.keyboard.isDown("left")) and love.keyboard.isDown("lshift") then
    moving.onTheRun = true
    moving.onTheWalk = false
    moving.onTheGround = true
    moving.standStill = false
  else
    moving.onTheGround = true
    moving.onTheRun = false
    moving.onTheWalk = false
    moving.onTheCrouch = false
    moving.standStill = true
    moving.onTheJump = false
  end
  
  -- manage the walking
  if moving.onTheWalk == true then
    
    if moving.onTheJump == false then -- if there is no jump
      
      -- scissoring move
      if moving.rightLegTo == "right" then
        legsScissoring(moving.speedScissorWalk)
      elseif moving.rightLegTo == "left" then
        legsScissoring(-moving.speedScissorWalk)
      end
      
      -- scissoring alternation
      if moving.angleScissor > moving.maxAngleWalk then
        moving.rightLegTo = "left"
      elseif moving.angleScissor < - moving.maxAngleWalk then
        moving.rightLegTo = "right"
      end
      
    end
    
    -- moving along x
    if love.keyboard.isDown("right") then
      movementX(moving.speedWalk)
    end
    if love.keyboard.isDown("left") then
      movementX(-moving.speedWalk)
    end
    
  end
  
  -- manage the running
  if moving.onTheRun == true then
    
    if moving.onTheJump == false then -- if there is no jump
      
      -- scissoring move
      if moving.rightLegTo == "right" then
        legsScissoring(moving.speedScissorRun)
      elseif moving.rightLegTo == "left" then
        legsScissoring(-moving.speedScissorRun)
      end
      
      -- scissoring alternation
      if moving.angleScissor > moving.maxAngleRun then
        moving.rightLegTo = "left"
      elseif moving.angleScissor < - moving.maxAngleRun then
        moving.rightLegTo = "right"
      end
      
    end
    
    -- moving along x
    if love.keyboard.isDown("right") then
      movementX(moving.speedRun)
    end
    if love.keyboard.isDown("left") then
      movementX(-moving.speedRun)
    end
    
  end
  
  -- manage the stand still position
  if moving.standStill == true then
    
    love.timer.sleep(.01)
    
    -- to have the legs back straight
    if moving.angleScissor > moving.thresholdStill then
      moving.angleScissor = moving.angleScissor - dt
    elseif moving.angleScissor < - moving.thresholdStill then
      moving.angleScissor = moving.angleScissor + dt
    elseif moving.angleScissor < moving.thresholdStill or moving.angleScissor > - moving.thresholdStill then
      moving.angleScissor = 0
    end
    
  end
  
  -- manage the jumping
  if moving.onTheJump == true then
    
    -- moving along y
    movementY(moving.speedJump)
    moving.speedJump = moving.speedJump - dt*9.81
    
    -- manage the scissoring jump
    if moving.speedJump > 0 then
      moving.angleScissor = moving.angleScissor + dt*moving.speedScissorJump
    else moving.angleScissor = moving.angleScissor - dt*moving.speedScissorJump
    end
    
    -- during the ascension
    if moving.angleScissor > moving.maxAngleJump then
      moving.angleScissor = moving.maxAngleJump
    end
    -- during the landing
    if moving.angleScissor < 0.01 then
      moving.angleScissor = 0
    end
    
    -- jumping stop
    if body.bottomY > (ground.y - 5) then
      yReset()
      moving.onTheJump = false
      moving.speedJump = 7
    end
     
  end
  
  -- manage the side boundaries
  if head.x > windowWidth then
    stuckBoundary(windowWidth)
  end
  if head.x < 0 then
    stuckBoundary(0)
  end
  
end

-- manage the size modification
function updateTransformation(dt)
  local bodySize = (legsLeft.y + legs.height) - (head.y - head.radius)
  if love.keyboard.isDown("up") and bodySize < (windowHeight - ground.height - ground.offset - 5) then
    body.pixel = body.pixel + 0.5
    -- for the moment reset to the center of the window
    bodyVolume()
    xReset()
    yReset()
  end
  if love.keyboard.isDown("down") and bodySize > (50 + 5) then -- man size of 50 is good visualy
    body.pixel = body.pixel - 0.5
    -- for the moment reset to the center of the window
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
  love.graphics.translate(armsRight.x + arms.width/2, armsRight.y + ground.offset)
	love.graphics.rotate(-moving.angleScissor)
	love.graphics.translate(-armsRight.x - arms.width/2, -armsRight.y - ground.offset)
  love.graphics.setColor(255, 128, 0) -- orange
  love.graphics.rectangle("fill", armsRight.x, armsRight.y, arms.width, arms.height, body.radius, body.radius)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.translate(legsRight.x + legs.width/2, legsRight.y + ground.offset)
	love.graphics.rotate(moving.angleScissor)
	love.graphics.translate(-legsRight.x - legs.width/2, -legsRight.y - ground.offset)
  love.graphics.setColor(0, 255, 0) -- green
  love.graphics.rectangle("fill", legsRight.x, legsRight.y, legs.width, legs.height, body.radius, body.radius)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.setColor(255, 0, 0) -- red
  love.graphics.rectangle("fill", torso.x, torso.y, torso.width, torso.height, body.radius, body.radius)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.setColor(255, 255, 0) -- yellow
  love.graphics.circle("fill", head.x, head.y, head.radius)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.setColor(255, 0, 0) -- red
  love.graphics.circle("fill", nose.x, nose.y, nose.radius)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.translate(legsLeft.x + legs.width/2, legsLeft.y + ground.offset)
	love.graphics.rotate(-moving.angleScissor)
	love.graphics.translate(-legsLeft.x - legs.width/2, -legsLeft.y - ground.offset)
  love.graphics.setColor(0, 0, 255) -- blue
  love.graphics.rectangle("fill", legsLeft.x, legsLeft.y, legs.width, legs.height, body.radius, body.radius)
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.translate(armsLeft.x + arms.width/2, armsLeft.y + ground.offset)
	love.graphics.rotate(moving.angleScissor)
	love.graphics.translate(-armsLeft.x - arms.width/2, -armsLeft.y - ground.offset)
  love.graphics.setColor(255, 0, 255) -- pink
  love.graphics.rectangle("fill", armsLeft.x, armsLeft.y, arms.width, arms.height, body.radius, body.radius)
  love.graphics.pop()
  
  
  -- back to black
  love.graphics.setColor(0, 0, 0)
  
end

--function love.keypressed(key)
  --print(key)
--end