math.randomseed(os.time())

local MapEltGen = {}

function MapEltGen.pit(pColX, pMapH)
  local item = {}
  item.w = math.random(4, 6)
  item.h = 2
  item.colX = pColX
  item.linY = pMapH - item.h/2
  return item
end

function MapEltGen.hill(pColX, pMapH)
  local item = {}
  item.w = math.random(3, 5)
  item.h = 4
  item.colX = pColX
  item.linY = pMapH - item.h - 1
  return item
end

function MapEltGen.platForm(pColX, pMapH)
  local item = {}
  item.w = math.random(4, 8)
  item.h = 1
  item.colX = pColX
  item.linY = pMapH - item.h - 1
  return item
end

return MapEltGen