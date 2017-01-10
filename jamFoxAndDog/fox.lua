local fox = {}

local initJumpSpeed = 8.5

function fox.Load(pWindowHeight)
  fox.pictures = {}
  local n
  for n=1, 7 do
    fox.pictures[n] = love.graphics.newImage("pictures/fox_"..n..".png")
  end 

  fox.w = fox.pictures[1]:getWidth()
  fox.h = fox.pictures[1]:getHeight()

  fox.picCurrent = 1
  fox.coorX = 0
  fox.coorY = pWindowHeight - fox.h

  fox.scX = 0.5
  fox.scY = 0.5

  fox.move = "right"
  fox.jump = false
  fox.jumpSpeed = initJumpSpeed

end

function fox.Update(dt, pWindowWidth, pWindowHeight)
  -- animation of the fox
  fox.picCurrent = fox.picCurrent + (12 * dt) -- using the delta time
  if math.floor(fox.picCurrent) > #fox.pictures then
    fox.picCurrent = 1
  end
  
  -- movement and postion of the fox
  if fox.move == "right" then
    fox.coorX = fox.coorX + (150 * dt)
    fox.scX = 0.5
  end
  if fox.move == "left" then
    fox.coorX = fox.coorX - (150 * dt)
    fox.scX = 0 - 0.5
  end
  
  -- change of the direction of the fox
  if fox.coorX > (pWindowWidth - fox.w/4) then
    fox.move = "left"
  end
  if fox.coorX < (0 + fox.w/4) then
    fox.move = "right"
  end
  
  -- manage the jump state of the fox
  if love.keyboard.isDown("space") or fox.coorY < (pWindowHeight - fox.h - 10) then
    fox.jump = true
  end
  if fox.coorY > (pWindowHeight - fox.h) then
    fox.jump = false
    fox.jumpSpeed = initJumpSpeed
  end
  
  -- manage the coordinate changes of the fox
  if fox.jump == false then
    fox.coorY = pWindowHeight - fox.h
  end
  if fox.jump == true then
    fox.coorY = fox.coorY - fox.jumpSpeed
    fox.jumpSpeed = fox.jumpSpeed - dt*9.81
  end
  
  
end

function fox.Draw(pWindowHeight)
  love.graphics.draw(
                      fox.pictures[math.floor(fox.picCurrent)],
                      fox.coorX,
                      fox.coorY,
                      0,
                      fox.scX,
                      fox.scY,
                      fox.w/2,
                      fox.h/2
                    )
end



return fox