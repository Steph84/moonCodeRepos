math.randomseed(os.time()) --initialiser le random
local Drop = {}

local Splash = require("splash")

local listDrops = {}
local listSplashes = {}
local dropPic = {}
dropPic.src = love.graphics.newImage("pictures/singleDrop.png")
dropPic.scale = 5
local dropQty = 50
Drop.splash = false
local dropSplashUpadte = false
local coorRange = 50

function createDrop(pId, pSprite, ppWindowWidth)
  local thisDrop = {}
  thisDrop.w = pSprite:getWidth()
  thisDrop.h = pSprite:getHeight()
  
  local randValueX = 0
  local randValueY = 0
  local randValueVY = 0
  randValueX = math.random(0, ppWindowWidth) -- drops all over the width
  randValueY = math.random(-(100 + thisDrop.h/dropPic.scale), -thisDrop.h/dropPic.scale) -- drops in an range area above the screen
  randValueVY = math.random(50, 400) -- range of speed of the fall
  
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

function Drop.Update(dt, pWindowWidth, pWindowHeight, pAlpha, pBeta, pNewCreation)
  
  -- to create another set of drops (space key)
  if pNewCreation == true then
    local i
    for i = 1, dropQty do
      createDrop(i, dropPic.src, pWindowWidth)
    end
  end
  
  -- determine the area around the cursor the gravity is stopped
  local xMin = pAlpha - coorRange
  local xMax = pAlpha + coorRange
  local yMin = pBeta - coorRange
  local yMax = pBeta + coorRange
  
  for i = #listDrops, 1, -1 do -- parse list backward for the removing
    -- movement through the screen
    local t = listDrops[i]
    local oldVY = t.vy
    t.y = t.y + t.vy*dt
    
    -- gravity stopped
    if t.x > xMin and
       t.x < xMax and
       t.y > yMin and
       t.y < yMax then
          t.vy = 0
    else
      t.vy = t.vy + 100*dt -- gravity back to "normal"
    end
    
    -- if the drop leave the screen, stock the x coordinate for the splash and remove it
    if t.y > pWindowHeight then
      table.insert(listSplashes, t.x)
      table.remove(listDrops, i)
    end
    
    -- when the drops are in a defined area, another set of drops are created
    if t.y > pWindowHeight/3 and
       t.y < pWindowHeight/2 and
       #listDrops < (dropQty*2) then
          createDrop(i + 10, dropPic.src, pWindowWidth) end
  
    -- to run the splash animation
    if #listSplashes > 0 then
      local b
      b = Splash.Update(dt, listSplashes[1])
      if b == true then table.remove(listSplashes, 1) end
    end
    
    -- glut for the memory leak of the splash coordinates...
    if #listSplashes > 10 then
      local d
      for d = 1, #listSplashes do
        table.remove(listSplashes, d)
      end
    end
  end
end

function Drop.Draw(pWindowHeight)
  local i
  for i = 1, #listDrops do
    local t = listDrops[i]
    love.graphics.draw(dropPic.src, t.x, t.y, 0, 1/dropPic.scale, 1/dropPic.scale, t.w/2, t.h/2)
    -- love.graphics.print(i, t.x + 5, t.y + 5)
  end
  
  -- love.graphics.print("number of drops "..#listDrops, 5, 5)
  -- love.graphics.print("number of splashes "..#listSplashes, 5, 20)
  
  if Drop.splash == true then
    Splash.Draw(pWindowHeight)
    Drop.splash = false
  end
  
    Splash.Draw(pWindowHeight)
end

return Drop