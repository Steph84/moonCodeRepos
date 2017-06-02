local Parallax = {}

local windowWidth, windowHeight
local backGroundPic = {}
local animationBelts = {}

local i
for i = 1, 3 do
  backGroundPic[i] = {}
end

function CreateBelt(pLayer, oBackGround, pWindowWidth)
  local item = {}
  
  item.layer = pLayer
  item.scale = oBackGround.scaleH
  local firstPicWidth = oBackGround.w * item.scale
  
  item.nbPic = math.ceil(pWindowWidth/firstPicWidth * 2)
  
  item.coord = {}
  local i
  for i = 1, item.nbPic do
    item.coord[i] = {}
    item.coord[i].x = 0 + (i-1) * firstPicWidth
    item.coord[i].y = 0
  end
  
  table.insert(animationBelts, item)
end

function Parallax.Load(pWindowWidth, pWindowHeight)
  
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  local j
  for j = 1, 3 do
    backGroundPic[j].src =  love.graphics.newImage("pictures/"..j..".png")
    backGroundPic[j].w = backGroundPic[j].src:getWidth()
    backGroundPic[j].h = backGroundPic[j].src:getHeight()
    backGroundPic[j].scaleH = windowHeight/backGroundPic[j].h
    CreateBelt(j, backGroundPic[j], windowWidth)
  end
  
end

function Parallax.Update(dt)
  -- TODO change the x coordinate along specific speed
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