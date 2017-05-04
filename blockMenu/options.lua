local Options = {}

local Resolution = {}
Resolution.displayScreen = { 0, 0 }
Resolution.window = { 0, 0 }

Options.resolution = { 0, 0 }

function Options.Load()
  Resolution.displayScreen[1], Resolution.displayScreen[2] = love.window.getDesktopDimensions(1)
  --print(Resolution.displayScreen[1], Resolution.displayScreen[2])
  
  modes = love.window.getFullscreenModes(1)
  local i
  for i = 1, #modes do
    --print(modes[i].width, modes[i].height)
  end
  
  width, height, flags = love.window.getMode()
  print(width, height, flags)
  local j
  for j = 1, #flags do
    print(flags[i])
  end
  
end

return Options