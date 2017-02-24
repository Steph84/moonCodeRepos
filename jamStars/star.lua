math.randomseed(os.time()) --initialiser le random
local Star = {}

local listStars = {}
local numStars = 1
local starDiam = 5
local target = {}
local starSpeed = 2
local F = 0

function createStar(pId, pX, pY)
  local item = {}
  local tempRandX = 0
  local tempRandY = 0
  tempRandX = math.random(1, 2)
  tempRandY = math.random(-2, 2)
  
  item.id = pId
  item.x = pX
  item.y = pY
  F = tempRandX
  item.vx = tempRandX
  item.vy = 0
  item.scX = 0.08
  item.scY = 0.08
  
  table.insert(listStars, item)
  return item
end

function Star.Load(pWindowWidth, pWindowHeight)
  target.x = pWindowWidth/2
  target.y = pWindowHeight/2
  
  -- creation of the stars
  local i
  for i = 2, numStars + 1 do
    createStar(i, 600, pWindowHeight/2 + 100)
  end
end

--fonction angle renvoyant l arctangente
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

function Star.Update(dt, pWindowWidth, pWindowHeight)
  
  local i
  for i = 1, #listStars do
    local s = listStars[i]
    
    s.x = s.x + s.vx
    s.y = s.y + s.vy
    
    local dSquare = math.pow((s.x - pWindowWidth/2), 2) + math.pow((s.y - pWindowHeight/2), 2)
    local gravityForce = 1/dSquare
    s.vx = s.vx - gravityForce
    
    local angle = math.angle(s.x, s.y, pWindowWidth/2, pWindowHeight/2)
    local angleDeg = angle*(-1) + 3.14
    print(angleDeg)
    
    s.vy = -F* math.cos(angleDeg)
    s.vx = -F* math.sin(angleDeg)
    print(s.vy)
    
    
  end
end

function Star.Draw()
  local i
  for i = 1, #listStars do
    love.graphics.circle("fill", listStars[i].x, listStars[i].y, starDiam)
  end
end


return Star