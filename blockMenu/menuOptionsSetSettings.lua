local SetSettings = {}

local setFileLines = {}
local restOfFile
local lineCount = 1

local myOptionsResolution = require("menuOptionsResolution")

function SetSettings.Load()
  
  local message = "Save the new settings and quit the game ? Then retart the game."
  local buttons = {"Cancel", "Yes"}
  local pressedbutton = love.window.showMessageBox("Settings modified", message, buttons, "info")
  
  if pressedbutton == 1 then
    -- back to title
  elseif pressedbutton == 2 then
  
    local settingFile = io.open("data/dataSettings.txt", "r") -- open the data file
    for line in settingFile:lines() do
      if(lineCount == 3) then -- 3 for resolution
        setFileLines[#setFileLines + 1] = myOptionsResolution.window[1].."x"..myOptionsResolution.window[2]
        restOfFile = settingFile:read("*a")
        break
      else
        lineCount = lineCount + 1
        setFileLines[#setFileLines + 1] = line
      end
    end
    settingFile:close()

    settingFile = io.open("data/dataSettings.txt", "w") --write the file.
    for i, line in ipairs(setFileLines) do
      settingFile:write(line, "\n")
    end
    settingFile:write(restOfFile)
    settingFile:close()
    
    love.event.quit()
  end
  

end

return SetSettings