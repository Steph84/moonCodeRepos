math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1340 -- max value
local windowHeight = 682 -- max value

local map = {}
local hero = {}
local heroHeight = 64
hero.speed = 200
local timeElapsed = 0
local eruption = false
local listDrop = {}
local listDrill = {}

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Attack From Below")
  
  map.sky = {x = 0, y = 0, w = windowWidth, h = windowHeight * 4/7}
  map.ground = {x = 0, y = map.sky.h, w = windowWidth, h = windowHeight * 1/7}
  map.lava = {x = 0, y = map.sky.h + map.ground.h, w = windowWidth, h = windowHeight * 2/7}
  
  hero.head = {x = 50 + (heroHeight * 1/3)/2, y = map.ground.y - heroHeight, w = heroHeight * 1/3, h = heroHeight * 1/3}
  hero.body = {x = 50, y = map.ground.y - heroHeight * 2/3, w = heroHeight * 1/3, h = heroHeight * 2/3}
  
  
end

function CreateEruption(dt)
  local drill = {}
  drill.x = math.random(0, windowWidth)
  drill.y = map.ground.y
  drill.w = 64
  drill.h = map.ground.h
  table.insert(listDrill, drill)
  
  local drop = {}
  drop.x = drill.x + drill.w/2
  drop.y = drill.y
  drop.vx = math.random(-100, 100)
  drop.vy = math.random(-100, -50)
  drop.rayon = 32
  table.insert(listDrop, drop)
  
end

function love.update(dt)
  if love.keyboard.isDown("right") and hero.head.x < windowWidth then
    hero.head.x = hero.head.x + hero.speed * dt
    hero.body.x = hero.body.x + hero.speed * dt
  end
  if love.keyboard.isDown("left") and hero.head.x > 0 then
    hero.head.x = hero.head.x - hero.speed * dt
    hero.body.x = hero.body.x - hero.speed * dt
  end
  
  if eruption == false then
    timeElapsed = timeElapsed + dt
    if timeElapsed > 2 then
      eruption = true
      timeElapsed = 0
    end
  end
  
  if eruption == true then
    if #listDrop < 5 then
      CreateEruption(dt)
    end
    local i
    for i = 1, #listDrop do
      local d = listDrop[i]
      d.x = d.x + d.vx * dt
      d.y = d.y + d.vy * dt
      d.vy = d.vy + 9.81 * dt
    end
  end
  
  
end

function love.draw()
  -- draw map
  love.graphics.setColor(0, 64, 128)
  love.graphics.rectangle("fill", map.sky.x, map.sky.y, map.sky.w, map.sky.h)
  love.graphics.setColor(192, 0, 64)
  love.graphics.rectangle("fill", map.ground.x, map.ground.y, map.ground.w, map.ground.h)
  love.graphics.setColor(255, 128, 0)
  love.graphics.rectangle("fill", map.lava.x, map.lava.y, map.lava.w, map.lava.h)
  love.graphics.setColor(255, 255, 255)
  
  -- draw hero
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle("fill", hero.head.x, hero.head.y, 20)
  love.graphics.rectangle("fill", hero.body.x, hero.body.y, hero.body.w, hero.body.h)
  love.graphics.setColor(255, 255, 255)
  
  -- draw eruption
  if #listDrill > 0 then
    local i
    for i = 1, #listDrop do
      local d = listDrop[i]
      love.graphics.setColor(255, 128, 0)
      love.graphics.circle("fill", d.x, d.y, 20)
      love.graphics.rectangle("fill", d.x, d.y, d.w, d.h)
    end
  end
  
end