local Credits = {}

local fileObject = nil
local dataObject = nil
local dataNumberLines = 3

function Credits.Load()
  fileObject = love.filesystem.newFile("credits.txt")
  fileObject:open("r")
  --dataObject = fileObject:read()
  fileObject:close()
  
  dataObject = love.filesystem.newFileData("credits.txt")
  
  local comPuter = dataObject:getString()
  print(comPuter)
  
  local test1 = {}
  local test2 = {}
  local iteration = 0
  for line in love.filesystem.lines("credits.txt") do
    table.insert(test1, line)
    iteration = iteration + 1
    
    if iteration == 3 then
      iteration = 0      
      table.insert(test2, test1)
      test1 = {}
    end
  
  end
  
  --print(Credits.File)
  --print(Credits.Data)
  local i, j
  for i = 1, #test2 do
    for j = 1, #test2[i] do
      --print(test2[i][j])
    end
  end
  
  --print(test2[2][2])
  
end

function Credits.Update(pDt)

end

function Credits.Draw()

end

return Credits