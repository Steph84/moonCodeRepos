io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local list_sprites = {}

local list_fox = {}
 

function createAnimation(pNomImage, pX, pY, pListFrames, pMaxFrame)
  --creation de la liste du sprite
  sprite = {}
  --positions x et y
  sprite.x = pX
  sprite.y = pY
  --association de son image
  sprite.image = love.graphics.newImage("pictures/"..pNomImage..".png") --concatenation pour inserer le nom de l image dans le chemin
  -- recuperation de la longueur et la largeur de l image
  sprite.l = sprite.image:getWidth()
  sprite.h = sprite.image:getHeight()
  
  -- frame pour l animation
  --par defaut il y a 1 frame et il y en a maximum 1
  sprite.frame = 1
  sprite.listFrames = {}
  sprite.listFrames = pListFrames
  sprite.maxFrame = pMaxFrame
  --ajout du sprite dans la liste des sprites
  table.insert(list_sprites, sprite)
  -- renvoi le sprite avec ses attributs
  return sprite
end



function love.load()
  local n
  for n=1, 7 do
    list_fox[n] = love.graphics.newImage("pictures/fox_"..n..".png")
  end 
  love.window.setMode(windowWidth, windowHeight)
  
  createAnimation("fox_1", 100, 100, list_fox, 7)
  
end

function love.update(dt)

end

function love.draw()
  local n
  for n = 1, #list_sprites do
    local s = list_sprites[n]
    love.graphics.draw(s.listFrames[n], s.x, s.y, 0, 2, 2, s.l/2, s.h/2)
  end
  
  local i
  for i = 1, #list_fox do
    local f = list_fox[i]
    love.timer.sleep(0.5)
    love.graphics.draw(f, 300, 300)
  end
  
end

function love.keypressed(key)
  
  print(key)
  
end