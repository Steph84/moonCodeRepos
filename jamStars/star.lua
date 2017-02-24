math.randomseed(os.time()) --initialiser le random
local Star = {}

local listStars = {}
local numStars = 1000
local starDiam = 5
local target = {}
local starSpeed = 2
local coef = 0
    
function createStar(pId, ppWindowWidth, ppWindowHeight, pCoef)
  local item = {}
  local tempRandX = math.random(-5, 5)
  local randX = math.random(0, ppWindowWidth)
  local randY = math.random(0, ppWindowHeight)
  local ratioEllipse = math.random(18, 20)/10
  
  local spotBlue = math.random(100, 255)
  local spotRed = math.random(100, 255)
  local spotGreen = math.random(100, 255)
  
  item.id = pId
  item.x = randX
  item.y = randY
  
  item.vx = tempRandX
  item.vy = 0
  item.scX = 0.08
  item.scY = 0.08
  item.ratio = ratioEllipse
  item.blue = spotBlue
  item.green = spotGreen
  item.red = spotRed
  item.coef = pCoef
  
  table.insert(listStars, item)
  return item
end

function Star.Load(pWindowWidth, pWindowHeight)
  target.x = pWindowWidth/2
  target.y = pWindowHeight/2
  
  -- creation of the stars
  local i
  for i = 2, numStars + 1 do
    if i < numStars/2 then coef = 5 else coef = -5 end
    createStar(i, pWindowWidth, pWindowHeight, coef)
  end
end

--fonction angle renvoyant l arctangente
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

function Star.Update(dt, pWindowWidth, pWindowHeight)
  
  local i
  for i = #listStars, 1, -1 do
    local s = listStars[i]
    
    s.x = s.x + s.vx
    s.y = s.y + s.vy
    
    --[[
    local dSquare = math.pow((s.x - pWindowWidth/2), 2) + math.pow((s.y - pWindowHeight/2), 2)
    local gravityForce = 1/dSquare
    s.vx = s.vx - gravityForce
    --]]
    
    local angle = math.angle(s.x, s.y, pWindowWidth/2, pWindowHeight/2)
    local angleDeg = angle*(-1) + 3.14
    --[[
    s.vy = s.coef * math.cos(angleDeg)
    s.vx = s.coef * math.sin(angleDeg) * s.ratio
    --]]
    s.vy = 5 * math.cos(angleDeg)
    s.vx = 5 * math.sin(angleDeg) * s.ratio
    
    if s.x > (pWindowWidth + pWindowWidth/20) then table.remove(listStars, i) end
    
  end
end

function Star.Draw()
  local i
  for i = 1, #listStars do
    local s = listStars[i]
    love.graphics.setColor(s.red, s.green, s.blue)
    love.graphics.circle("fill", s.x, s.y, starDiam)
    love.graphics.setColor(255, 255, 255)
  end
  love.graphics.print("number of stars : "..#listStars, 10, 10)
end


return Star