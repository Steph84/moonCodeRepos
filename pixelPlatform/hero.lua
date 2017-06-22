local Hero = {}

local myMap = {}

function Hero.Load(oMap)
  myMap = oMap
  Hero.pic = love.graphics.newImage("pictures/char01Stand.png")

end

function Hero.Update(dt)
  
end

function Hero.Draw()
  love.graphics.draw(Hero.pic, 100, 100)
end


return Hero