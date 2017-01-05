-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local myMenu = require("menu")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  
  myMenu.Load(windowWidth, windowHeight)
  
  menuAnime = true
  
end

function love.update(dt)
  if menuAnime == true then
    myMenu.Animation(dt)
  end
  

end

function love.draw()
    if menuAnime == true then
      myMenu.AnimeDraw(windowWidth, windowHeight)
    else myMenu.Draw()
    end
  
    
end

function love.keypressed(key)
  
  print(key)
  
end