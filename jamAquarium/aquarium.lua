local Aqua = {}

Aqua.waterTexture = {}
local i
for i = 1, 3 do
  Aqua.waterTexture[i] = {}
end

Aqua.grid = {}

function Aqua.Load(pWindowWidth, pWindowHeight)
  local i
  for i = 1, 3 do
    Aqua.waterTexture[i].src = love.graphics.newImage("pictures/water"..i..".png")
    Aqua.waterTexture[i].w = Aqua.waterTexture[i].src:getWidth() -- 512
    Aqua.waterTexture[i].h = Aqua.waterTexture[i].src:getHeight() -- 512
  end
  
  Aqua.waterTexture.scale = Aqua.waterTexture[1].w / 32 -- 16
  Aqua.grid.nbLine = math.ceil(pWindowHeight / 32) -- 22
  Aqua.grid.nbColumn = math.ceil(pWindowWidth / 32) -- 41
  
end


function Aqua.Draw()
  
end

return Aqua