math.randomseed(os.time())
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 1280 -- 32x32px sprites value (40 columns)
local windowHeight = 672 -- 32x32px sprites value (21 lines)

local map = {}
local tile = {}
local TILE_SIZE = 128


-- Shading change all

-- parse the color with constant S and L
-- Hue 0, 360

-- parse the same color
-- Saturation 0, 100
-- Lightness 0, 100 -brightness)

local green = {}
green.light = {0, 182, 39}
green.medium = {0, 142, 65}
green.dark = {0, 55, 55}
local tileColor = {0, 0, 0}

function CreateTile()
  local probaMed, probaDark = 2, 2
  local item = {}
  for l = 1, TILE_SIZE do
    item[l] = {}
    for c = 1, TILE_SIZE do
      local dice = math.random(0, 100)
      if dice >= 0 and dice < probaDark then item[l][c] = 2 end
      if dice >= probaDark and dice < (probaDark + probaMed) then item[l][c] = 3 end
      if dice >= (probaDark + probaMed) then item[l][c] = 1 end
    end
  end
  
  return item
end


function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("my Title")
  
  tile = CreateTile()
  
  for l = 1, windowHeight/TILE_SIZE do
    map[l] = {}
    for c = 1, windowWidth/TILE_SIZE do
      map[l][c] = 0
    end
  end
  
end

function love.update(dt)

end

function love.draw()
  
  local tx, ty = 0, 0
  local lCount, mCount, dCount = 0, 0, 0

  for l = 1, TILE_SIZE do
    for c = 1, TILE_SIZE do
      local t = tile[l][c]
      
      if t == 1 then
        tileColor = green.light
        lCount = lCount + 1
      end
      if t == 2 then
        tileColor = green.medium
        mCount = mCount + 1
      end
      if t == 3 then
        tileColor = green.dark
        dCount = dCount + 1
      end
      love.graphics.setColor(tileColor)
      love.graphics.rectangle("fill", tx, ty, TILE_SIZE/32, TILE_SIZE/32)
      tx = tx + TILE_SIZE/32
    end
    tx = 0
    ty = ty + TILE_SIZE/32
  end
  
  local lPerc = lCount/(TILE_SIZE*TILE_SIZE)
  local mPerc = mCount/(TILE_SIZE*TILE_SIZE)
  local dPerc = dCount/(TILE_SIZE*TILE_SIZE)
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf("light "..lPerc.." ; medium "..mPerc.." ; dark "..dPerc, 100, windowHeight - 32, windowWidth, "left")

end

function love.keypressed(key, isRepeat)
  if key == "space" then
    tile = CreateTile()
  end    
end

-- Converts HSL to RGB. (input and output range: 0 - 255)
function HSL(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255,a
end