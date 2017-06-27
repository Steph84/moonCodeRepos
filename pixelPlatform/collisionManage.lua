local CollisionManage = {}

function CollisionManage.Collide(pObject1, pObject2, pTexture)
  
  if pTexture == "ground" then
    if pObject1 == pObject2 then return false end
    local dx = pObject1.x - pObject2.x
    local dy = pObject1.y - pObject2.y
    if (math.abs(dx) < (pObject1.w + pObject2.w)) then
      if (math.abs(dy) < (pObject1.h + pObject2.h)) then
       return true
      end
    end
    return false
  end
end

return CollisionManage