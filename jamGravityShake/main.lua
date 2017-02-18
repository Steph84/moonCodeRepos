io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1024 -- default value
local windowHeight = 600 -- default value
local alpha, beta
local actualScreen = "menu"
local newCreation = false
local menuPic = {}
menuPic.src = love.graphics.newImage("pictures/menuPic.jpg")
menuPic.w = menuPic.src:getWidth()
menuPic.h = menuPic.src:getHeight()
print(menuPic.w, menuPic.h)

local Drop = require("drop")

function love.load()
  love.window.setMode(windowWidth, windowHeight)
  Drop.Load(windowWidth, windowHeight)
end

function love.update(dt)
  if actualScreen == "animation" then
    alpha, beta = love.mouse.getPosition() -- get the cursor postion for the gravity animation
    Drop.Update(dt, windowWidth, windowHeight, alpha, beta, newCreation)
    newCreation = false
  end
end

function love.draw()
  if actualScreen == "menu" then
    love.graphics.draw(menuPic.src, 0, 0)
    love.graphics.print("Steph84", 20, 20, 0, 2, 2)
    love.graphics.print("Gravity is a habit that is hard to shake off", 50, 150, -3.14/14, 2, 2)
    love.graphics.print("Press return or enter to play", 20, windowHeight - 40, 0, 2, 2)
  elseif actualScreen == "animation" then
    love.graphics.print("Shake the cursor to stop the gravity ;-)", 20, 20, 0, 1.2, 1.2)
    love.graphics.print("Press space to drop another set of... drops... :-D", windowWidth - 400, 20, 0, 1.2, 1.2)
    love.graphics.circle("line", alpha, beta, 75)
    Drop.Draw(windowHeight)
  end
end

function love.keypressed(key)
  if actualScreen == "menu" then
    if key == "return" then
      actualScreen = "animation"
    end
  end
  if actualScreen == "animation" then
    if key == "space" then
      newCreation = true
    end
  end
end