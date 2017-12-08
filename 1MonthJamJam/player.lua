local Player = {}

local windowWidth, windowHeight
local myMap = {}

Player.position = {x = 0, y = 0, col = 0, lin = 0}

function Player.Load(pWindowWidth, pWindowHeight, pMyMap)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  myMap = pMyMap
  
end

function Player.Update(dt)
  if love.window.hasMouseFocus() then Player.position.x, Player.position.y = love.mouse.getPosition() end
  
  Player.position.col = math.ceil(Player.position.x / myMap.TILE_SIZE)
  Player.position.lin = math.ceil(Player.position.y / myMap.TILE_SIZE)
  if Player.position.lin > myMap.size.h then Player.position.lin = myMap.size.h end
  if Player.position.lin < 1 then Player.position.lin = 1 end
  
end

function Player.Draw()
  love.graphics.printf("X : "..Player.position.x.." / Y : "..Player.position.y, 5, windowHeight - 40, 500, "left")
  love.graphics.printf("Column : "..Player.position.col.." / Line : "..Player.position.lin, 5, windowHeight - 20, 500, "left")
end

return Player