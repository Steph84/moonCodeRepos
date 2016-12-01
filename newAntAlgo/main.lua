io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

require "listLoad"

local windowWidth = 1200
local windowHeight = 600

function love.load()
  
  love.window.setMode(windowWidth, windowHeight, {centered = false, x = 100, y = 100})
  
  levelAntHill.line = ((windowHeight - levelAntHill.lineGap - levelAntHill.lineGap)/levelAntHill.lineGap) - 1
  levelAntHill.column = ((windowWidth)/levelAntHill.columnGap) - 1
  
  print(levelAntHill.line, levelAntHill.column)
  
  levelAntHill.listPoints[1] = {id = "startPoint", x = 1, y = 2}
  --print(levelAntHill.listPoints[1].id)
  
  
  
end

function love.update(dt)

end

function love.draw()
    
end

function love.keypressed(key)
  
  print(key)
  
end