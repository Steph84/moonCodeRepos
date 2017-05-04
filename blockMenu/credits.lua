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

function Credits.Update(pDt, pGameState)
  if love.keyboard.isDown("escape") then pGameState = "title" end
  return pGameState
end

function Credits.Draw(pWindowWidth, pWindowHeight, pFontSize)
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(love.graphics.newFont("fonts/Capture_it.ttf", pFontSize * 2))
  
  love.graphics.printf("The Credits", 0, pWindowHeight * 0.05, pWindowWidth, "center")
  
  love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", pFontSize))
  local i, j
  for i = 1, #dataObject do
    for j = 1, #dataObject[i] do
      love.graphics.printf(dataObject[i][j],
                           pWindowWidth * 0.1,
                           -- offset 10%       + offset between 2 blocks   + offset between 2 lines in the same block
                           pWindowHeight * 0.2 + (i - 1) * pFontSize * 3.5 + (j - 1) * pFontSize,
                           pWindowWidth, "left")
    end
  end
  
  love.graphics.printf("To get back, press escape ", 0, pWindowHeight - pFontSize, pWindowWidth, "right")
  
end

return Credits