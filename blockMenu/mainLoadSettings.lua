local LoadSettings = {}

LoadSettings.resolution = { 0, 0 }

function LoadSettings.Load()
  
  local settingFile = io.open("data/dataSettings.txt", "r") -- open the data file
  local pos = 0
  
  for line in settingFile:lines() do -- foreach line in the file
    for word in string.gmatch(line, "%d+x%d+") do -- foreach word in the line, get the sequence which match whith numberXnumber
      for value in string.gmatch(word, "%d+") do -- foreach value in this sequence, get the values that are numbers
        pos = pos + 1
        LoadSettings.resolution[pos] = value -- then set the loading resolution with those numbers
      end
    end
  end
  settingFile:close() -- close the file

end

return LoadSettings