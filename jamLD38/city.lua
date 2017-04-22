local City = {}

-- TODO list of colors

function City.Load(pId, pName)
  local item = {}
  
  item.Id = pId
  item.Name = pName
  -- item.Color = 
  --item.X = 
  --item.Y = 
  item.BuildingNumber = {0, 0, 0} -- Residential, Commercial, Industrial
  item.Population = 1
  item.Food = 0
  item.Treasury = 2000

  return item
end

function City.Update(pDt)
  -- TODO all the calculation : ratio, growth
end

return City