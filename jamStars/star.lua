local Star = {}

function createGiant(pId, pSprite, pX, pY)
  local item = {}
  item.id = pId
  item.sprite = pSprite
  item.x = pX
  item.y = pY
  
  item.vx = 0
  item.vy = 0
  item.scX = 0.08
  item.scY = 0.08
  
  table.insert(listStars, item)
  return item
end



  -- creation of the other stars
  --[[
  local i
  for i = 2, numStars + 1 do
    createStar(i, star01, pWindowWidth/2, pWindowHeight/2)
  end
  --]]
  
  return Star