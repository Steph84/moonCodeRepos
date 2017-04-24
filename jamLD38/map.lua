local Map = {}

local myControl = require("control")

function Map.Update(pDt, pScreen, pListCities)
  pScreen = myControl.UpdateMap(pDt, pListCities)
  return pScreen
end

return Map