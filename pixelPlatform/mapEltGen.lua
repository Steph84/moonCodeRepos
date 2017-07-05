local MapEltGen = {}

function MapEltGen.pit(pColX, pLinY)
  local item = {}
  item.colX = pColX
  item.linY = pLinY
  item.w = math.random(2, 4)
  item.h = 2
  return item
end


return MapEltGen