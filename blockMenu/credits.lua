local Credits = {}

local dataObject = {}
local dataBloc = {}
local dataNumberLines = 3

function Credits.Load()
  
  local iteration = 0
  for line in love.filesystem.lines("credits.txt") do
    table.insert(dataBloc, line)
    iteration = iteration + 1
    
    if iteration == 3 then
      iteration = 0      
      table.insert(dataObject, dataBloc)
      dataBloc = {}
    end
  end
  
end

function Credits.Update(pDt)

end

function Credits.Draw(pWindowWidth, pWindowHeight, pFontSize)
  
  love.graphics.setColor(250, 250, 250)
  love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", pFontSize))
  
  local i, j
  for i = 1, #dataObject do
    for j = 1, #dataObject[i] do
      love.graphics.printf(dataObject[i][j], 0, pWindowHeight * 0.01 + (i + 1) * pFontSize, pWindowWidth, "center")
    end
  end
  
end

return Credits