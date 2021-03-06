local Saturn = {}

local mySaturn = {}
local propulse = {}
local timeElapsed = 0

function Saturn.Load(ppWindowWidth, ppWindowHeight)
  -- load the Saturn rocket
  mySaturn.src = love.graphics.newImage("pictures/saturnV.png")
  mySaturn.w = mySaturn.src:getWidth()
  mySaturn.h = mySaturn.src:getHeight()
  mySaturn.x = ppWindowWidth/2
  local v2Height = 121.2 -- hard value...
  local ratio = 8 -- height ratio between V2 and Saturn V
  mySaturn.idealHeight = v2Height * ratio
   -- calculate the real height but correction to fit on the screen
  mySaturn.scale = (mySaturn.idealHeight / mySaturn.h) * (3/5)
  mySaturn.y = ppWindowHeight - mySaturn.h * mySaturn.scale/2
  
  -- load the propulse fire pic
  propulse.src = love.graphics.newImage("pictures/fire.png")
  propulse.w = propulse.src:getWidth()
  propulse.h = propulse.src:getHeight()
  propulse.scale = mySaturn.w * mySaturn.scale / propulse.w
  propulse.x = mySaturn.x
  propulse.y = mySaturn.y + mySaturn.h * mySaturn.scale/2 + propulse.h * propulse.scale/2
  
end

function Saturn.Update(ppDt)
  timeElapsed = timeElapsed + ppDt
  
  -- manage the move of the rocket + propulse pics
  if timeElapsed > 2 then
    mySaturn.y = mySaturn.y - 4
    propulse.y = propulse.y - 4
  end
  
end

function Saturn.Draw()
  love.graphics.draw(mySaturn.src, mySaturn.x, mySaturn.y, 0, mySaturn.scale, mySaturn.scale, mySaturn.w/2, mySaturn.h/2)
  love.graphics.draw(propulse.src, propulse.x, propulse.y, 0, -propulse.scale, -propulse.scale, propulse.w/2, propulse.h/2)
end

return Saturn