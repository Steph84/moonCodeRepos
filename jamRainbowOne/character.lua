local Character = {}

Character.stand = {}
Character.walk = {}
Character.dir = "right"
Character.drawable = nil

function Character.Load()
  Character.stand[1] = love.graphics.newImage("pictures/Rosette_Stand_R.png")
  Character.stand[2] = love.graphics.newImage("pictures/Rosette_Stand_L.png")
  
  Character.walk[1] = love.graphics.newImage("pictures/Rosette_Walk_32x32_Anim_R.png")
  Character.walk[2] = love.graphics.newImage("pictures/Rosette_Walk_32x32_Anim_L.png")

  Character.drawable = Character.stand[1]
end

function Character.Update(dt)
  
  if love.keyboard.isDown("right") and Character.dir == "left" then
    Character.dir = "right"
  elseif love.keyboard.isDown("left") and Character.dir == "right" then
    Character.dir = "left"
  end
  
  if love.keyboard.isDown("right") and Character.dir == "right" then
    -- walk 1
  elseif love.keyboard.isDown("left") and Character.dir == "left" then
    -- walk 2
  elseif Character.dir == "right" then
    Character.drawable = Character.stand[1]
  elseif Character.dir == "left" then
    Character.drawable = Character.stand[2]
  end
  
  
  
end

function Character.Draw()
  love.graphics.draw(Character.drawable, 100, 640-6*32)
end



return Character