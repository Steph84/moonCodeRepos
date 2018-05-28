local WindowDimension = {}

local NewGameWindowWidth, NewGameWindowHeight, GameSizeCoefficient, IsFullScreen

local ListResolution = { -- displayRes / gameWindowRes / coef
                          { 1024, 768, 1152, 576, 1 },
                          { 1920, 1080, 1728, 864, 1.5 },
                          { 2560, 1440, 2304, 1152, 2 },
                          { 3840, 2160, 3456, 1728, 3 }
                       };

function WindowDimension.Load()
  NewGameWindowWidth = ListResolution[1][3]
  NewGameWindowHeight = ListResolution[1][4]
  GameSizeCoefficient = ListResolution[1][5]
  IsFullScreen = false
  
  local displayWidth, displayHeight
  displayWidth, displayHeight = love.window.getDesktopDimensions()
  
  for line = 1, #ListResolution do
    if displayHeight >= ListResolution[line][2] then
      NewGameWindowWidth = ListResolution[line][3]
      NewGameWindowHeight = ListResolution[line][4]
      GameSizeCoefficient = ListResolution[line][5];
    else
      break
    end
  end
  -- check if the GameWindow overlap the Display
  if NewGameWindowWidth > displayWidth then
    -- if so, don t bother, switch to fullScreen
    NewGameWindowWidth = displayWidth;
    NewGameWindowHeight = displayHeight;
    IsFullScreen = true;
  else  
    -- if not set the dimension then move the gameWindow to center it
    --local newPosX = 0;
    --local newPosY = 0;
    --newPosX = (displayWidth - NewGameWindowWidth) / 2;
    --newPosY = (displayHeight - NewGameWindowHeight) / 3;
    --GameWindow.Position = new Point(newPosX, newPosY);
  end  
  
  love.window.setMode(NewGameWindowWidth, NewGameWindowHeight, {fullscreen=IsFullScreen})
  
  return GameSizeCoefficient
end

return WindowDimension