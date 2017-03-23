local Rocketv = {}

local listRockets = {}
local rocketPic = {}
rocketPic.src = love.graphics.newImage("pictures/v2.png")
rocketPic.w = rocketPic.src:getWidth()
rocketPic.h = rocketPic.src:getHeight()

local timeElapsed = 0

function createRocket(ppWindowWidth, ppWindowHeight, pSide)
  local item = {}
  
  item.scale = 0.2
  item.y = ppWindowHeight - rocketPic.h * item.scale/2
  item.rotation = 0
  item.vx = 0
  item.vy = 0
  item.side = pSide
  item.state = "standBy"
  
  if pSide == "home" then item.x = 50 end
  if pSide == "foreign" then item.x = ppWindowWidth - rocketPic.w * item.scale/2 - 50 end
  
  table.insert(listRockets, item)
  
  return item
end

function Rocketv.Load(pWindowWidth, pWindowHeight)
  
  createRocket(pWindowWidth, pWindowHeight, "home")
  createRocket(pWindowWidth, pWindowHeight, "foreign")
  
end

function Rocketv.Update(pDt, pWindowWidth, pWindowHeight)
  
  timeElapsed = timeElapsed + pDt
  
  local i
  for i = #listRockets, 1, -1 do
    local r = listRockets[i]
  
    -- manage the start and the flight along x for the player
    if r.side == "home" then
      if love.keyboard.isDown("space") and r.state == "standBy" then r.state = "launch" end
      if r.state == "launch" or r.state == "landing" then
        r.rotation = r.rotation + 0.6 * pDt
        r.vx = r.vx + 100 * pDt
        r.x = r.x + r.vx * pDt
      end
    end
    
    -- manage the start and the flight along x for AI
    if r.side == "foreign" then
      if r.state == "standBy" and timeElapsed > 5 then r.state = "launch" end
      if r.state == "launch" or r.state == "landing" then
        r.rotation = r.rotation - 0.6 * pDt
        r.vx = r.vx + 100 * pDt
        r.x = r.x - r.vx * pDt
      end
    end
  
    -- manage the ascencion along y
    if r.state == "launch" then
      r.vy = r.vy + 100 * pDt
      r.y = r.y - r.vy * pDt
      if r.y < pWindowHeight/3 then r.state = "landing" end
    end
    
    -- manage the landing/crash along y
    if r.state == "landing" then
      r.vy = r.vy - 500 * pDt
      r.y = r.y - r.vy * pDt
      if r.y > pWindowHeight - rocketPic.h * r.scale/2 then
        r.state = "crash"
        table.remove(listRockets, i)
      end
    end
    
  end
end

function Rocketv.Draw(pWindowWidth, pWindowHeight)
  local i
  for i = 1, #listRockets do
    local r = listRockets[i]
    love.graphics.draw(rocketPic.src, r.x, r.y, r.rotation, r.scale, r.scale, rocketPic.w/2, rocketPic.h/2)
  end
end

return Rocketv