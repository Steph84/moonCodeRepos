local Character = {}

Character.stand = {}
Character.walkR = {}
Character.walkL = {}
Character.dir = "right"
Character.drawable = nil
Character.picCurrent = 2
Character.coorX = 100

function Character.Load()
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

  Character.drawable = Character.stand[1]
end

function Character.Update(dt)
  
  if love.keyboard.isDown("right") and Character.dir == "left" then
    Character.dir = "right"
  elseif love.keyboard.isDown("left") and Character.dir == "right" then
    Character.dir = "left"
  end
  
  if love.keyboard.isDown("right") and Character.dir == "right" then
    Character.picCurrent = Character.picCurrent + (12 * dt) -- using the delta time
    Character.coorX = Character.coorX + 2
    if math.floor(Character.picCurrent) > 5 then
      Character.picCurrent = 2
    end
  elseif love.keyboard.isDown("left") and Character.dir == "left" then
    Character.picCurrent = Character.picCurrent + (12 * dt) -- using the delta time
    Character.coorX = Character.coorX - 2
    if math.floor(Character.picCurrent) > 5 then
      Character.picCurrent = 2
    end
  elseif Character.dir == "right" then
    Character.drawable = Character.stand[1]
  elseif Character.dir == "left" then
    Character.drawable = Character.stand[2]
  end
  
  
  
end

function Character.Draw()
  if Character.dir == "right" then
    love.graphics.draw(Character.walkR[1], Character.walkR[math.floor(Character.picCurrent)], Character.coorX, 640-6*32)
  elseif Character.dir == "left" then
    love.graphics.draw(Character.walkL[1], Character.walkL[math.floor(Character.picCurrent)], Character.coorX, 640-6*32)
  end
  
end



return Character