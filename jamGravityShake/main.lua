-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  
  
end

function love.update(dt)

end

function love.draw()
    
end

function love.keypressed(key)
  
  print(key)
  
end