math.randomseed(os.time()) --initialiser le random

local Rocketv = {}

local listRockets = {}
local rocketPic = {}
rocketPic.src = love.graphics.newImage("pictures/v2.png")
rocketPic.w = rocketPic.src:getWidth()
rocketPic.h = rocketPic.src:getHeight()

local timeElapsed = 0
local power = "ready"
local pv = {}
local canPlay = true
local newValue
local forceHome = 0

local myControls = require("controls")

function createRocket(ppWindowWidth, ppWindowHeight, pSide, pForce)
  local item = {}
  
  item.scale = 0.2
  item.y = ppWindowHeight - rocketPic.h * item.scale/2
  item.rotation = 0
  item.vx = 0
  item.vy = 0
  item.side = pSide
  item.state = "standBy"
  item.force = pForce
  
  if pSide == "home" then item.x = 50 end
  if pSide == "foreign" then item.x = ppWindowWidth - rocketPic.w * item.scale/2 - 50 end
  
  table.insert(listRockets, item)
  
  return item
end

function Rocketv.Load(pWindowWidth, pWindowHeight)
  pv.home = 146
  pv.foreign = 146
  
  myControls.Load()
  
  createRocket(pWindowWidth, pWindowHeight, "home", 0)
  
end

function Rocketv.Update(pDt, pWindowWidth, pWindowHeight, pBuilding)
  math.randomseed(os.time())
  if power == "ready" then
    local tempForce = math.random(2, 5) -- 1/4 chance of hit
    createRocket(pWindowWidth, pWindowHeight, "foreign", tempForce)
    power = "processing"
    timeElapsed = 0
  end
  
  if power == "processing" then
    timeElapsed = timeElapsed + pDt
  end
  
  local i
  for i = #listRockets, 1, -1 do
    local r = listRockets[i]
  
    -- manage the start and the flight along x for the player
    if r.side == "home" then
      r.force = forceHome
      if canPlay == false and r.state == "standBy" then r.state = "launch" end
      if r.state == "launch" or r.state == "landing" then
        r.rotation = r.rotation + 0.6 * pDt
        r.vx = r.vx + 100 * pDt
        r.x = r.x + r.vx * pDt
      end
    end
    
    -- manage the start and the flight along x for AI
    if r.side == "foreign" then
      if power == "processing" and r.state == "standBy" and timeElapsed > 3 then r.state = "launch" end
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
      if r.y < pWindowHeight/r.force then r.state = "landing" end
    end
    
    -- manage the landing/crash along y
    if r.state == "landing" then
      r.vy = r.vy - 500 * pDt
      r.y = r.y - r.vy * pDt
      if r.y > pWindowHeight - rocketPic.h * r.scale/2 then
        
        if r.side == "foreign" then
          if r.x > 100 and r.x < (100 + pBuilding.w * pBuilding.scale) then pv.home = pv.home - 30 end
        end
        
        if r.side == "home" then
          if r.x > (pWindowWidth - pBuilding.w * pBuilding.scale - 100) and
             r.x < (pWindowWidth - 100) then
                pv.foreign = pv.foreign - 30
          end
          canPlay = true
        end
        
        r.state = "crash"
        power = "ready"
        table.remove(listRockets, i)
      end
      
      if r.state == "crash" and r.side == "home" then
        r.state = "standBy"
        createRocket(pWindowWidth, pWindowHeight, "home", 0)
      end
      
    end
    
    if pv.home < 0 then
      pv.home = 0
      -- TODO animation destruction
      -- TODO game over screen
    end
    
    canPlay, forceHome = myControls.Update(pDt, canPlay, forceHome)
    
  end
end

function Rocketv.Draw(pWindowWidth, pWindowHeight)
  
  love.graphics.rectangle("line", 100, 500, 150, 10)
  love.graphics.rectangle("line", pWindowWidth - 100 - 150, 500, 150, 10)
  
  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle("fill", 102, 502, pv.home, 6)
  love.graphics.rectangle("fill", pWindowWidth - 102 - 146, 502, pv.foreign, 6)
  
  love.graphics.setColor(255, 255, 255)
  
  local i
  for i = 1, #listRockets do
    local r = listRockets[i]
    love.graphics.draw(rocketPic.src, r.x, r.y, r.rotation, r.scale, r.scale, rocketPic.w/2, rocketPic.h/2)
  end
  
  myControls.Draw()
  
end

return Rocketv