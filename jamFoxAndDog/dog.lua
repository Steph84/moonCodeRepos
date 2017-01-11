local dog = {}
local dogWalkSpeed = 75
local timeElapsed = 0

function dog.Load(pWindowHeight, pRectDepth)
  dog.pictures = {}
  local n
  for n=1, 3 do
    dog.pictures[n] = love.graphics.newImage("pictures/dog_"..n..".png")
  end 

  dog.w = dog.pictures[1]:getWidth()
  dog.h = dog.pictures[1]:getHeight()

  dog.picCurrent = 1
  dog.coorX = 0
  dog.coorY = pWindowHeight - pRectDepth - dog.h*1.2

  dog.scX = 2
  dog.scY = 2

  dog.direction = "right"
  dog.move = true
  
end

function dogChangeMove()
  if dog.move == false then
    dog.move = true
  elseif dog.move == true then
    dog.move = false
  end
  
end

function dog.Update(dt, pWindowWidth)
  
  -- dog AI moving and standing
  if timeElapsed < 5 then
    timeElapsed = timeElapsed + dt
  elseif timeElapsed > 5 then
    dogChangeMove()
    timeElapsed = 0
  end
  
  -- animation of the dog
  if dog.move == true then
    dog.picCurrent = dog.picCurrent + (4 * dt) -- using the delta time
    if math.floor(dog.picCurrent) > #dog.pictures then
      dog.picCurrent = 1
    end
    
    -- movement and postion of the dog
    if dog.direction == "right" then
      dog.coorX = dog.coorX + (dogWalkSpeed * dt)
      dog.scX = 2
    end
    if dog.direction == "left" then
      dog.coorX = dog.coorX - (dogWalkSpeed * dt)
      dog.scX = 0 - 2
    end
    
    -- change of the direction of the dog
    if dog.coorX > (pWindowWidth - dog.w/4) then
      dog.direction = "left"
    end
    if dog.coorX < (0 + dog.w/4) then
      dog.direction = "right"
    end
    
  end
  
  -- standing of the dog
  if dog.move == false then
    dog.picCurrent = 2
    
    -- postion of the dog
    if dog.direction == "right" then
      dog.scX = 2
    end
    if dog.direction == "left" then
      dog.scX = 0 - 2
    end
  end
  
  
  
  
end

function dog.Draw()
  love.graphics.draw(
                      dog.pictures[math.floor(dog.picCurrent)],
                      dog.coorX,
                      dog.coorY,
                      0,
                      dog.scX,
                      dog.scY,
                      dog.w/2,
                      dog.h/2
                    )
end



return dog