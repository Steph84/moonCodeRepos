local GameTrans = {}

local windowWidth, windowHeight
local dataObject = {} -- all the scenario lines
local dataBloc = {} -- bloc of 3 scenario lines
local timeElapsed = 0
local endOfText = 0
local param = {}

function GameTrans.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  param.size = 32
  param.typeFace = love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", param.size)
  
  dataObject = {}
  local iteration = 0
  for line in love.filesystem.lines("data/dataScenario.txt") do
    table.insert(dataBloc, line)
    iteration = iteration + 1
    if iteration == 3 then
      iteration = 0      
      table.insert(dataObject, dataBloc)
      dataBloc = {}
    end
  end
  
  endOfText = 1
  
end

function GameTrans.Update(dt, pGameState)
  timeElapsed = timeElapsed + dt
  
  if timeElapsed > 1 and endOfText < #dataObject then
    endOfText = endOfText + 1
    timeElapsed = 0
  end
  
  if endOfText == #dataObject and timeElapsed > 2 then
    -- TODO if enter key pressed
    pGameState = "game"
    
  end
  return pGameState
end

function GameTrans.Draw()
  love.graphics.setFont(param.typeFace)
  local i, j
  for i = 1, endOfText do -- foreach block
    for j = 1, #dataObject[i] do -- foreach line in each block
      love.graphics.printf(
                            dataObject[i][j],
                            0,
                            -- offset 10%       + offset between 2 blocks        + offset between 2 lines in the same block
                            windowHeight * 0.1 + (i - 1) * param.size * 5 + (j - 1) * param.size,
                            windowWidth, "center"
                          )
    end
  end
  
  if endOfText == #dataObject and timeElapsed > 2 then
  -- TODO draw press enter to play
  end
end

return GameTrans