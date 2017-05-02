io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local listOptions = {}
local itemSelected
local msgColor = {}
local fontSize = 35
local gameState = "title"

local soundMoveSelect
local soundValidateSelect

local myCredits = require("credits")

function love.load()
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("myMenu")
  
  -- list of items of the menu
  listOptions = { "New game", "Options", "Credits", "Exit" } -- Load Game
  -- which item is selected on opening
  itemSelected = 1

  -- change the type face and the font size
  love.graphics.setFont(love.graphics.newFont("font/Pacifico.ttf", fontSize))
  
  myCredits.Load()
  
  soundMoveSelect = love.audio.newSource("sounds/moveSelect.wav", "static")
  soundValidateSelect = love.audio.newSource("sounds/validateSelect.wav", "static")
  
  
end

function loopMenu()
  -- manage the looping selection on the menu
  local optionsLength = #listOptions
  if itemSelected < 1 then itemSelected = itemSelected + optionsLength end
  if itemSelected > optionsLength then itemSelected = itemSelected - optionsLength end
  
end

function love.update(dt)
  loopMenu()
end

function love.draw()
  
  -- draw the menu selection
  local i
  for i = 1, #listOptions do
    local msg = listOptions[i]
    
    -- highlight the selected item
    if i == itemSelected then
      msg = "> "..msg.." <"
      msgColor = {255, 255, 255}
    else msgColor = {120, 120, 120} end
    
    love.graphics.setColor(msgColor)
    love.graphics.printf(msg, 0, windowHeight*1/3 + (i-1) * fontSize*2, windowWidth, "center")
  end
  
end

function love.keypressed(key, isRepeat)
  -- manage the looping navigation through the menu
  if key == "up" then
    soundMoveSelect:stop()
    soundMoveSelect:play()
    itemSelected = itemSelected - 1
  end
  if key == "down" then
    soundMoveSelect:stop()
    soundMoveSelect:play()
    itemSelected = itemSelected + 1
  end
  
  -- manage the selection
  if key == "return" then
    
    soundMoveSelect:stop()
    soundValidateSelect:play()
    
    if itemSelected == 1 then gameState = "game" end -- start a new game
    if itemSelected == #listOptions then
      love.timer.sleep(0.6)
      love.event.quit() -- exit the game
    end
    
    -- if itemSelected == 2 then gameState = "loadGame" end
    if itemSelected == 2 then gameState = "options" end
    if itemSelected == 3 then gameState = "credits" end
  end
  
end