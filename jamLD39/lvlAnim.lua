local LevelAnimation = {}

local haloPic, beamPic = {}, {}
local timeElapsed = 0
local TILE_ANIM_SIZE = 64
local beamInstalled = false
local soundTeleport = {}


function LevelAnimation.Load()
  
  -- load sound effects for level transition
  soundTeleport.beam = love.audio.newSource("sounds/teleport.wav", "static")
  soundTeleport.machina = love.audio.newSource("sounds/teleport2.wav", "static")
  
  -- load the halo animation tile
  haloPic.src = love.graphics.newImage("pictures/haloAnimLD39.png")
  local nbColumns = haloPic.src:getWidth() / TILE_ANIM_SIZE
  local nbLines = haloPic.src:getHeight() / TILE_ANIM_SIZE
  haloPic.picCurrent = 1
  haloPic.speedAnim = 5
  haloPic.anim = {}
  
  -- extract all the frames in the halo animation tile
  local l, c
  local id = 1
  haloPic.anim[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    haloPic.anim[id] = love.graphics.newQuad((c-1)*TILE_ANIM_SIZE, (l-1)*TILE_ANIM_SIZE,
                                             TILE_ANIM_SIZE, TILE_ANIM_SIZE,
                                             haloPic.src:getDimensions())
    id = id + 1
    end
  end
  
  -- load the beam animation tile
  beamPic.src = love.graphics.newImage("pictures/beamAnimLD39.png")
  beamPic.scale = 1
  beamPic.extend = 0
  
end

function LevelAnimation.Update(dt, pMachina, pLvlTrans)
  
  -- manage the halo animation
  haloPic.picCurrent = haloPic.picCurrent + (haloPic.speedAnim * dt)
  if math.floor(haloPic.picCurrent) > #haloPic.anim then haloPic.picCurrent = 1 end
  
  if beamInstalled == false then
    -- manage the beam animation
    beamPic.scale = beamPic.scale + dt * 7.5
    beamPic.extend = beamPic.extend - dt * 240
    haloPic.x = (pMachina.col-1) * 32 - TILE_ANIM_SIZE/4
    haloPic.y = (pMachina.lin-1) * 32 - TILE_ANIM_SIZE/4
    beamPic.x = (pMachina.col-1) * 32
    beamPic.y = (pMachina.lin-1) * 32 - TILE_ANIM_SIZE/4 + beamPic.extend
    soundTeleport.beam:play()
    if beamPic.y < 0 then beamInstalled = true end
    
  end
  
  -- manage the Machina teleportation
  if beamInstalled == true then
    pMachina.lin = pMachina.lin - dt * 5
    soundTeleport.machina:play()
    if pMachina.lin < 0 then
      pLvlTrans = false
      pMachina.isHere = false
      beamInstalled = false
      beamPic.scale = 1
      beamPic.extend = 0
    end
  end
  
  return pLvlTrans
end

function LevelAnimation.Draw(pMachina)
  love.graphics.draw(haloPic.src, haloPic.anim[math.floor(haloPic.picCurrent)], haloPic.x, haloPic.y)
  
  love.graphics.draw(beamPic.src, beamPic.x, beamPic.y, 0, 1, beamPic.scale)
  
end

return LevelAnimation