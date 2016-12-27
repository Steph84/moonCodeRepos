io.stdout:setvbuf('no')

love.graphics.setDefaultFilter("nearest")

if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 600
local windowHeight = 600

grid = {}
grid.column = 7
grid.line = 7

cell = {}
cell.height = 0
cell.width = 0

token = {}
token.type = "empty"
token.d = 0

local myColors = {}
myColors.blue = {0, 0, 190}
myColors.red = {255, 0, 0}
myColors.yellow = {255, 255, 0}
myColors.black = {0, 0, 0}
myColors.green = {0, 255, 0}

local coordTokens = {}

cursorX = 0
cursorY = 0

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  cell.height = windowHeight/grid.line
  cell.width = windowWidth/grid.column
  
  token.d = cell.width - 10
  
  -- initialization of the grid (empty)
  local l, c
  for l = 2, grid.line do
    grid[l] = {}
    for c = 1, grid.column do
      grid[l][c] = "empty"
    end
  end
  
  
  local lbis, cbis
  local tempCell
  local bx, by = 0, 0
  by = cell.height + cell.height/2
  for lbis = 2, grid.line do
    bx = cell.width/2
    for cbis = 1, grid.column do
      tempCell = {}
      tempCell = {bx, by}
      table.insert(coordTokens, tempCell)
      bx = bx + cell.width
    end
    by = by + cell.height
  end
  
  cursorY = cell.height - 20
  print(cursorY)
end

function love.update(dt)
  alpha = love.mouse.getX()
  local tempCoord = cell.width
  if alpha < tempCoord then
    cursorX = tempCoord - tempCoord/2 - 5
  elseif alpha < tempCoord * 2 then
    cursorX = tempCoord * 2 - tempCoord/2 - 5
  elseif alpha < tempCoord * 3 then
    cursorX = tempCoord * 3 - tempCoord/2 - 5
  elseif alpha < tempCoord * 4 then
    cursorX = tempCoord * 4 - tempCoord/2 - 5
  elseif alpha < tempCoord * 5 then
    cursorX = tempCoord * 5 - tempCoord/2 - 5
  elseif alpha < tempCoord * 6 then
    cursorX = tempCoord * 6 - tempCoord/2 - 5
  elseif alpha < tempCoord * 7 then
    cursorX = tempCoord * 7 - tempCoord/2 - 5
  end
  --print(alpha)
  --TODO
  -- cursorX update
  
end

function love.draw()

  love.graphics.setColor(myColors.blue)
  love.graphics.rectangle("fill", 0, cell.height, windowWidth, windowHeight - cell.height)
    
  local l, c
  for l = 2, grid.line do
    for c = 1, grid.column do
      if grid[l][c] == "empty" then
        love.graphics.setColor(myColors.black)
      end
    end
  end
  
  local g
  for g = 1, #coordTokens do
  love.graphics.circle("fill", coordTokens[g][1], coordTokens[g][2], token.d/2)
  end

  love.graphics.setColor(myColors.green)
  love.graphics.rectangle("fill", cursorX, cursorY, 10, 10)

end

function love.keypressed(key)
  
  print(key)
  
end