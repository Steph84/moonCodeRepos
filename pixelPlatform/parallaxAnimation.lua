local Parallax = {}
Parallax.fullSpeed = false

local windowWidth, windowHeight
local backGroundPic = {}
local animationBelts = {}

local i
for i = 1, 3 do
  backGroundPic[i] = {}
end

function CreateBelt(pLayer, oBackGround, pWindowWidth, pCoefMap)
  local item = {}
  
  item.layer = pLayer -- 1 is the farest, 3 is the nearest
  item.scale = oBackGround.scaleH -- the height dominate
  item.picWidth = oBackGround.w * item.scale
  item.speed = pLayer * 0.004/(pCoefMap/4) -- coefMap * 2 => speed / 2
  item.nbPic = math.ceil(pWindowWidth/item.picWidth) + 1 -- determine the minimum number of pics
  
  -- coordinates of all the pics
  item.coord = {}
  local i
  for i = 1, item.nbPic do
    item.coord[i] = {}
    item.coord[i].x = 0 + (i-1) * item.picWidth
    item.coord[i].y = 0
  end
  
  table.insert(animationBelts, item)
end

function Parallax.Load(pWindowWidth, pWindowHeight, pCoefMap)
  
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  local j
  for j = 1, 3 do
    backGroundPic[j].src =  love.graphics.newImage("pictures/"..j..".png")
    backGroundPic[j].w = backGroundPic[j].src:getWidth()
    backGroundPic[j].h = backGroundPic[j].src:getHeight()
    backGroundPic[j].scaleH = windowHeight/backGroundPic[j].h
    CreateBelt(j, backGroundPic[j], windowWidth, pCoefMap)
  end
  
end

function Parallax.Update(dt, pHeroSign, pHeroSpeed)
  
  local i, j
  for i = 1, #animationBelts do
    local thisBelt = animationBelts[i]
    for j = 1, #thisBelt.coord do
      local thisPic = thisBelt.coord[j]
      
      -- make the belts moving
      thisPic.x = thisPic.x - pHeroSign * pHeroSpeed * thisBelt.speed * dt
      
      -- when the first pic disapears, it moves to the end
      if (thisPic.x + thisBelt.picWidth) < 0 then thisPic.x = thisPic.x + thisBelt.nbPic * thisBelt.picWidth end 
      if thisPic.x > windowWidth then thisPic.x = thisPic.x - thisBelt.nbPic * thisBelt.picWidth end
    end
  end
end

function Parallax.Draw()
  
  local i, j
  for i = 1, #animationBelts do
    local thisBelt = animationBelts[i]
    for j = 1, #thisBelt.coord do
      local thisPic = thisBelt.coord[j]
      love.graphics.draw(backGroundPic[i].src, thisPic.x, thisPic.y, 0, thisBelt.scale, thisBelt.scale)
    end
  end
  
end

return Parallax