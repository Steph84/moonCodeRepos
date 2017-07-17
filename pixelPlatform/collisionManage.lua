local CollisionManage = {}

function CollisionManage.Collide(pObject1, pObject2, pTexture)
  local isHitted = false
  if pTexture == "ground" then
  
    if pObject1 == pObject2 then return false end
    local dx = pObject1.x - pObject2.x
    local dy = pObject1.y - pObject2.y
    if (math.abs(dx) < (pObject1.w * pObject1.scale + pObject2.w * pObject2.scale)) then
  
      if (math.abs(dy) < (pObject1.h * pObject1.scale + pObject2.h * pObject2.scale)) then
  
        isHitted = true
      end
    end
    
  end
  --print(isHitted)
  return isHitted
end

return CollisionManage