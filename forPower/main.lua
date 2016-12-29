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

tokensPlayed = 0

function love.load()
  
  love.window.setMode(windowWidth, windowHeight)
  cell.height = windowHeight/grid.line
  cell.width = windowWidth/grid.column
  
  grid.tokenDiam = cell.width - 10
  
  local l, c
  local tokenId = 1
  local bx, by = 0, 0
  by = cell.height + cell.height/2
  for l = 2, grid.line do
    bx = cell.width/2
    for c = 1, grid.column do
      grid.listTokens[tokenId] = {id = tokenId, tabX = c, tabY = l, pixX = bx, pixY = by, tokenType = "empty"}
      bx = bx + cell.width
      tokenId = tokenId + 1
    end
    by = by + cell.height
  end
  
  cursorY = cell.height - 20
  
end

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
            if fourSucc >= 4 then
              return true -- win !!
            end
          else fourSucc = 0
          end
        end
      end
    end
  end
  return false -- no win
end

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
            if fourSucc >= 4 then
              return true -- win !!
            end
          else fourSucc = 0
          end
        end
      end
      
    end
  end
  return false
end

function checkDiagWin(player)
  local miniToken1, miniToken2, miniToken3, miniToken4, middleToken, miniToken5, miniToken6, otherTokens
  local fourSum1, fourSum2, fourSum3, fourSum4, fourSum5, fourSum6, fourSum7, fourSum8 = 0, 0, 0, 0, 0, 0, 0, 0
  
  -- diag \ from 3rd row
  for miniToken1 = 15, 18 do
    if grid.listTokens[miniToken1].tokenType == player then -- minimum possibility of win
      for a = miniToken1, (miniToken1 + 24), 8 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum1 = fourSum1 + 1
        end
      end
      if fourSum1 >= 4 then -- if so, win
        return true
      end
    end
  end
  
  -- diag / from 3rd row
  for miniToken2 = 18, 21 do
    if grid.listTokens[miniToken2].tokenType == player then -- minimum possibility of win
      for a = miniToken2, (miniToken2 + 18), 6 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum2 = fourSum2 + 1
        end
      end
      if fourSum2 >= 4 then -- if so, win
        return true
      end
    end
  end
  
  -- diag \ from 2nd row
  for miniToken3 = 8, 10 do
    if grid.listTokens[miniToken3].tokenType == player then -- minimum possibility of win
      for a = miniToken3, (miniToken3 + 32), 8 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum3 = fourSum3 + 1
        end
      end
      if fourSum3 >= 4 then -- if so, win
        --return true
      end
    end
  end
  
  -- diag / from 2nd row
  for miniToken4 = 12, 14 do
    if grid.listTokens[miniToken4].tokenType == player then -- minimum possibility of win
      for a = miniToken4, (miniToken4 + 24), 6 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum4 = fourSum4 + 1
        end
      end
      if fourSum4 >= 4 then -- if so, win
        --return true
      end
    end
  end
  
  
  -- diag from middle token
  for middleToken = 4, 11, 7 do
    if grid.listTokens[middleToken].tokenType == player then -- minimum possibility of win
      for a = middleToken, (middleToken + 18), 6 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum5 = fourSum5 + 1
        end
      end
      if fourSum5 >= 4 then -- if so, win
        return true
      else
        fourSum5 = 0
        for a = middleToken, (middleToken + 24), 8 do -- check if there are 4 tokens in the diagonal
          if grid.listTokens[a].tokenType == player then
            fourSum5 = fourSum5 + 1
          end
        end
      end
      if fourSum5 >= 4 then -- if so, win
        return true
      end
    end
  end
  
  -- diag \ from 1st row
  for miniToken5 = 1, 2 do
    if grid.listTokens[miniToken5].tokenType == player then -- minimum possibility of win
      for a = miniToken5, (miniToken5 + 40), 8 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum6 = fourSum6 + 1
        end
      end
      if fourSum6 >= 4 then -- if so, win
        --return true
      end
    end
  end
  
  -- diag / from 1st row
  for miniToken6 = 6, 7 do
    if grid.listTokens[miniToken6].tokenType == player then -- minimum possibility of win
      for a = miniToken6, (miniToken6 + 30), 6 do -- check if there are 4 tokens in the diagonal
        if grid.listTokens[a].tokenType == player then
          fourSum7 = fourSum7 + 1
        end
      end
      if fourSum7 >= 4 then -- if so, win
        --return true
      end
    end
  end
  
  -- diag from tokens 3 and 5
  if grid.listTokens[3].tokenType == player then -- minimum possibility of win
    for a = otherTokens, (otherTokens + 32), 8 do -- check if there are 4 tokens in the diagonal
      if grid.listTokens[a].tokenType == player then
        fourSum8 = fourSum8 + 1
      end
    end
    if fourSum8 >= 4 then -- if so, win
      --return true
    end
  end
  if grid.listTokens[5].tokenType == player then -- minimum possibility of win
    fourSum8 = 0
    for a = otherTokens, (otherTokens + 24), 6 do -- check if there are 4 tokens in the diagonal
      if grid.listTokens[a].tokenType == player then
        fourSum8 = fourSum8 + 1
      end
    end
    if fourSum8 >= 4 then -- if so, win
      --return true
    end
  end
  
  
  
  
  return false
end

function love.update(dt)
  
  if winState == true then
    if love.keyboard.isDown("space") then
      love.event.quit()
    end
  
  else
  
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
    
    beta = love.mouse.isDown(1) -- left click
    delta = love.mouse.isDown(2) -- right click
    
    if grid.listTokens[cursorColumn].tokenType == "empty" then -- if there some space to put a token
    
      if beta == true and whosTurn == "yellow" then
        if grid.listTokens[42 - 7 + cursorColumn].tokenType == "empty" then
          grid.listTokens[42 - 7 + cursorColumn].tokenType = "yellow"
        elseif grid.listTokens[42 - 14 + cursorColumn].tokenType == "empty" then
          grid.listTokens[42 - 14 + cursorColumn].tokenType = "yellow"
        elseif grid.listTokens[42 - 21 + cursorColumn].tokenType == "empty" then
          grid.listTokens[42 - 21 + cursorColumn].tokenType = "yellow"
        elseif grid.listTokens[42 - 28 + cursorColumn].tokenType == "empty" then
          grid.listTokens[42 - 28 + cursorColumn].tokenType = "yellow"
        elseif grid.listTokens[42 - 35 + cursorColumn].tokenType == "empty" then
          grid.listTokens[42 - 35 + cursorColumn].tokenType = "yellow"
        elseif grid.listTokens[42 - 42 + cursorColumn].tokenType == "empty" then
          grid.listTokens[42 - 42 + cursorColumn].tokenType = "yellow"
        end
        
        tokensPlayed = tokensPlayed + 1
        
        if tokensPlayed >= 7 and ( checkLineWin("yellow") or checkColumnWin("yellow") or checkDiagWin("yellow") ) then
          winState = true
          print("yellow win the game !")
        else whosTurn = "red"
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
          print("red win the game !")
        else whosTurn = "yellow"
        end
        
      end
    
    end

  end
  
end

function love.draw()

  love.graphics.setColor(myColors.blue)
  love.graphics.rectangle("fill", 0, cell.height, windowWidth, windowHeight - cell.height)
  
  
  local l, c
  local tokenId = 1
  for l = 2, grid.line do
    for c = 1, grid.column do
      if grid.listTokens[tokenId].tokenType == "empty" then
        love.graphics.setColor(myColors.black)
      elseif grid.listTokens[tokenId].tokenType == "yellow" then
        love.graphics.setColor(myColors.yellow)
      elseif grid.listTokens[tokenId].tokenType == "red" then
        love.graphics.setColor(myColors.red)
      end
      love.graphics.circle("fill", grid.listTokens[tokenId].pixX, grid.listTokens[tokenId].pixY, grid.tokenDiam/2)
    tokenId = tokenId + 1
    end
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