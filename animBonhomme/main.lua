-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
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

local angle = 0
local offsetAngle = 10


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
    
  
  
end

-- manage keyboard
function updateMove()
  if love.keyboard.isDown("right") then
    print("right")
    -- TODO
  end
  if love.keyboard.isDown("left") then
    print("left")
    -- TODO
  end
  if love.keyboard.isDown("space") then
    print("space")
    -- TODO
  end
  if love.keyboard.isDown("r") then
    love.graphics.rotate(angle)
  end
end

function love.update(dt)
  updateMove()
  love.timer.sleep(.01)
	angle = angle + dt * math.pi/2
	angle = angle % (2*math.pi)
  
end

function love.draw()
  -- draw ground
  love.graphics.setColor(255, 255, 255) -- white
  love.graphics.rectangle("fill", ground.x, ground.y, ground.width, ground.height)
  
  -- draw body
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
  
  --test()
  
  -- back to black
  love.graphics.setColor(0, 0, 0)
  
end


function test()
  local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
  
  love.graphics.translate(width/2, height/2)
	love.graphics.rotate(angle)
	love.graphics.translate(-width/2, -height/2)
	-- draw a white rectangle slightly off center
	love.graphics.setColor(0xff, 0xff, 0xff)
	love.graphics.rectangle('fill', width/2-100, height/2-100, 300, 400)
end