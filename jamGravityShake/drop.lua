math.randomseed(os.time()) --initialiser le random
local Drop = {}

local Splash = require("splash")

local listDrops = {}
local listSplashes = {}
local dropPic = {}
dropPic.src = love.graphics.newImage("pictures/singleDrop.png")
dropPic.scale = 3
local dropQty = 1
Drop.splash = false
local dropSplashUpadte = false

function createDrop(pId, pSprite, ppWindowWidth)
  local thisDrop = {}
  thisDrop.w = pSprite:getWidth()
  thisDrop.h = pSprite:getHeight()
  
  local randValueX = 0
  local randValueY = 0
  local randValueVY = 0
  randValueX = math.random(0, ppWindowWidth)
  randValueY = math.random(-(100 + thisDrop.h/dropPic.scale), -thisDrop.h/dropPic.scale)
  randValueVY = math.random(50, 400)
  
  thisDrop.id = pId
  thisDrop.x = randValueX
  thisDrop.y = randValueY
  thisDrop.vy = randValueVY
  
  table.insert(listDrops, thisDrop)
  return thisDrop
end

function Drop.Load(pWindowWidth, pWindowHeight)
  local i
  for i = 1, dropQty do
    createDrop(i, dropPic.src, pWindowWidth)
  end
  Splash.Load()
end

function Drop.Update(dt, pWindowWidth, pWindowHeight)
  
  for i = #listDrops, 1, -1 do -- parse list backward for the removing
    -- movement through the screen
    local t = listDrops[i]
    t.y = t.y + t.vy*dt
    
    if t.y > pWindowHeight then
      table.insert(listSplashes, t.x)
      table.remove(listDrops, i)
    end
    
    if t.y > pWindowHeight/3 and t.y < pWindowHeight/2 and #listDrops < (dropQty*2) then createDrop(i + 10, dropPic.src, pWindowWidth) end
  
    if #listSplashes > 0 then
      local b
      b = Splash.Update(dt, listSplashes[1])
      print(b)
      if b == true then
        table.remove(listSplashes, 1)
        print("machin")
      end
    end
  end
  
end

function Drop.Draw(pWindowHeight)
  local i
  for i = 1, #listDrops do
    local t = listDrops[i]
    love.graphics.draw(dropPic.src, t.x, t.y, 0, 1/dropPic.scale, 1/dropPic.scale, t.w/2, t.h/2)
    love.graphics.print(i, t.x + 5, t.y + 5)
  end
  
  love.graphics.print("number of drops "..#listDrops, 5, 5)
  love.graphics.print("number of splashes "..#listSplashes, 5, 15)
  if Drop.splash == true then
    Splash.Draw(pWindowHeight)
    Drop.splash = false
  end
  
    Splash.Draw(pWindowHeight)
end

  

return Drop