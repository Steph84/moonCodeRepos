math.randomseed(os.time()) --initialiser le random
local Star = {}

local listStars = {}
local numStars = 1
local starDiam = 5

function createStar(pId, pX, pY)
  local item = {}
  local tempRandX = 0
  local tempRandY = 0
  tempRandX = math.random(1, 2)
  tempRandY = math.random(-2, 2)
  
  item.id = pId
  item.x = pX
  item.y = pY
  
  item.vx = 0
  item.vy = 0
  item.scX = 0.08
  item.scY = 0.08
  
  table.insert(listStars, item)
  return item
end

function Star.Load(pWindowWidth, pWindowHeight)
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
    s.vx = s.vx - gravityForce*100
    local angle = math.angle(s.x, s.y, pWindowWidth/2, pWindowHeight/2)
    print(angle*180/3.14)
    
  end
end

function Star.Draw()
  local i
  for i = 1, #listStars do
    love.graphics.circle("fill", listStars[i].x, listStars[i].y, starDiam)
  end
end


return Star