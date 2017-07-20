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

function MapEltGen.genPlatForm(pCoefMap, pMapW, pMapH)
  local paramPlatForm = {} -- list tuples line/column/width
  local listFirstRdm, listSecondRdm, listThirdRdm = {}, {}, {}
  local rand1, rand2, rand3 = 0, 0, 0
  
  local i, j
  for i = 3, (4 * pCoefMap - 3), 2 do
    table.insert(listFirstRdm, i/(4 * pCoefMap))
    table.insert(listThirdRdm, i/(4 * pCoefMap))
  end
  for j = 4, (4 * pCoefMap - 4), 4 do table.insert(listSecondRdm, j/(4 * pCoefMap)) end
  
  while #paramPlatForm < pCoefMap do
    rand1 = math.random(#listFirstRdm)
                      -- return -1 or 1           return 1 or 2
    local offSetRdm = ((math.random(1,2)*2)-3) * math.random(1, 2) -- return -2, -1, 1 or 2
    table.insert(paramPlatForm, {
                                  lin = pMapH - 5,
                                  col = math.floor((listFirstRdm[rand1] * pMapW)) + offSetRdm,
                                  width = math.random(3, 7)
                                })
    table.remove(listFirstRdm, rand1)
  end
  while #paramPlatForm < 2*pCoefMap - 1 do
    rand2 = math.random(#listSecondRdm)
    local offSetRdm = ((math.random(1,2)*2)-3) * math.random(1, 2)
    table.insert(paramPlatForm, {
                                  lin = pMapH - 9,
                                  col = math.floor((listSecondRdm[rand2] * pMapW)) + offSetRdm,
                                  width = math.random(3, 6)
                                })
    table.remove(listSecondRdm, rand2)
  end
  while #paramPlatForm < 3*pCoefMap - 1 do
    rand3 = math.random(#listThirdRdm)
    local offSetRdm = ((math.random(1,2)*2)-3) * math.random(1, 2)
    table.insert(paramPlatForm, {
                                  lin = pMapH - 13,
                                  col = math.floor((listThirdRdm[rand3] * pMapW)) + offSetRdm,
                                  width = math.random(5, 9)
                                })
    table.remove(listThirdRdm, rand3)
  end
  return paramPlatForm
end



return MapEltGen