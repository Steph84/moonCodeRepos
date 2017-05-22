io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local gameState = "menu"
local reload = false

local myMenu = require("menu")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("my Title")
  
  myMenu.Load(windowWidth, windowHeight)
  
end

function love.update(dt)
  
  if gameState == "menu" then
    myMenu.Update(dt)
    --print(myMenu.myOptions.myResolution.window[1], myMenu.myOptions.myResolution.window[2])
    if myMenu.menuState == "options" then
      local refWidth, refHeight = love.window.getMode()
      if myMenu.myOptions.myResolution.window[1] ~= refWidth or myMenu.myOptions.myResolution.window[2] ~= refHeight then
        reload = true
      end
    end
  end
  
  if reload == true then
    love.window.setMode(myMenu.myOptions.myResolution.window[1], myMenu.myOptions.myResolution.window[2])
    myMenu.Load(myMenu.myOptions.myResolution.window[1], myMenu.myOptions.myResolution.window[2])
    reload = false
  end
  
end

function love.draw()
  myMenu.Draw()
end