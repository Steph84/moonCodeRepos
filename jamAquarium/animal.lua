local Animal = {}

-- TODO change Animal to JellyFish
-- an object by animal instead

Animal.jellyFish = {}


function Animal.Load()
  
  Animal.jellyFish.pictures = {}
  local n
  for n = 1, 12 do
    Animal.jellyFish.pictures[n] = love.graphics.newImage("pictures/jellyFish"..n..".png")
  end   
  
  Animal.jellyFish.w = Animal.jellyFish.pictures[1]:getWidth() -- 270
  Animal.jellyFish.h = Animal.jellyFish.pictures[1]:getHeight() -- 307
  
  Animal.jellyFish.picCurrent = 1
  
end

function Animal.Update(pDt)
  Animal.jellyFish.picCurrent = Animal.jellyFish.picCurrent + (10 * pDt) -- using the delta time
  
  if math.floor(Animal.jellyFish.picCurrent) > #Animal.jellyFish.pictures then
    Animal.jellyFish.picCurrent = 1
  end
end

function Animal.Draw()
  love.graphics.draw(
                      Animal.jellyFish.pictures[math.floor(Animal.jellyFish.picCurrent)],
                      300,
                      300,
                      0,
                      0.5,
                      0.5,
                      Animal.jellyFish.w/2,
                      Animal.jellyFish.h/2
                      )
end

return Animal