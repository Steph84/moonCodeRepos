local Menu = {}
--Menu.__index = Menu

Menu.Title = {}
Menu.Title =  {
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0},
                {1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0},
                {1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0},
                {1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0},
                {1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0},
                {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0},
                {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0},
                {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0},
                {1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
              }

local TITLE_WIDTH = #Menu.Title[1] 
local TITLE_HEIGHT = #Menu.Title

local TILE_WIDTH
local TILE_HEIGHT

local coordY = 0
local timeElapse = 0

Menu.TypeFace = {}

function Menu.Load()
  Menu.TypeFace[0] = nil
  Menu.TypeFace[1] = love.graphics.newImage("pictures/titleTile8x8.png")
  TILE_WIDTH = Menu.TypeFace[1]:getWidth()
  TILE_HEIGHT = Menu.TypeFace[1]:getHeight()
end

function Menu.Animation(dt)
  print(dt)
  timeElapse = timeElapse + dt
  coordY = coordY + 9.81 * timeElapse * timeElapse * 0.5
  if coordY > 500 then
    menuAnime = false
  end
  
end

function Menu.AnimeDraw()
  love.graphics.draw(Menu.TypeFace[1], 100, coordY)
end

function Menu.Draw()
  
  local c, l
  for l = 1, TITLE_HEIGHT do 
    for c = 1, TITLE_WIDTH do
      local id = Menu.Title[l][c]
      local color = Menu.TypeFace[id]
      if color ~= nil then
        love.graphics.draw(color, (c-1)*TILE_WIDTH, (l-1)*TILE_HEIGHT)
      end
    end
  end
  
  
  
  
end


return Menu