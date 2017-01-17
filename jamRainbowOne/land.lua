local Land = {}

Land.pic = {}
Land.wid = {}
Land.hei = {}

local a, b

function Land.Load()
  
  Land.tit = love.graphics.newImage("pictures/tmMap01.png")
  
  Land.pic[1] = love.graphics.newImage("pictures/LandTiles_32_32.png")
  Land.wid[1] = Land.pic[1]:getWidth()
  Land.hei[1] = Land.pic[1]:getHeight()

  a = love.graphics.newQuad(0, 0, 32, 32, Land.pic[1]:getDimensions())
  b = love.graphics.newQuad(0, 32, 32, 32, Land.pic[1]:getDimensions())
end

function Land.Draw()
  love.graphics.draw(Land.pic[1], a, 50, 50)
	love.graphics.draw(Land.pic[1], b, 50, 200)
  
  love.graphics.draw(Land.tit, 0, 0)

end




return Land