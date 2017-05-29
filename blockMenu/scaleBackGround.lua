local ScaleBackGround = {}

function ScaleBackGround.Load(pWScale, pHScale)
  
  if pWScale > pHScale and pWScale > 1 and pHScale > 1 then
    pWScale = pHScale
  elseif pWScale < pHScale and pWScale > 1 and pHScale > 1 then
    pHScale = pWScale
  elseif pWScale > pHScale and pWScale < 1 and pHScale < 1 then
    pWScale = 1/pWScale
    pHScale = 1/pHScale
  elseif pWScale < pHScale and pWScale < 1 and pHScale < 1 then -- validated
    pWScale = 1/pWScale
    pHScale = pWScale
  elseif pWScale > pHScale and pWScale > 1 and pHScale < 1 then
    pHScale = pWScale
  elseif pWScale < pHScale and pWScale < 1 and pHScale > 1 then
    pWScale = 1/pWScale
    pHScale = 1/pHScale
  elseif pWScale == pHScale and pWScale > 1 and pHScale > 1 then -- validated
    pWScale = 1/pWScale
    pHScale = 1/pHScale
  elseif pWScale == pHScale and pWScale < 1 and pHScale < 1 then
    pWScale = pHScale
  end
  
  return pWScale, pHScale
end

return ScaleBackGround