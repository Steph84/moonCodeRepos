local fox = {}

fox.pictures = {}
local n
for n=1, 7 do
  fox.pictures[n] = love.graphics.newImage("pictures/fox_"..n..".png")
end 

fox.picCurrent = 1
fox.coorX = 0
fox.coorY = 0

function fox.Update(dt)
  fox.picCurrent = fox.picCurrent + (12 * dt)
  if math.floor(fox.picCurrent) > #fox.pictures then
    fox.picCurrent = 1
  end
end

function fox.Draw()
  love.graphics.draw(fox.pictures[math.floor(fox.picCurrent)], 100, 100, 0, 0.5, 0.5)
end



return fox