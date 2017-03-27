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
  
  -- initialize the grid
  local l, c
  for l = 1, Aqua.grid.nbLine do
    Aqua.grid[l] = {}
    for c = 1, Aqua.grid.nbColumn do
      Aqua.grid[l][c] = 1
    end
  end
  
end


function Aqua.Draw()
  
  --[[
  local l, c
  local bx, by = 0, 0
  
  for l = 1, 6 do
    bx = 0
    for c = 1, 15 do
      if niveau[l][c] == 1 then
        --dessine
        love.graphics.rectangle("fill", bx + 1, by + 1, brique.largeur - 2, brique.hauteur - 2)
      end
      bx = bx + brique.largeur
    end
    by = by + brique.hauteur
  end
  --]]
end

return Aqua