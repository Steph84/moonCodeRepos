local Rocketv = {}

local listRockets = {}
local rocketPic = {}
rocketPic.src = love.graphics.newImage("pictures/v2.png")
rocketPic.w = rocketPic.src:getWidth()
rocketPic.h = rocketPic.src:getHeight()

local state = "standBy"

function createRocket(ppWindowWidth, ppWindowHeight)
  local item = {}
  
  item.scale = 0.2
  item.x = 50
  item.y = ppWindowHeight - rocketPic.h * item.scale/2
  item.rotation = 0
  item.vx = 0
  item.vy = 0
  
  table.insert(listRockets, item)
  
  return item
end

function Rocketv.Load(pWindowWidth, pWindowHeight)
  
  createRocket(pWindowWidth, pWindowHeight)
  
end

function Rocketv.Update(pDt, pWindowWidth, pWindowHeight)
  if love.keyboard.isDown("space") and state == "standBy" then
    state = "launch"
  end
  
  if state == "launch" or state == "landing" then
    local i
    for i = 1, #listRockets do
      local r = listRockets[i]
      r.rotation = r.rotation + 0.6 * pDt
      r.vx = r.vx + 100 * pDt
      r.x = r.x + r.vx * pDt
    end
  end
  
  if state == "launch" then
    local i
    for i = 1, #listRockets do
      local r = listRockets[i]
      
      r.vy = r.vy + 100 * pDt
      r.y = r.y - r.vy * pDt
      
      if r.y < pWindowHeight/3 then
        state = "landing"
      end
    end
  end
  
  if state == "landing" then
    local i
    for i = #listRockets, 1, -1 do
      local r = listRockets[i]
      r.vy = r.vy - 500 * pDt
      r.y = r.y - r.vy * pDt
      
      if r.y > pWindowHeight - rocketPic.h * r.scale/2 then
        state = "crash"
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