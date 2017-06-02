math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1280 -- 32x32px sprites value (40 columns)
local windowHeight = 672 -- 32x32px sprites value (21 lines)

local gameState = "menu"

local myParallax = require("parallaxAnimation")
local myMenu = require("menu")

local timeElpased = 0
local drawParallax, drawMenu = true, false

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Into the Mirror")
  
  myParallax.Load(windowWidth, windowHeight)
  myMenu.Load(windowWidth, windowHeight)
  
end

function love.update(dt)
  
  if gameState == "menu" then
    
    if myMenu.menuState == "title" then
      drawParallax = true
    else drawParallax = false
    end
    
    if myParallax.fullSpeed == true then
      timeElpased = timeElpased + dt
      if timeElpased > 2 then
        drawMenu = true
      end
    end
    
    if drawParallax == true then myParallax.Update(dt) end
    if drawMenu == true then myMenu.Update(dt) end
  
  end
end

function love.draw()
  
  if gameState == "menu" then
    
    if drawParallax == true then myParallax.Draw() end
    if drawMenu == true then myMenu.Draw() end
  else 
    drawMenu = false
    drawParallax = false
  end
  
end