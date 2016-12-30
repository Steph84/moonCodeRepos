io.stdout:setvbuf('no')

love.graphics.setDefaultFilter("nearest")

if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 600
local windowHeight = 600

grid = {}
grid.column = 7
grid.line = 7
grid.listTokens = {}
grid.tokenDiam = 0

cell = {}
cell.height = 0
cell.width = 0

local myColors = {}
myColors.white = {255, 255, 255}
myColors.blue = {0, 0, 190}
myColors.red = {255, 0, 0}
myColors.yellow = {255, 255, 0}
myColors.black = {0, 0, 0}
myColors.green = {0, 255, 0}

cursorX = 0
cursorY = 0
cursorColumn = 0

whosTurn = "yellow"

winState = false

local tokensPlayed = 0
local winToken = 0
local winTokens = {}
local winPlayer = nil

cross = {}
cross.scale = 2.5
cross.offSet = 5

listPics = {}

loadAnimation = false


function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  --love.graphics.setBackgroundColor(myColors.white)
  cell.height = windowHeight/grid.line
  cell.width = windowWidth/grid.column
  
  grid.tokenDiam = cell.width - 10
  
  print(grid.tokenDiam)
  -- initialization of the grid
  local l, c
  local tokenId = 1
  local bx, by = 0, 0
  by = cell.height + cell.height/2
  for l = 2, grid.line do
    bx = cell.width/2
    for c = 1, grid.column do
      -- each token have an id, coordinate in the grid in row/column and in pyxel and a type (color)
      grid.listTokens[tokenId] = {id = tokenId, tabX = c, tabY = l, pixX = bx, pixY = by, tokenType = "empty"}
      bx = bx + cell.width
      tokenId = tokenId + 1
    end
    by = by + cell.height
  end
  
  cursorY = cell.height*3/4 -- y coordinate for the cursor
  
  listPics.crossLoad = love.graphics.newImage("pictures/cross_75x75.png")
  listPics.crossWidth = listPics.crossLoad:getWidth()
  listPics.crossHeight = listPics.crossLoad:getHeight()
  
  listPics.redCursorLoad = love.graphics.newImage("pictures/redCursor_15x15.png")
  listPics.redCursorWidth = listPics.redCursorLoad:getWidth()
  listPics.redCursorHeight = listPics.redCursorLoad:getHeight()
  
  listPics.yellowCursorLoad = love.graphics.newImage("pictures/yellowCursor_15x15.png")
  listPics.yellowCursorWidth = listPics.yellowCursorLoad:getWidth()
  listPics.yellowCursorHeight = listPics.yellowCursorLoad:getHeight()
  
end

-- function to check if win by a line
function checkLineWin(player)
  local a
  local fourSum, fourSucc = 0, 0
  local middleToken
  
  for middleToken = 4, 39, 7 do
    if grid.listTokens[middleToken].tokenType == player then -- possibility of win on line
      for a = (middleToken - 3), (middleToken + 3) do -- check if there are 4 tokens in the line
        if grid.listTokens[a].tokenType == player then
          fourSum = fourSum + 1
        end
      end
      
      if fourSum >= 4 then -- if so, let's check it there are 4 in a row
        local d
        for d = -3, 3 do
          if grid.listTokens[middleToken + d].tokenType == player then
            fourSucc = fourSucc + 1
            table.insert(winTokens, middleToken + d)
            if fourSucc >= 4 then
              winPlayer = player
              winToken = middleToken
              return true -- win !!
            end
          else
            fourSucc = 0
            winTokens = {}
          end
        end
      end
    end
  end
  return false -- no win
end

-- function to check if win by a column
function checkColumnWin(player)
  local middleToken2
  local a
  local fourSum, fourSucc = 0, 0
  
  for middleToken2 = 15, 21 do
    if grid.listTokens[middleToken2].tokenType == player then -- possibility of win on column
      for a = (middleToken2 - 14), (middleToken2 + 21), 7 do -- check if there are 4 tokens in the column
        if grid.listTokens[a].tokenType == player then
          fourSum = fourSum + 1
        end
      end
      
      if fourSum >= 4 then -- if so, let's check it there are 4 in a row
        local d
        for d = -14, 21, 7 do
          if grid.listTokens[middleToken2 + d].tokenType == player then
            fourSucc = fourSucc + 1
            table.insert(winTokens, middleToken2 + d)
            if fourSucc >= 4 then
              winPlayer = player
              winToken = middleToken2
              return true -- win !!
            end
          else
            fourSucc = 0
            winTokens = {}
          end
        end
      end
      
    end
  end
  return false
end

-- function to check if win by a diagonal
function checkDiagWin(player)
  local miniToken1, miniToken2, miniToken3, miniToken4, middleToken, miniToken5, miniToken6
  local fourSum1, fourSum2, fourSum3, fourSum4, fourSum5, fourSum6, fourSum7, fourSum8 = 0, 0, 0, 0, 0, 0, 0, 0
  local fourSucc3, fourSucc4, fourSucc6, fourSucc7, fourSucc8 = 0, 0, 0, 0, 0
  
-----------------------------------------------------diagonal from 3rd row-----------------------------------------------------
  -- diag \ from 3rd row
  for miniToken1 = 15, 18 do
    fourSum1 = 0
    if grid.listTokens[miniToken1].tokenType == player then -- minimum possibility of win
      for a = miniToken1, (miniToken1 + 24), 8 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum1 = fourSum1 + 1
        end
        table.insert(winTokens, a)
      end
      if fourSum1 >= 4 then -- if so, win
        winPlayer = player
        winToken = miniToken1
        return true
      else winTokens = {}
      end
    end
  end
  
  -- diag / from 3rd row
  for miniToken2 = 18, 21 do
    fourSum2 = 0
    if grid.listTokens[miniToken2].tokenType == player then -- minimum possibility of win
      for a = miniToken2, (miniToken2 + 18), 6 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum2 = fourSum2 + 1
        end
        table.insert(winTokens, a)
      end
      if fourSum2 >= 4 then -- if so, win
        winPlayer = player
        winToken = miniToken2
        return true
      else winTokens = {}
      end
    end
  end
  
-----------------------------------------------------diagonal from 2nd row-----------------------------------------------------
  -- diag \ from 2nd row
  for miniToken3 = 8, 10 do
    fourSum3 = 0
    if grid.listTokens[miniToken3].tokenType == player then -- minimum possibility of win
      for a = miniToken3, (miniToken3 + 32), 8 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum3 = fourSum3 + 1
        end
      end
      
      if fourSum3 >= 4 then -- if so, let's check it there are 4 in a row
        local d
        for d = 0, 32, 8 do
          if grid.listTokens[miniToken3 + d].tokenType == player then
            fourSucc3 = fourSucc3 + 1
            table.insert(winTokens, miniToken3 + d)
            if fourSucc3 >= 4 then
              winPlayer = player
              winToken = miniToken3
              return true -- win !!
            end
          else
            fourSucc3 = 0
            winTokens = {}
          end
        end
      end
    end
  end
  
  -- diag / from 2nd row
  for miniToken4 = 12, 14 do
    fourSum4 = 0
    if grid.listTokens[miniToken4].tokenType == player then -- minimum possibility of win
      for a = miniToken4, (miniToken4 + 24), 6 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum4 = fourSum4 + 1
        end
      end
      if fourSum3 >= 4 then -- if so, let's check it there are 4 in a row
        local d
        for d = 0, 24, 6 do
          if grid.listTokens[miniToken4 + d].tokenType == player then
            fourSucc4 = fourSucc4 + 1
            table.insert(winTokens, miniToken4 + d)
            if fourSucc4 >= 4 then
              winPlayer = player
              winToken = miniToken4
              return true -- win !!
            end
          else
            fourSucc4 = 0
            winTokens = {}
          end
        end
      end
    end
  end
  
------------------------------------------------diagonal from middle tokens 4 and 11------------------------------------------------
  -- diag from middle token
  for middleToken = 4, 11, 7 do
    fourSum5 = 0
    if grid.listTokens[middleToken].tokenType == player then -- minimum possibility of win
      for a = middleToken, (middleToken + 18), 6 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum5 = fourSum5 + 1
        end
        table.insert(winTokens, a)
      end
      if fourSum5 >= 4 then -- if so, win
        winPlayer = player
        winToken = middleToken
        return true
      else
        winTokens = {}
        fourSum5 = 0
        for a = middleToken, (middleToken + 24), 8 do -- check if there are 4 tokens in the diagonal
          if grid.listTokens[a].tokenType == player then
            fourSum5 = fourSum5 + 1
          end
          table.insert(winTokens, a)
        end
      end
      if fourSum5 >= 4 then -- if so, win
        winPlayer = player
        winToken = middleToken
        return true
      else winTokens = {}
      end
    end
  end
  
-----------------------------------------------------diagonal from 1st row-----------------------------------------------------
  -- diag \ from 1st row
  for miniToken5 = 1, 2 do
    fourSum6 = 0
    if grid.listTokens[miniToken5].tokenType == player then -- minimum possibility of win
      for a = miniToken5, (miniToken5 + 40), 8 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum6 = fourSum6 + 1
        end
      end
      if fourSum6 >= 4 then -- if so, let's check it there are 4 in a row
        local d
        for d = 0, 40, 8 do
          if grid.listTokens[miniToken5 + d].tokenType == player then
            fourSucc6 = fourSucc6 + 1
            table.insert(winTokens, miniToken5 + d)
            if fourSucc6 >= 4 then
              winPlayer = player
              winToken = miniToken5
              return true -- win !!
            end
          else
            fourSucc6 = 0
            winTokens = {}
          end
        end
      end
    end
  end
  
  -- diag / from 1st row
  for miniToken6 = 6, 7 do
    fourSum7 = 0
    if grid.listTokens[miniToken6].tokenType == player then -- minimum possibility of win
      for a = miniToken6, (miniToken6 + 30), 6 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum7 = fourSum7 + 1
        end
      end
      if fourSum7 >= 4 then -- if so, let's check it there are 4 in a row
        local d
        for d = 0, 30, 6 do
          if grid.listTokens[miniToken6 + d].tokenType == player then
            fourSucc7 = fourSucc7 + 1
            table.insert(winTokens, miniToken6 + d)
            if fourSucc7 >= 4 then
              winPlayer = player
              winToken = miniToken6
              return true -- win !!
            end
          else
            fourSucc7 = 0
            winTokens = {}
          end
        end
      end
    end
  end
  
--------------------------------------------------------diagonal from tokens 3 and 5------------------------------------------------
  -- diag from tokens 3 and 5
  if grid.listTokens[3].tokenType == player then -- minimum possibility of win
    for a = 3, (3 + 32), 8 do -- check if there are 4 tokens in the diagonal
      if grid.listTokens[a].tokenType == player then
        fourSum8 = fourSum8 + 1
      end
    end
    if fourSum8 >= 4 then -- if so, let's check it there are 4 in a row
        local d
        for d = 0, 32, 8 do
          if grid.listTokens[3 + d].tokenType == player then
            fourSucc8 = fourSucc8 + 1
            table.insert(winTokens, 3 + d)
            if fourSucc8 >= 4 then
              winPlayer = player
              winToken = 3
              return true -- win !!
            end
          else
            fourSucc8 = 0
            winTokens = {}
          end
        end
      end
  end
  if grid.listTokens[5].tokenType == player then -- minimum possibility of win
    fourSum8 = 0
    fourSucc8 = 0
    for a = 5, (5 + 24), 6 do -- check if there are 4 tokens in the diagonal
      if grid.listTokens[a].tokenType == player then
        fourSum8 = fourSum8 + 1
      end
    end
    if fourSum8 >= 4 then -- if so, let's check it there are 4 in a row
        local d
        for d = 0, 24, 6 do
          if grid.listTokens[5 + d].tokenType == player then
            fourSucc8 = fourSucc8 + 1
            table.insert(winTokens, 5 + d)
            if fourSucc8 >= 4 then
              winPlayer = player
              winToken = 5
              return true -- win !!
            end
          else
            fourSucc8 = 0
            winTokens = {}
          end
        end
      end
  end
  
  
  
  
  return false
end

function animeToken(dt, player, destination)
  
  if player == "yellow" then
    love.graphics.setColor(myColors.yellow)
  elseif player == "red" then
    love.graphics.setColor(myColors.red)
  end
  
  
  love.graphics.circle("fill", grid.listTokens[destination].pixX, 10 * dt, grid.tokenDiam/2)
  
  love.timer.sleep(2)
  loadAnimation = false
end

function love.update(dt)
  
  if winState == true then -- if win, we can quit
    if love.keyboard.isDown("space") then
      love.event.quit()
    end
  
  else
  
    alpha = love.mouse.getX() -- get the x coordinate of the mouse
    -- to determinate in which column we are
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
    
    -- update the x coordinate for the cursor
    cursorX = cell.width * cursorColumn - cell.width/2
    
    beta = love.mouse.isDown(1) -- left click
    delta = love.mouse.isDown(2) -- right click
    
    if grid.listTokens[cursorColumn].tokenType == "empty" then -- if there some space to put a token
    
      if beta == true and whosTurn == "yellow" then
        if grid.listTokens[42 - 7 + cursorColumn].tokenType == "empty" then -- if the space is free in the 6th and last row
          loadAnimation = true
          grid.listTokens[42 - 7 + cursorColumn].tokenType = "yellow"
        elseif grid.listTokens[42 - 14 + cursorColumn].tokenType == "empty" then -- if the space is free in the 5th row
          grid.listTokens[42 - 14 + cursorColumn].tokenType = "yellow"
        elseif grid.listTokens[42 - 21 + cursorColumn].tokenType == "empty" then -- if the space is free in the 4th and last row
          grid.listTokens[42 - 21 + cursorColumn].tokenType = "yellow"
        elseif grid.listTokens[42 - 28 + cursorColumn].tokenType == "empty" then -- if the space is free in the 3th and last row
          grid.listTokens[42 - 28 + cursorColumn].tokenType = "yellow"
        elseif grid.listTokens[42 - 35 + cursorColumn].tokenType == "empty" then -- if the space is free in the 2nd and last row
          grid.listTokens[42 - 35 + cursorColumn].tokenType = "yellow"
        elseif grid.listTokens[42 - 42 + cursorColumn].tokenType == "empty" then -- if the space is free in the 1st and last row
          grid.listTokens[42 - 42 + cursorColumn].tokenType = "yellow"
        end
        
        tokensPlayed = tokensPlayed + 1 -- count the number of tokens used
        
        -- if number of tokens > 6, we can check for win
        -- and if one of the check functions returns true
        if tokensPlayed >= 7 and ( checkLineWin("yellow") or checkColumnWin("yellow") or checkDiagWin("yellow") ) then
          winState = true -- win
        else whosTurn = "red" -- else turn for the other player
        end
        
      end
      
      if delta == true and whosTurn == "red" then
        if grid.listTokens[42 - 7 + cursorColumn].tokenType == "empty" then
          grid.listTokens[42 - 7 + cursorColumn].tokenType = "red"
        elseif grid.listTokens[42 - 14 + cursorColumn].tokenType == "empty" then
          grid.listTokens[42 - 14 + cursorColumn].tokenType = "red"
        elseif grid.listTokens[42 - 21 + cursorColumn].tokenType == "empty" then
          grid.listTokens[42 - 21 + cursorColumn].tokenType = "red"
        elseif grid.listTokens[42 - 28 + cursorColumn].tokenType == "empty" then
          grid.listTokens[42 - 28 + cursorColumn].tokenType = "red"
        elseif grid.listTokens[42 - 35 + cursorColumn].tokenType == "empty" then
          grid.listTokens[42 - 35 + cursorColumn].tokenType = "red"
        elseif grid.listTokens[42 - 42 + cursorColumn].tokenType == "empty" then
          grid.listTokens[42 - 42 + cursorColumn].tokenType = "red"
        end
        
        tokensPlayed = tokensPlayed + 1
        
        if tokensPlayed >= 7 and ( checkLineWin("red") or checkColumnWin("red") or checkDiagWin("red") ) then
          winState = true
        else whosTurn = "yellow"
        end
        
      end
    
    end

  end
  
end

function love.draw()
  
  -- header background
  love.graphics.setColor(myColors.white)
  love.graphics.rectangle("fill", 0, 0, windowWidth, cell.height)
  
  -- draw the cursors
  if winState == false then
    if whosTurn == "yellow" then
      love.graphics.draw(listPics.yellowCursorLoad, cursorX, cursorY, 0, 1, 1, listPics.yellowCursorWidth/2, listPics.yellowCursorHeight/2)
    elseif whosTurn == "red" then
      love.graphics.draw(listPics.redCursorLoad, cursorX, cursorY, 0, 1, 1, listPics.redCursorWidth/2, listPics.redCursorHeight/2)
    end
  end
  
  -- frame of the game in blue
  love.graphics.setColor(myColors.blue)
  love.graphics.rectangle("fill", 0, cell.height, windowWidth, windowHeight - cell.height)
  
  if loadAnimation == true then
    animeToken(dt, "yellow", 42 - 7 + cursorColumn)
  end
  
  -- coloring the tokens or the vacuum
  local l, c
  local tokenId = 1
  for l = 2, grid.line do
    for c = 1, grid.column do
      -- define the right color for each tokens/vacuum
      if grid.listTokens[tokenId].tokenType == "empty" then
        love.graphics.setColor(myColors.black)
      elseif grid.listTokens[tokenId].tokenType == "yellow" then
        love.graphics.setColor(myColors.yellow)
      elseif grid.listTokens[tokenId].tokenType == "red" then
        love.graphics.setColor(myColors.red)
      end
      -- draw the tokens/vacuum
      love.graphics.circle("fill", grid.listTokens[tokenId].pixX, grid.listTokens[tokenId].pixY, grid.tokenDiam/2)
    tokenId = tokenId + 1
    end
  end
  
  if winState == true then
    if winPlayer == "yellow" then
      love.graphics.setColor(myColors.yellow)
    elseif winPlayer == "red" then
      love.graphics.setColor(myColors.red)
    end
    love.graphics.print("The player "..winPlayer.." win with the tokens from "..winTokens[1].." to "..winTokens[4], cell.width*1.5, cell.height / 4, 0, 1.1, 1.1)
    
    for numToken = 1, 4 do
      love.graphics.draw(listPics.crossLoad, grid.listTokens[winTokens[numToken]].pixX, grid.listTokens[winTokens[numToken]].pixY, 0, 1, 1, listPics.crossWidth/2, listPics.crossHeight/2)
    end
    
    
  end



end

function love.keypressed(key)
  
  print(key)
  
end