local Menu = {}

Menu.menuState = nil

local windowWidth, windowHeight, gameVersion, anchorTitleY, anchorSelectionY
local selectionItems = {}
local sizeFonts = {}
local itemFonts = {}
local soundObjects = {}

local myPicture = require("loadPictures")
local myCredits = require("menuCredits")

function Menu.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  Menu.menuState = "title"
  gameVersion = "v1.0"
  
  sizeFonts.fontSize = 32
  sizeFonts.titles = sizeFonts.fontSize * 2
  sizeFonts.selections = sizeFonts.fontSize * 1
  sizeFonts.version = sizeFonts.fontSize * 0.75
  sizeFonts.credits = sizeFonts.fontSize * 0.75
  
  itemFonts.titles = love.graphics.newFont("fonts/Capture_it.ttf", sizeFonts.titles)
  itemFonts.subTitles = love.graphics.newFont("fonts/AlexBrush-Regular.ttf", sizeFonts.titles)
  itemFonts.selections = love.graphics.newFont("fonts/Pacifico.ttf", sizeFonts.selections)
  itemFonts.version = love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", sizeFonts.version)
  
  anchorTitleY = windowHeight*0.05
  anchorSelectionY = windowHeight*0.5

  -- list of items of the menu
  selectionItems.data = { "New game", "Credits", "Quit" } -- Load Game
  -- which item is selected on opening
  selectionItems.itemSelected = 1

  -- load the different parts of the menu block
  myPicture.Load()
  myCredits.Load(windowWidth, windowHeight, sizeFonts.credits)
  
  -- load the sound effects
  soundObjects.selectionMove = love.audio.newSource("sounds/moveSelect.wav", "static")
  soundObjects.selectionMove:setVolume(0.25)
  soundObjects.selectionValidate = love.audio.newSource("sounds/validateSelect.wav", "static")
  soundObjects.selectionValidate:setVolume(0.25)
  soundObjects.back = love.audio.newSource("sounds/headBack.wav", "static")
  soundObjects.back:setVolume(0.5)
  
  -- load the background music
  --soundObjects.bgMusic = love.audio.newSource("musics/dkSNESTheme.mp3", "stream")
  --soundObjects.bgMusic:setLooping(true)
  --soundObjects.bgMusic:setVolume(0.25)
  --soundObjects.bgMusic:play()
end


function Menu.Update(dt)
  
  if Menu.menuState == "title" then
    -- manage the looping selection on the menu
    local optionsLength = #selectionItems.data
    if selectionItems.itemSelected < 1 then
      selectionItems.itemSelected = selectionItems.itemSelected + optionsLength
    end
    if selectionItems.itemSelected > optionsLength then
      selectionItems.itemSelected = selectionItems.itemSelected - optionsLength
    end
  end
  
  if Menu.menuState == "credits" then
    Menu.menuState = myCredits.Update(dt, Menu.menuState)
    if Menu.menuState == "title" then soundObjects.back:play() end
  end
  

	-- using keypressed function ponctual action
	function love.keypressed(key, isRepeat)
	  if Menu.menuState == "title" then
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
		  
		  if selectionItems.itemSelected == 1 then Menu.menuState = "game" end -- start a new game
		  if selectionItems.itemSelected == #selectionItems.data then
			love.timer.sleep(0.6) -- wait a moment to heard the sound effect
			love.event.quit() -- exit the game
		  end
		  
		  -- if itemSelected == 2 then gameState = "loadGame" end
		  if selectionItems.itemSelected == 2 then Menu.menuState = "credits" end
		end
	  end
	end
  
end

function Menu.Draw()
  
  if Menu.menuState == "title" then
    -- draw the title and subtitle
    love.graphics.setColor(0, 0, 255)
    love.graphics.setFont(itemFonts.titles)
    love.graphics.printf("SALEM", 0, anchorTitleY, windowWidth, "center")
    
    love.graphics.setColor(255, 0, 255)
    love.graphics.setFont(itemFonts.subTitles)
    love.graphics.printf("Story", 0, anchorTitleY + sizeFonts.titles, windowWidth, "center")
    
    -- draw the menu selection
    love.graphics.setFont(itemFonts.selections)
    local i
    for i = 1, #selectionItems.data do
      local msg = selectionItems.data[i]
      
      -- highlight the selected item
      if i == selectionItems.itemSelected then
        msg = "> "..msg.." <"
        selectionItems.color = {255, 255, 255}
      else selectionItems.color = {120, 120, 120} end
      
      love.graphics.setColor(selectionItems.color)
      love.graphics.printf(msg, 0, anchorSelectionY + 1.5*(i-1) * sizeFonts.selections, windowWidth, "center")
    end
    
    -- draw the game version
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(itemFonts.version)
    love.graphics.printf(gameVersion, 0, windowHeight - sizeFonts.version, windowWidth, "right")
  end
  
  if Menu.menuState == "credits" then myCredits.Draw() end
  
end

return Menu