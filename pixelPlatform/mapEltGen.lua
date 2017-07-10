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

function MapEltGen.genPlatForm(pCoefMap, pMapW, pMapH)
  local paramPlatForm = {} -- list tuples line/column
  local listFirstRdm, listSecondRdm, listThirdRdm = {}, {}, {}
  local rand1, rand2, rand3 = 0, 0, 0
  
  local i, j
  for i = 3, 13, 2 do
    table.insert(listFirstRdm, i/(4 * pCoefMap))
    table.insert(listThirdRdm, i/(4 * pCoefMap))
  end
  for j = 4, 12, 2 do table.insert(listSecondRdm, j/(4 * pCoefMap)) end
  
  while #paramPlatForm < pCoefMap do
    rand1 = math.random(#listFirstRdm)
    table.insert(paramPlatForm, {lin = pMapH - 5, col = (listFirstRdm[rand1] * pMapW), width = math.random(4, 8})
    table.remove(listFirstRdm, rand1)
  end
  while #paramPlatForm < 2*pCoefMap do
    rand2 = math.random(#listSecondRdm)
    table.insert(paramPlatForm, {lin = pMapH - 9, col = (listSecondRdm[rand2] * pMapW), width = math.random(4, 8}})
    table.remove(listSecondRdm, rand2)
  end
  while #paramPlatForm < 3*pCoefMap do
    rand3 = math.random(#listThirdRdm)
    table.insert(paramPlatForm, {lin = pMapH - 13, col = (listThirdRdm[rand3] * pMapW), width = math.random(4, 8}})
    table.remove(listThirdRdm, rand3)
  end
  return paramPlatForm
end



return MapEltGen