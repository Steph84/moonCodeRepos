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
  
  local a = {"one", "two", "three"}
    for i, v in ipairs(a) do
      print(i, v)
    end
    
  j, w = next(a, 2)
    print(j, w)
    
    print( string.byte( "800 x600", 1, -1 ) ) -- ASCII
  --[[
  local file = love.filesystem.newFile("highscore.lua")
   file:open("w")
   file:write("highscore = { bob = 5, tom = 200, jane = 4000 }", 1000)
   file:close()
--]]

  
end

function love.update(dt)
  
  if gameState == "menu" then
    myMenu.Update(dt)
    if myMenu.menuState == "options" then
      local refWidth, refHeight = love.window.getMode()
      if myMenu.myOptions.myResolution.window[1] ~= refWidth or myMenu.myOptions.myResolution.window[2] ~= refHeight then
        reload = true
      end
    end
  end
  
  if reload == true then
    --[[if myMenu.myOptions.myResolution.window[4] == false then
      love.window.setMode(myMenu.myOptions.myResolution.window[1], myMenu.myOptions.myResolution.window[2], {fullscreen = false})
    elseif myMenu.myOptions.myResolution.window[4] == true then
      love.window.setFullscreen(true)
    end--]]
    love.window.setMode(myMenu.myOptions.myResolution.window[1], myMenu.myOptions.myResolution.window[2])
    reload = false
    love.load()
  end
  
end

function love.draw()
  myMenu.Draw()
end