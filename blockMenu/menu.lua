local Menu = {}

local listOptions = {}
local itemSelected
local msgColor = {}
local fontSize = 32
local menuState = "title"
local gameVersion = "v1.0"
local itemFontSize = {}
itemFontSize.Title = fontSize * 2
itemFontSize.Select = fontSize * 1
itemFontSize.Version = fontSize * 0.75
itemFontSize.Credits = fontSize * 0.75
itemFontSize.Options = fontSize

local anchorTitle, anchorSelection

local soundMoveSelect
local soundValidateSelect
local soundHeadBack
local soundBackgroundMusic

local myCredits = require("credits")
local myOptions = require("options")

function Menu.Load(pWindowWidth, pWindowHeight)
  anchorTitle = pWindowHeight*0.05
  anchorSelection = pWindowHeight*0.5

  
  -- list of items of the menu
  listOptions = { "New game", "Options", "Credits", "Exit" } -- Load Game
  -- which item is selected on opening
  itemSelected = 1

  -- load the different parts of the menu block
  myCredits.Load()
  myOptions.Load(pWindowWidth, pWindowHeight, itemFontSize.Options)
  
  -- load the sounds
  soundMoveSelect = love.audio.newSource("sounds/moveSelect.wav", "static")
  soundMoveSelect:setVolume(0.25)
  soundValidateSelect = love.audio.newSource("sounds/validateSelect.wav", "static")
  soundValidateSelect:setVolume(0.25)
  soundHeadBack = love.audio.newSource("sounds/headBack.wav", "static")
  soundHeadBack:setVolume(0.5)
  
  -- load the background music
  soundBackgroundMusic = love.audio.newSource("musics/dkSNESTheme.mp3", "stream")
  soundBackgroundMusic:setLooping(true)
  soundBackgroundMusic:setVolume(0.25)
  --soundBackgroundMusic:play()
end


function Menu.Update(pDt)
  
  if menuState == "title" then
    -- manage the looping selection on the menu
    local optionsLength = #listOptions
    if itemSelected < 1 then itemSelected = itemSelected + optionsLength end
    if itemSelected > optionsLength then itemSelected = itemSelected - optionsLength end
  end
  
  if menuState == "credits" then
    menuState = myCredits.Update(dt, menuState)
    if menuState == "title" then soundHeadBack:play() end
  end
  
  if menuState == "options" then
    menuState = myOptions.Update(dt, menuState)
    if menuState == "title" then soundHeadBack:play() end
  end
  
end

function Menu.Draw(pWindowWidth, pWindowHeight)
  
  if menuState == "title" then
    -- draw the title and subtitle
    love.graphics.setColor(0, 0, 255)
    love.graphics.setFont(love.graphics.newFont("fonts/Capture_it.ttf", itemFontSize.Title))
    love.graphics.printf("SALEM", 0, anchorTitle, pWindowWidth, "center")
    
    love.graphics.setColor(255, 0, 255)
    love.graphics.setFont(love.graphics.newFont("fonts/AlexBrush-Regular.ttf", itemFontSize.Title))
    love.graphics.printf("Story", 0, anchorTitle + itemFontSize.Title, pWindowWidth, "center")
    
    
    -- draw the menu selection
    love.graphics.setFont(love.graphics.newFont("fonts/Pacifico.ttf", itemFontSize.Select))
    local i
    for i = 1, #listOptions do
      local msg = listOptions[i]
      
      -- highlight the selected item
      if i == itemSelected then
        msg = "> "..msg.." <"
        msgColor = {255, 255, 255}
      else msgColor = {120, 120, 120} end
      
      love.graphics.setColor(msgColor)
      love.graphics.printf(msg, 0, anchorSelection + 1.5*(i-1) * itemFontSize.Select, pWindowWidth, "center")
    end
    
    -- draw the game version
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", itemFontSize.Version))
    love.graphics.printf(gameVersion, 0, pWindowHeight - itemFontSize.Version, pWindowWidth, "right")
  end
  
  if menuState == "credits" then
    myCredits.Draw(pWindowWidth, pWindowHeight, itemFontSize.Credits)
  end
  
  if menuState == "options" then
    myOptions.Draw(pWindowWidth, pWindowHeight, itemFontSize.Options)
  end
  
end

-- using keypressed function ponctual action
function love.keypressed(key, isRepeat)
  if menuState == "title" then
    -- manage the looping navigation through the menu
    if key == "up" then
      soundMoveSelect:stop() -- avoid to overlap the sounds
      soundMoveSelect:play()
      itemSelected = itemSelected - 1
    end
    if key == "down" then
      soundMoveSelect:stop() -- avoid to overlap the sounds
      soundMoveSelect:play()
      itemSelected = itemSelected + 1
    end
    
    -- manage the selection
    if key == "return" then
      
      -- avoid to overlap the sounds
      soundMoveSelect:stop()
      soundValidateSelect:stop()
      soundValidateSelect:play()
      
      if itemSelected == 1 then menuState = "game" end -- start a new game
      if itemSelected == #listOptions then
        love.timer.sleep(0.6) -- wait a moment to heard the sound effect
        love.event.quit() -- exit the game
      end
      
      -- if itemSelected == 2 then gameState = "loadGame" end
      if itemSelected == 2 then menuState = "options" end
      if itemSelected == 3 then menuState = "credits" end
    end
  end
  
end

return Menu