local Menu = {}

Menu.menuState = nil

local windowWidth, windowHeight, gameVersion, anchorTitleY, anchorSelectionY, bMenuStable, jamDate
local selectionItems = {}
local sizeFonts = {}
local itemFonts = {}
local soundObjects = {}

local selectionCoorX, selectionLimit

local myPicture = require("loadPictures")
local myCredits = require("menuCredits")
local myInstructions = require("menuInstructions")

-- function use for the selection tweening
local function easeOutSin(t, b, c, d)
  return c * math.sin(t/d * (math.pi/2)) + b
end

-- initialize the values for the tweening
local function EnterMenu()
  
  selectionCoorX = {}
  selectionCoorX.time = 0
  selectionCoorX.value = -100
  selectionCoorX.distance = 100
  selectionCoorX.duration = 1.5
  
  selectionLimit = {}
  selectionLimit.time = 0
  selectionLimit.value = 0
  selectionLimit.distance = windowWidth
  selectionLimit.duration = 1.5
  
end

function Menu.Load(pWindowWidth, pWindowHeight, pFONT_SIZE)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  Menu.menuState = "title"
  gameVersion = "v1.0"
  jamDate = "December 2017"
  
  -- menu tweening
  bMenuStable = false
  EnterMenu()
  
  sizeFonts.fontSize = pFONT_SIZE
  sizeFonts.titles = sizeFonts.fontSize * 2
  sizeFonts.selections = sizeFonts.fontSize * 1
  sizeFonts.versionDate = sizeFonts.fontSize * 0.75
  sizeFonts.credits = sizeFonts.fontSize * 0.75
  
  itemFonts.titles = love.graphics.newFont("fonts/Capture_it.ttf", sizeFonts.titles)
  itemFonts.subTitles = love.graphics.newFont("fonts/AlexBrush-Regular.ttf", sizeFonts.titles)
  itemFonts.selections = love.graphics.newFont("fonts/Pacifico.ttf", sizeFonts.selections)
  itemFonts.versionDate = love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", sizeFonts.versionDate)
  
  anchorTitleY = windowHeight*0.05
  anchorSelectionY = windowHeight*0.5

  -- list of items of the menu
  selectionItems.data = { "New game", "Instructions", "Credits", "Quit" } -- Load Game
  -- which item is selected on opening
  selectionItems.itemSelected = 1

  -- load the different parts of the menu block
  myPicture.Load()
  myCredits.Load(windowWidth, windowHeight, sizeFonts.credits)
  myInstructions.Load(windowWidth, windowHeight, sizeFonts.credits)
  
  -- load the sound effects
  soundObjects.selectionMove = love.audio.newSource("sounds/moveSelect.wav", "static")
  soundObjects.selectionMove:setVolume(0.25)
  soundObjects.selectionValidate = love.audio.newSource("sounds/validateSelect.wav", "static")
  soundObjects.selectionValidate:setVolume(0.25)
  soundObjects.back = love.audio.newSource("sounds/headBack.wav", "static")
  soundObjects.back:setVolume(0.5)
  
end


function Menu.Update(dt)
  bMenuStable = true
  
  if Menu.menuState == "title" then
    if selectionCoorX.time < selectionCoorX.duration then
      selectionCoorX.time = selectionCoorX.time + dt
      bMenuStable = false
    end
    if selectionLimit.time < selectionLimit.duration then
      selectionLimit.time = selectionLimit.time + dt
      bMenuStable = false
    end
  end
  
  if Menu.menuState == "title" and bMenuStable == true then
    -- manage the looping selection on the menu
    local optionsLength = #selectionItems.data
    if selectionItems.itemSelected < 1 then
      selectionItems.itemSelected = selectionItems.itemSelected + optionsLength
    end
    if selectionItems.itemSelected > optionsLength then
      selectionItems.itemSelected = selectionItems.itemSelected - optionsLength
    end
  end
  
  if Menu.menuState == "instructions" then
    Menu.menuState = myInstructions.Update(dt, Menu.menuState)
    if Menu.menuState == "title" then soundObjects.back:play() end
  end
  
  if Menu.menuState == "credits" then
    Menu.menuState = myCredits.Update(dt, Menu.menuState)
    if Menu.menuState == "title" then soundObjects.back:play() end
  end
  
	-- using keypressed function ponctual action
	function love.keypressed(key, isRepeat)
	  if Menu.menuState == "title" and bMenuStable == true then
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
		  
		  if selectionItems.itemSelected == 2 then Menu.menuState = "instructions" end
		  if selectionItems.itemSelected == 3 then Menu.menuState = "credits" end
		end
	  end
	end
  
end

function Menu.Draw()
  
  if Menu.menuState == "title" then
    
    myPicture.Draw(myPicture.jamLogo.src,
                   windowWidth*0.01, windowHeight*0.99 - 64,
                   192/myPicture.jamLogo.w, 64/myPicture.jamLogo.h)
    
    -- draw the title and subtitle
    love.graphics.setColor(0, 0, 255)
    love.graphics.setFont(itemFonts.titles)
    love.graphics.printf("Game name", 0, anchorTitleY, windowWidth, "center")
    
    love.graphics.setColor(255, 0, 255)
    love.graphics.setFont(itemFonts.subTitles)
    love.graphics.printf("Theme : jam", 0, anchorTitleY + sizeFonts.titles, windowWidth, "center")
    
    local tweenXDraw, tweenLimitDraw
    tweenXDraw = easeOutSin(selectionCoorX.time, selectionCoorX.value, selectionCoorX.distance, selectionCoorX.duration)
    tweenLimitDraw = easeOutSin(selectionLimit.time, selectionLimit.value, selectionLimit.distance, selectionLimit.duration)
    
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
      love.graphics.printf(msg, tweenXDraw * i, anchorSelectionY + 1.5*(i-1) * sizeFonts.selections, tweenLimitDraw, "center")
    end
    
    -- draw the game version and jam date
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(itemFonts.versionDate)
    love.graphics.printf(gameVersion, 0, windowHeight - sizeFonts.versionDate, windowWidth, "right")
    love.graphics.printf(jamDate, windowWidth*0.02 + 192, windowHeight - sizeFonts.versionDate, windowWidth, "left")
  end
  
  if Menu.menuState == "credits" then myCredits.Draw() end
  
  if Menu.menuState == "instructions" then myInstructions.Draw() end
  
end

return Menu