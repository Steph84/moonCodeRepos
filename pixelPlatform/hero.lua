local Hero = {}

local myMap = {}

function Hero.Load(oMap)
  myMap = oMap
  Hero.pic = love.graphics.newImage("pictures/char01Stand.png")
  Hero.x = 100
  Hero.y = 100
  Hero.w = Hero.pic:getWidth()
  Hero.h = Hero.pic:getHeight()
  
end

function Hero.Update(dt)
  local lin, col
  for lin = 1, myMap.size[2] do
    for col = 1, myMap.size[1] do
      local grid = myMap.grid[lin][col]
    
    end
  end
  if Hero.y < 600 then
    Hero.y = Hero.y + 9.81 * dt * 10
  end
end

function Hero.Draw()
  love.graphics.draw(Hero.pic, Hero.x, Hero.y)
end


return Hero