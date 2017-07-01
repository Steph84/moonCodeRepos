math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1280 -- 32x32px sprites value (40 columns)
local windowHeight = 672 -- 32x32px sprites value (21 lines)
local handTouch = {}
handTouch.tileTextures = {}
local TILE_SIZE = 1024
local theHand = {}
local dropMax = 50
local grid = {}

local myMouse = require("mouseControls")
local myDrop = require("drop")

local Screen = {x = 0, y = 0, w = windowWidth, h = windowHeight}
local timeElapsed = 0
local soundCoin = love.audio.newSource("sounds/Pickup_Coin.wav", "static")
local gameOver = false

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("The Midas Touch")
  love.mouse.setVisible(false)
  
  myDrop.Load(windowWidth, windowHeight, dropMax, dropMax)
  
  -- load the tile sheet
  handTouch.TileSheet = love.graphics.newImage("pictures/HandIcons.png")
  local nbColumns = 2
  local nbLines = 1
  
  -- extract all the tiles in the tile sheet
  local l, c
  local id = 1
  handTouch.tileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
    handTouch.tileTextures[id] = love.graphics.newQuad(
                              (c-1)*TILE_SIZE,
                              (l-1)*TILE_SIZE,
                              TILE_SIZE,
                              TILE_SIZE,
                              handTouch.TileSheet:getDimensions()
                              )
    id = id + 1
    end
  end
  
  theHand.w = 32
  theHand.h = 32
  theHand.scale = TILE_SIZE/32
  theHand.pic = 1
  
  grid.x = 0
  grid.y = windowHeight * 0.9
  grid.h = 10
  grid.w = windowWidth
  
end

function love.update(dt)
  theHand.x = love.mouse.getX();
  theHand.y = love.mouse.getY();
  
  if gameOver == false then
    local j
    for j = 1, #myDrop.listDrops do
      local d = myDrop.listDrops[j]
      
      if myMouse.ClickOnObject(d) == true then
        soundCoin:setVolume(1)
        soundCoin:play()
        d.nature = "gold"
        myDrop.Load(windowWidth, windowHeight, 1, dropMax)
      end
    
    end
    
    if myMouse.ClickOnObject(Screen) == true and theHand.pic == 1 then
      theHand.pic = 2
    end
    if theHand.pic == 2 then
      timeElapsed = timeElapsed + dt
      if timeElapsed > 0.5 then
        timeElapsed = 0
        theHand.pic = 1
      end
    end
    
    gameOver = myDrop.Update(dt, gameOver)
  end

end

function love.draw()
  
  myDrop.Draw()
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", grid.x, grid.y, grid.w, grid.h)
  
  love.graphics.draw(handTouch.TileSheet, handTouch.tileTextures[theHand.pic],
                     theHand.x, theHand.y,
                     0,
                     1/theHand.scale, 1/theHand.scale,
                     TILE_SIZE/2, TILE_SIZE/2)
end