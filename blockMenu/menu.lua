local Menu = {}

local windowWidth, windowHeight, menuState, gameVersion, anchorTitleY, anchorSelectionY
local selectionItems = {}
local itemFonts = {}
local soundObjects = {}

local myCredits = require("menuCredits")
local myOptions = require("menuOptions")

function Menu.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  menuState = "title"
  gameVersion = "v1.0"
  
  itemFonts.fontSize = 32
  itemFonts.titles = itemFonts.fontSize * 2
  itemFonts.selections = itemFonts.fontSize * 1
  itemFonts.version = itemFonts.fontSize * 0.75
  itemFonts.credits = itemFonts.fontSize * 0.75
  itemFonts.options = itemFonts.fontSize
  
  anchorTitleY = windowHeight*0.05
  anchorSelectionY = windowHeight*0.5

  -- list of items of the menu
  selectionItems.data = { "New game", "Options", "Credits", "Exit" } -- Load Game
  -- which item is selected on opening
  selectionItems.itemSelected = 1

  -- load the different parts of the menu block
  myOptions.Load(windowWidth, windowHeight, itemFonts.options)
  myCredits.Load(windowWidth, windowHeight, itemFonts.credits)
  
  -- load the sound effects
  soundObjects.selectionMove = love.audio.newSource("sounds/moveSelect.wav", "static")
  soundObjects.selectionMove:setVolume(0.25)
  soundObjects.selectionValidate = love.audio.newSource("sounds/validateSelect.wav", "static")
  soundObjects.selectionValidate:setVolume(0.25)
  soundObjects.back = love.audio.newSource("sounds/headBack.wav", "static")
  soundObjects.back:setVolume(0.5)
  
  -- load the background music
  soundObjects.bgMusic = love.audio.newSource("musics/dkSNESTheme.mp3", "stream")
  soundObjects.bgMusic:setLooping(true)
  soundObjects.bgMusic:setVolume(0.25)
  --soundObjects.bgMusic:play()
end


function Menu.Update(dt)
  
  if menuState == "title" then
    -- manage the looping selection on the menu
    local optionsLength = #selectionItems.data
    if selectionItems.itemSelected < 1 then
      selectionItems.itemSelected = selectionItems.itemSelected + optionsLength
    end
    if selectionItems.itemSelected > optionsLength then
      selectionItems.itemSelected = selectionItems.itemSelected - optionsLength
    end
  end
  
  if menuState == "credits" then
    menuState = myCredits.Update(dt, menuState)
    if menuState == "title" then soundObjects.back:play() end
  end
  
  if menuState == "options" then
    menuState = myOptions.Update(dt, menuState)
    if menuState == "title" then soundObjects.back:play() end
  end
  
end

function Menu.Draw()
  
  if menuState == "title" then
    -- draw the title and subtitle
    love.graphics.setColor(0, 0, 255)
    love.graphics.setFont(love.graphics.newFont("fonts/Capture_it.ttf", itemFonts.titles))
    love.graphics.printf("SALEM", 0, anchorTitleY, windowWidth, "center")
    
    love.graphics.setColor(255, 0, 255)
    love.graphics.setFont(love.graphics.newFont("fonts/AlexBrush-Regular.ttf", itemFonts.titles))
    love.graphics.printf("Story", 0, anchorTitleY + itemFonts.titles, windowWidth, "center")
    
    -- draw the menu selection
    love.graphics.setFont(love.graphics.newFont("fonts/Pacifico.ttf", itemFonts.selections))
    local i
    for i = 1, #selectionItems.data do
      local msg = selectionItems.data[i]
      
      -- highlight the selected item
      if i == selectionItems.itemSelected then
        msg = "> "..msg.." <"
        selectionItems.color = {255, 255, 255}
      else selectionItems.color = {120, 120, 120} end
      
      love.graphics.setColor(selectionItems.color)
      love.graphics.printf(msg, 0, anchorSelectionY + 1.5*(i-1) * itemFonts.selections, windowWidth, "center")
    end
    
    -- draw the game version
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", itemFonts.version))
    love.graphics.printf(gameVersion, 0, windowHeight - itemFonts.version, windowWidth, "right")
  end
  
  if menuState == "credits" then myCredits.Draw() end
  
  if menuState == "options" then  myOptions.Draw() end
  
end

-- using keypressed function ponctual action
function love.keypressed(key, isRepeat)
  if menuState == "title" then
    -- manage the looping navigation through the menu
    if key == "up" then
      soundObjects.selectionMove:stop() -- avoid to overlap the sounds
      soundObjects.selectionMove:play()
      selectionItems.itemSelected = selectionItems.itemSelected - 1
    end
    if key == "down" then
      soundObjects.selectionMove:stop() -- avoid to overlap the sounds
      soundObjects.selectionMove:play()
      selectionItems.itemSelected = selectionItems.itemSelected + 1
    end
    
    -- manage the selection
    if key == "return" then
      
      -- avoid to overlap the sounds
      soundObjects.selectionMove:stop()
      soundObjects.selectionValidate:stop()
      soundObjects.selectionValidate:play()
      
      if selectionItems.itemSelected == 1 then menuState = "game" end -- start a new game
      if selectionItems.itemSelected == #selectionItems.data then
        love.timer.sleep(0.6) -- wait a moment to heard the sound effect
        love.event.quit() -- exit the game
      end
      
      -- if itemSelected == 2 then gameState = "loadGame" end
      if selectionItems.itemSelected == 2 then menuState = "options" end
      if selectionItems.itemSelected == 3 then menuState = "credits" end
    end
  end
  
end

return Menu