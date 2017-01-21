local Character = {}

-- lists of pictures
Character.stand = {}
Character.walkR = {}
Character.walkL = {}
Character.imp = {}
Character.jum = {}
Character.wei = {}
Character.fal = {}

Character.action = "stand"
Character.dir = "right"
Character.drawable = nil
Character.picCurrent = 2
Character.coorX = 0
Character.coorY = 0
Character.initJumSpe = 7
Character.jumSpe = 0
Character.jumLim = -10
Character.walkS = 5

function Character.Load(pWindowHeight)
  Character.coorX = 100
  Character.coorY = pWindowHeight-6*32 -- tile size 32
  Character.jumLim = Character.jumLim + Character.coorY
  Character.jumSpe = Character.initJumSpe
  
  Character.stand[1] = love.graphics.newImage("pictures/Rosette_Stand_R.png")
  Character.stand[2] = love.graphics.newImage("pictures/Rosette_Stand_L.png")
  
  Character.walkR[1] = love.graphics.newImage("pictures/Rosette_walk_32x32_Anim_R.png")
  Character.walkR[2] = love.graphics.newQuad(0, 0, 32, 32, Character.walkR[1]:getDimensions())
  Character.walkR[3] = love.graphics.newQuad(32, 0, 32, 32, Character.walkR[1]:getDimensions())
  Character.walkR[4] = love.graphics.newQuad(64, 0, 32, 32, Character.walkR[1]:getDimensions())
  Character.walkR[5] = love.graphics.newQuad(96, 0, 32, 32, Character.walkR[1]:getDimensions())

  Character.walkL[1] = love.graphics.newImage("pictures/Rosette_walk_32x32_Anim_L.png")
  Character.walkL[2] = love.graphics.newQuad(0, 0, 32, 32, Character.walkL[1]:getDimensions())
  Character.walkL[3] = love.graphics.newQuad(32, 0, 32, 32, Character.walkL[1]:getDimensions())
  Character.walkL[4] = love.graphics.newQuad(64, 0, 32, 32, Character.walkL[1]:getDimensions())
  Character.walkL[5] = love.graphics.newQuad(96, 0, 32, 32, Character.walkL[1]:getDimensions())

  Character.jum[1] = love.graphics.newImage("pictures/Rosette_Jump2_R.png")
  Character.jum[2] = love.graphics.newImage("pictures/Rosette_Jump2_L.png")
  Character.fal[1] = love.graphics.newImage("pictures/Rosette_Fall2_R.png")
  Character.fal[2] = love.graphics.newImage("pictures/Rosette_Fall2_L.png")

end

function Character.Update(dt, pWindowWidth)
  
  -- condition for right orientation
  if love.keyboard.isDown("right") and Character.dir == "left" then
    Character.dir = "right"
  elseif love.keyboard.isDown("left") and Character.dir == "right" then
    Character.dir = "left"
  end
  
  -- condition for walking
  if love.keyboard.isDown("right") and Character.dir == "right" then
    Character.action = "walk"
    Character.picCurrent = Character.picCurrent + (12 * dt) -- using the delta time
    Character.coorX = Character.coorX + Character.walkS
    if math.floor(Character.picCurrent) > 5 then
      Character.picCurrent = 2
    end
  elseif love.keyboard.isDown("left") and Character.dir == "left" then
    Character.action = "walk"
    Character.picCurrent = Character.picCurrent + (12 * dt) -- using the delta time
    Character.coorX = Character.coorX - Character.walkS
    if math.floor(Character.picCurrent) > 5 then
      Character.picCurrent = 2
    end
  
  -- condition for standing
  elseif Character.dir == "right" or Character.dir == "left" then
    Character.action = "stand"
  end
  
  -- condition for jumping
  if love.keyboard.isDown("space") or Character.coorY < Character.jumLim then
    Character.action = "jump"
  end
  
  -- manage coorY and the 2 phases of the jump
  if Character.action == "jump" or Character.action == "fall" then
    Character.coorY = Character.coorY - Character.jumSpe
    Character.jumSpe = Character.jumSpe - dt*9.81
    if Character.jumSpe < 0 then
      Character.action = "fall"
    end
  end
  
  -- manage landing
  if Character.coorY > Character.jumLim then
    Character.jumSpe = Character.initJumSpe
  end
  
  -- manage the side boundaries
  if Character.coorX > (pWindowWidth - 32) then
    Character.coorX = pWindowWidth - 32
  end
  if Character.coorX < 0 then
    Character.coorX = 0
  end
  
  
end


function Character.Draw()
  
  if Character.action == "stand" then  
    if Character.dir == "right" then
      love.graphics.draw(Character.stand[1], Character.coorX, 640-6*32)
    elseif Character.dir == "left" then
      love.graphics.draw(Character.stand[2], Character.coorX, 640-6*32)
    end
  end
  
  if Character.action == "walk" then
    if Character.dir == "right" then
      love.graphics.draw(Character.walkR[1], Character.walkR[math.floor(Character.picCurrent)], Character.coorX, 640-6*32)
    elseif Character.dir == "left" then
      love.graphics.draw(Character.walkL[1], Character.walkL[math.floor(Character.picCurrent)], Character.coorX, 640-6*32)
    end
  end
  
  if Character.action == "jump" then
    if Character.dir == "right" then
      love.graphics.draw(Character.jum[1], Character.coorX, Character.coorY)
    elseif Character.dir == "left" then
      love.graphics.draw(Character.jum[2], Character.coorX, Character.coorY)
    end
  end
  
  if Character.action == "fall" then
    if Character.dir == "right" then
      love.graphics.draw(Character.fal[1], Character.coorX, Character.coorY)
    elseif Character.dir == "left" then
      love.graphics.draw(Character.fal[2], Character.coorX, Character.coorY)
    end
  end
  
  
  
end



return Character