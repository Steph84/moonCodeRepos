local GameTrans = {}

local windowWidth, windowHeight
local dataObject = {} -- all the scenario lines
local dataBloc = {} -- bloc of 3 scenario lines
local dataNumberLines = 2 -- 3 lines
local timeElapsed = 0
local endOfText = 0
local param = {}

function GameTrans.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  param.size = 32
  param.typeFace = love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", param.size)
  
  -- load the text of the scenario
  dataObject = {}
  local iteration = 0
  for line in love.filesystem.lines("data/dataScenario.txt") do
    table.insert(dataBloc, line)
    iteration = iteration + 1
    if iteration == dataNumberLines then
      iteration = 0      
      table.insert(dataObject, dataBloc)
      dataBloc = {}
    end
  end
  
  endOfText = 1
  
end

function GameTrans.Update(dt, pGameState)
  
  -- show the scenario text along the time
  timeElapsed = timeElapsed + dt
  
  if timeElapsed > 1 and endOfText < #dataObject then
    endOfText = endOfText + 1
    timeElapsed = 0
  end
  
  if endOfText == #dataObject and timeElapsed > 2 then
    if love.keyboard.isDown("space") then
      pGameState = "game"
    end
  end
  return pGameState
end

function GameTrans.Draw()
  
  -- show the scenario text
  love.graphics.setFont(param.typeFace)
  local i, j
  for i = 1, endOfText do -- foreach block
    for j = 1, #dataObject[i] do -- foreach line in each block
      love.graphics.printf(
                            dataObject[i][j],
                            0,
                            -- offset 5%       + offset between 2 blocks        + offset between 2 lines in the same block
                            windowHeight * 0.05 + (i - 1) * param.size * 4 + (j - 1) * param.size,
                            windowWidth, "center"
                          )
    end
  end
  
  -- show the instruction to continue
  if endOfText == #dataObject and timeElapsed > 2 then
    love.graphics.printf("press space to continue",
                         0, windowHeight - param.size * 1.5,
                         windowWidth - param.size, "right")
  end
end

return GameTrans