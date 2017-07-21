local Enemy = {}

function Enemy.Load()
  Enemy.mov = "stand"
  Enemy.speed = {}
  Enemy.speed.walk = 5
  Enemy.speed.animWalk = 10
  Enemy.animWalk = {}
  Enemy.picCurrent = 1
  Enemy.mov = "walk"
  Enemy.sign = 1
  Enemy.scale = 1.5
  Enemy.w = 32
  Enemy.h = 32
  Enemy.x = 500
  Enemy.y = 500
  
  -- load the animation walking tile
  Enemy.anim = love.graphics.newImage("pictures/enemy01Walk.png")
  local nbColumns = Enemy.anim:getWidth() / 32
  local nbLines = Enemy.anim:getHeight() / 32
  
  -- extract all the frames in the animation walking tile
  local l, c
  local id = 1
  Enemy.animWalk[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    Enemy.animWalk[id] = love.graphics.newQuad((c-1)*Enemy.w, (l-1)*Enemy.h,
                                              Enemy.w, Enemy.h,
                                              Enemy.anim:getDimensions())
    id = id + 1
    end
  end
end

function Enemy.Update(dt)
  -- manage the walking animation
  if Enemy.mov == "walk" then Enemy.picCurrent = Enemy.picCurrent + (Enemy.speed.animWalk * dt) end
  if math.floor(Enemy.picCurrent) > #Enemy.animWalk then Enemy.picCurrent = 1 end
end

function Enemy.Draw()
  if Enemy.mov == "walk" then love.graphics.draw(Enemy.anim, Enemy.animWalk[math.floor(Enemy.picCurrent)],
                                                 Enemy.x, Enemy.y, 0,
                                                 Enemy.sign * Enemy.scale, 1 * Enemy.scale,
                                                 Enemy.w/2, 1) end
end

return Enemy