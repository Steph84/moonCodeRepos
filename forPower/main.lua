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
cursorColumn = 0

whosTurn = "yellow"

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
  
end

function love.update(dt)
  alpha = love.mouse.getX()
  
  if alpha < cell.width * 1 then
    cursorColumn = 1
  elseif alpha < cell.width * 2 then
    cursorColumn = 2
  elseif alpha < cell.width * 3 then
    cursorColumn = 3
  elseif alpha < cell.width * 4 then
    cursorColumn = 4
  elseif alpha < cell.width * 5 then
    cursorColumn = 5
  elseif alpha < cell.width * 6 then
    cursorColumn = 6
  elseif alpha < cell.width * 7 then
    cursorColumn = 7
  end
  
  cursorX = cell.width * cursorColumn - cell.width/2 - 5
  
  beta = love.mouse.isDown(1)
  if beta == true then
    grid[6][cursorColumn] = "yellow"
  end
  
  
  
end

function love.draw()

  love.graphics.setColor(myColors.blue)
  love.graphics.rectangle("fill", 0, cell.height, windowWidth, windowHeight - cell.height)
  
  print(grid[6][2])
  
  local l, c
  for l = 2, grid.line do
    for c = 1, grid.column do
      if grid[l][c] == "empty" then
        love.graphics.setColor(myColors.black)
      elseif grid[l][c] == "yellow" then
        love.graphics.setColor(myColors.yellow)
      elseif grid[l][c] == "red" then
        love.graphics.setColor(myColors.red)
      end
      local g
      for g = 1, #coordTokens do
      love.graphics.circle("fill", coordTokens[g][1], coordTokens[g][2], token.d/2)
      end
    end
  end
  
  
  local g
  for g = 1, #coordTokens do
  love.graphics.circle("fill", coordTokens[g][1], coordTokens[g][2], token.d/2)
  end

  if whosTurn == "yellow" then
    love.graphics.setColor(myColors.yellow)
  elseif whosTurn == "red" then
    love.graphics.setColor(myColors.red)
  end
  love.graphics.rectangle("fill", cursorX, cursorY, 10, 10)

end

function love.keypressed(key)
  
  print(key)
  
end