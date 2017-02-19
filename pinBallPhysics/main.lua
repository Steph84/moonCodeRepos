-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowHeight = 680
local windowWidth = windowHeight/2

-- dimension of a standard playfield in meter
local playFieldWidth = 0.5
local playFieldHeight = 1.0
local playFieldAngle = 5 -- degré

local listPoints = {}

local world, objects

function love.load()
  
  love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
  love.window.setMode(windowWidth, windowHeight)
  
  -- local myMeter = windowHeight/playFieldHeight
  love.physics.setMeter(64) --the height of a meter our worlds will be the reality
  -- determine the g along the palyfield withe the angle
  -- local gPlayField = 9.81 * math.cos(40*3.14/180)
  world = love.physics.newWorld(0, 9.81 * 64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
  objects = {} -- table to hold all our physical objects
 
  objects.leftWall = {}
  objects.leftWall.body = love.physics.newBody(world, -2/2, windowHeight/2)
  objects.leftWall.shape = love.physics.newRectangleShape(2, windowHeight)
  objects.leftWall.fixture = love.physics.newFixture(objects.leftWall.body, objects.leftWall.shape)
  
  objects.rightWall = {}
  objects.rightWall.body = love.physics.newBody(world, windowWidth + 2/2, windowHeight/2)
  objects.rightWall.shape = love.physics.newRectangleShape(2, windowHeight)
  objects.rightWall.fixture = love.physics.newFixture(objects.rightWall.body, objects.rightWall.shape)
  
  objects.upWall = {}
  objects.upWall.body = love.physics.newBody(world, windowWidth/2, -2/2)
  objects.upWall.shape = love.physics.newRectangleShape(windowWidth, 2)
  objects.upWall.fixture = love.physics.newFixture(objects.upWall.body, objects.upWall.shape)
 
  objects.bottomShape = {}
  objects.bottomShape.body = love.physics.newBody(world, 0, windowHeight - 700)
  
  listPoints[1] = {0, windowHeight - 200}
  listPoints[2] = {windowWidth, windowHeight}
  
  objects.bottomShape.shape = love.physics.newEdgeShape(listPoints[1][1], listPoints[1][2],
                                                        listPoints[2][1], listPoints[2][2])
  --[[
  objects.bottomShape.shape = love.physics.newPolygonShape(0, windowHeight - 200,
                                                          windowWidth/2, windowHeight - 100,
                                                          windowWidth, windowHeight - 200,
                                                          windowWidth/2, windowHeight + 1000)
                                                          
  objects.bottomShape.shape = love.physics.newPolygonShape(0, windowHeight - 200,
                                                          windowWidth, windowHeight + 200,
                                                          0, windowHeight + 200)
                                                        --]]
                                                        
  objects.bottomShape.fixture = love.physics.newFixture(objects.bottomShape.body, objects.bottomShape.shape)
 
 
  --let's create the ground
  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, windowWidth/2, windowHeight-50/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  objects.ground.shape = love.physics.newRectangleShape(windowWidth, 50) --make a rectangle with a width of 650 and a height of 50
  --objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape) --attach shape to body
 
  --let's create a ball
  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, windowWidth/2, windowHeight/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.ball.shape = love.physics.newCircleShape(10) --the ball's shape has a radius of 20
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
  objects.ball.fixture:setRestitution(0.9) --let the ball bounce
  
  
end

function love.update(dt)
  world:update(dt) --this puts the world into motion
 
  --here we are going to create some keyboard events
  if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    objects.ball.body:applyForce(400, 0)
  elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    objects.ball.body:applyForce(-400, 0)
  elseif love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
    objects.ball.body:applyForce(0, -400)
  end
end

function love.draw()
  love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
  --love.graphics.polygon("fill", objects.bottomShape.body:getWorldPoints(objects.bottomShape.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.line(listPoints[1][1], listPoints[1][2], listPoints[2][1], listPoints[2][2])

  love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
  love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
  
  love.graphics.circle("fill", listPoints[1][1], listPoints[1][2], 5)
end

function love.keypressed(key)
  
  print(key)
  
end