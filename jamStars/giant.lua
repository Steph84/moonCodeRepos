math.randomseed(os.time()) --initialiser le random
local Giant = {}

-- load pictures
local giantBlue = {}
local giantRed = {}
local giantWhite = {}
local giantPick = math.random(1, 3)
local giantSpeAnim = 8
local spriteToDraw = nil

local listStars = {}
local numStars = 1
local giantWidth = 1024
local giantHeight = 1024

function createGiant(pId, pSprite, pX, pY)
  local item = {}
  item.id = pId
  item.sprite = pSprite
  item.x = pX
  item.y = pY
  
  item.scX = 0.08
  item.scY = 0.08
  
  table.insert(listStars, item)
  return item
end

function Giant.Load(pWindowWidth, pWindowHeight)
  
  if giantPick == 1 then
    giantBlue.pictures = {}
    local n
    for n = 1, 4 do
      giantBlue.pictures[n] = love.graphics.newImage("pictures/star_blue_giant0"..n..".png")
    end
    giantBlue.picCurrent = 1
    createGiant(1, giantBlue.pictures[1], pWindowWidth/2, pWindowHeight/2)
  elseif giantPick == 2 then
    giantRed.pictures = {}
    local n
    for n = 1, 4 do
      giantRed.pictures[n] = love.graphics.newImage("pictures/star_red_giant0"..n..".png")
    end
    giantRed.picCurrent = 1
    createGiant(1, giantRed.pictures[1], pWindowWidth/2, pWindowHeight/2)
  elseif giantPick == 3 then
    giantWhite.pictures = {}
    local n
    for n = 1, 4 do
      giantWhite.pictures[n] = love.graphics.newImage("pictures/star_white_giant0"..n..".png")
    end
    giantWhite.picCurrent = 1
    createGiant(1, giantWhite.pictures[1], pWindowWidth/2, pWindowHeight/2)
  end
end

function Giant.Update(dt)
  
  if giantPick == 1 then
    giantBlue.picCurrent = giantBlue.picCurrent + (giantSpeAnim * dt)
    if math.floor(giantBlue.picCurrent) > #giantBlue.pictures then
      giantBlue.picCurrent = 1
    end
  elseif giantPick == 2 then
    giantRed.picCurrent = giantRed.picCurrent + (giantSpeAnim * dt)
    if math.floor(giantRed.picCurrent) > #giantRed.pictures then
      giantRed.picCurrent = 1
    end
  elseif giantPick == 3 then
    giantWhite.picCurrent = giantWhite.picCurrent + (giantSpeAnim * dt)
    if math.floor(giantWhite.picCurrent) > #giantWhite.pictures then
      giantWhite.picCurrent = 1
    end
  end
end

function Giant.Draw()
  
  if giantPick == 1 then
    spriteToDraw = giantBlue.pictures[math.floor(giantBlue.picCurrent)]
  elseif giantPick == 2 then
    spriteToDraw = giantRed.pictures[math.floor(giantRed.picCurrent)]
  elseif giantPick == 3 then
    spriteToDraw = giantWhite.pictures[math.floor(giantWhite.picCurrent)]
  end
  
  local i
  for i = 1, #listStars do
    love.graphics.draw(
                        spriteToDraw,
                        listStars[i].x,
                        listStars[i].y,
                        0,
                        listStars[i].scX,
                        listStars[i].scY,
                        giantWidth/2,
                        giantHeight/2
                      )
  end
end

return Giant