math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1000 -- default value
local windowHeight = 600 -- default value

local bulb = {}
local maxBulb, maxSwitch = 5, 3

bulb.x = 0
bulb.y = 0
bulb.size = 32
bulb.transX = 16 - 32
bulb.transY = 28
local listBulbs = {}
local listSwitches = {}
local isLight = {false, false, false} -- 1:red, 2:green, 3:blue
local channelPlus = {0, 0, 0} -- 1:red, 2:green, 3:blue

local myMouse = require("mouseControls")

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("Switch")
  bulb.x = windowWidth * 0.95
  bulb.y = windowHeight/2
  
  local i
  for i = 1, maxBulb do
    local myBulb = {}
    myBulb.x = (i / maxBulb) * 0.8 * windowWidth
    myBulb.y = windowHeight * 0.2
    myBulb.size = 32
    myBulb.transX = 16 - 32
    myBulb.transY = 28
    myBulb.red = math.random(0, 255)
    myBulb.green = math.random(0, 255)
    myBulb.blue = math.random(0, 255)
    table.insert(listBulbs, myBulb)
  end
  
  local j
  for j = 1, maxSwitch do
    local mySwitch = {}
    mySwitch.x = (j / maxSwitch) * 0.8 * windowWidth
    mySwitch.y = windowHeight * 0.8
    mySwitch.h = 32
    mySwitch.w = 32
    mySwitch.isOn = false
    table.insert(listSwitches, mySwitch)
  end
  
end

function love.update(dt)
  
  local j
  for j = 1, #listSwitches do
    local s = listSwitches[j]
    if myMouse.ClickOnObject(s) == true then
      if s.isOn == true then
        s.isOn = false
        isLight[j] = false
      elseif s.isOn == false then
        s.isOn = true
        isLight[j] = true
      end
    end
  end
  
  local k
  for k = 1, #isLight do
    if isLight[k] == true then channelPlus[k] = 100
    elseif isLight[k] == false then channelPlus[k] = 0
    end
  end
  

end

function love.draw()
  love.graphics.setColor(255, 255, 255)
  
  local i
  for i = 1, #listBulbs do
    local b = listBulbs[i]
    love.graphics.circle("line", b.x, b.y, b.size)
    love.graphics.rectangle("fill", b.x + b.transX, b.y + b.transY, b.size, b.size)
    
    love.graphics.setColor(b.red + channelPlus[1], b.green + channelPlus[2], b.blue + channelPlus[3])
    love.graphics.circle("fill", b.x, b.y, b.size)
    love.graphics.setColor(255, 255, 255)
  end
  
  love.graphics.printf("Click on the switches -->", windowWidth * 0.05, windowHeight * 0.8 + 10, windowWidth, "left")
  
  local j
  for j = 1, #listSwitches do
    local s = listSwitches[j]
    local rectMode = "line"
    if s.isOn == true then rectMode = "fill" end
    
    local switchColor = {0, 0, 0}
    switchColor[j] = 255
    love.graphics.setColor(switchColor)
    love.graphics.rectangle(rectMode, s.x, s.y, s.w, s.h)
  end

end

function love.keypressed(key)
  
  print(key)
  
end