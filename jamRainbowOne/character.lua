local Character = {}

Character.stand = {}
Character.walk = {}

function Character.Load()
  Character.stand[1] = love.graphics.newImage("pictures/Rosette_Stand_R.png")
  Character.stand[2] = love.graphics.newImage("pictures/Rosette_Stand_L.png")
  
  Character.walk[1] = love.graphics.newImage("pictures/Rosette_Walk_32x32_Anim_R.png")
  Character.walk[2] = love.graphics.newImage("pictures/Rosette_Walk_32x32_Anim_L.png")

end

function Character.Draw()
  love.graphics.draw(Character.stand[1], 100, 640-6*32)
end



return Character