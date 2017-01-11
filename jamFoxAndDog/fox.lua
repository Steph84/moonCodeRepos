math.randomseed(os.time()) --initialiser le random
local fox = {}

local initJumpSpeed = 7
local foxRunSpeed = 200

function fox.Load(pWindowHeight, pWindowWidth, pRectDepth)
  fox.pictures = {}
  local n
  for n = 1, 7 do
    fox.pictures[n] = love.graphics.newImage("pictures/fox_"..n..".png")
  end 
  
  fox.blink = {}
  fox.blink[1] = love.graphics.newImage("pictures/fox_1.png")
  fox.blink[2] = love.graphics.newImage("pictures/fox_0.png")
  fox.blink[3] = love.graphics.newImage("pictures/fox_2.png")
  fox.blink[4] = love.graphics.newImage("pictures/fox_0.png")
  fox.blink[5] = love.graphics.newImage("pictures/fox_3.png")
  fox.blink[6] = love.graphics.newImage("pictures/fox_0.png")
  fox.blink[7] = love.graphics.newImage("pictures/fox_4.png")
  fox.blink[8] = love.graphics.newImage("pictures/fox_0.png")
  fox.blink[9] = love.graphics.newImage("pictures/fox_5.png")
  fox.blink[10] = love.graphics.newImage("pictures/fox_0.png")
  fox.blink[11] = love.graphics.newImage("pictures/fox_6.png")
  fox.blink[12] = love.graphics.newImage("pictures/fox_0.png")
  fox.blink[13] = love.graphics.newImage("pictures/fox_7.png")
  fox.blink[14] = love.graphics.newImage("pictures/fox_0.png")
  

  fox.w = fox.pictures[1]:getWidth()
  fox.h = fox.pictures[1]:getHeight()

  fox.picCurrent = 1
  fox.coorX = math.random(1, 9)*100
  fox.coorY = pWindowHeight - pRectDepth - fox.h

  fox.scX = 0.5
  fox.scY = 0.5

  fox.move = "right"
  fox.jump = false
  fox.jumpSpeed = initJumpSpeed
  
  sonJump = love.audio.newSource("sounds/jumpSound.wav", "static")

end

function fox.Update(dt, pWindowWidth, pWindowHeight)
  -- animation of the fox
  fox.picCurrent = fox.picCurrent + (12 * dt) -- using the delta time
  
  if math.floor(fox.picCurrent) > #fox.pictures then
    fox.picCurrent = 1
  end
  
  -- movement and postion of the fox
  if fox.move == "right" then
    fox.coorX = fox.coorX + (foxRunSpeed * dt)
    fox.scX = 0.5
  end
  if fox.move == "left" then
    fox.coorX = fox.coorX - (foxRunSpeed * dt)
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
  if love.keyboard.isDown("space") or fox.coorY < (pWindowHeight - fox.h*2) then -- *2 is to avoid jump when the game start
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
  
  if love.keyboard.isDown("space") then
    sonJump:setVolume(0.2)
    sonJump:play()
  end
  
end

function fox.Draw(pCollisionState)
  
  if pCollisionState == false then
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
  elseif pCollisionState == true then
    love.graphics.draw(
                      fox.blink[math.floor(fox.picCurrent)],
                      fox.coorX,
                      fox.coorY,
                      0,
                      fox.scX,
                      fox.scY,
                      fox.w/2,
                      fox.h/2
                      )
    
  end
  
end



return fox