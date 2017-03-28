math.randomseed(os.time())

local JellyFish = {}

-- TODO change Animal to JellyFish
-- an object by animal instead

JellyFish.scale = 0.2

function JellyFish.Load(pWindowWidth, pWindowHeight)
  
  JellyFish.pictures = {}
  local n
  for n = 1, 12 do
    JellyFish.pictures[n] = love.graphics.newImage("pictures/jellyFish"..n..".png")
  end   
  
  JellyFish.w = JellyFish.pictures[1]:getWidth() -- 270
  JellyFish.h = JellyFish.pictures[1]:getHeight() -- 307
  
  JellyFish.picCurrent = 1
  
  JellyFish.x = math.random(0, pWindowWidth)
  JellyFish.y = math.random(0, pWindowHeight)
  
  JellyFish.vx = 0
  JellyFish.vy = 0
  
  while JellyFish.vx == 0 do JellyFish.vx = math.random(-10, 10)/10 end
  while JellyFish.vy == 0 do JellyFish.vy = math.random(-10, 10)/10 end
  
end

function JellyFish.Update(pDt, pWindowWidth, pWindowHeight)
  JellyFish.picCurrent = JellyFish.picCurrent + (10 * pDt) -- using the delta time
  
  if math.floor(JellyFish.picCurrent) > #JellyFish.pictures then
    JellyFish.picCurrent = 1
  end
  
  JellyFish.x = JellyFish.x + JellyFish.vx
  JellyFish.y = JellyFish.y + JellyFish.vy
  
  if JellyFish.x < 0 or JellyFish.x > pWindowWidth then JellyFish.vx = - JellyFish.vx end
  
  if JellyFish.y < 0 or JellyFish.y > pWindowHeight then JellyFish.vy = - JellyFish.vy end
  
end

function JellyFish.Draw()
  love.graphics.draw(
                      JellyFish.pictures[math.floor(JellyFish.picCurrent)],
                      JellyFish.x,
                      JellyFish.y,
                      0,
                      JellyFish.scale,
                      JellyFish.scale,
                      JellyFish.w/2,
                      JellyFish.h/2
                      )
end

return JellyFish