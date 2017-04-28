io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local listOptions = {}
local itemSelected
local msgColor = {}

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Menu")
  
  -- list of items of the menu
  listOptions = { "Start game", "How to play", "About" }
  -- which item is selected on opening
  itemSelected = 1
  -- change the type face and the size
  love.graphics.setFont(love.graphics.newFont("font/Pacifico.ttf", 35))
  
end

function Tick()
  -- manage the looping selection on the menu
  local optionsLength = #listOptions
  if itemSelected < 1 then itemSelected = itemSelected + optionsLength end
  if itemSelected > optionsLength then itemSelected = itemSelected - optionsLength end
end

--[[

		if (input.attack.clicked || input.menu.clicked) {
			if (selected == 0) {
				Sound.test.play();
				game.resetGame();
				game.setMenu(null);
			}
			if (selected == 1) game.setMenu(new InstructionsMenu(this));
			if (selected == 2) game.setMenu(new AboutMenu(this));
		}
	}
--]]

function love.update(dt)
  Tick()
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
    love.graphics.printf(msg, 0, windowHeight*1/4 + i * 100, windowWidth, "center")
  end
  
end

-- manage the navigation through the menu
function love.keypressed(key, isRepeat)
  if key == "up" then itemSelected = itemSelected - 1 end
  if key == "down" then itemSelected = itemSelected + 1 end
end