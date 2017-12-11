local Player = {}

local windowWidth, windowHeight
local MapSize = {}
local myMouse = require("mouseControl")
local myComboBox = require("comboBox")
local TILE_SIZE

Player.Position = {x = 0, y = 0, col = 0, lin = 0}

function Player.Load(pWindowWidth, pWindowHeight, pTileSize, pMapSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  MapSize = pMapSize
  
  myComboBox.Load(TILE_SIZE)
  
end

function Player.Update(dt)
  if love.window.hasMouseFocus() then Player.Position.x, Player.Position.y = love.mouse.getPosition() end
  
  Player.Position.col = math.ceil(Player.Position.x / TILE_SIZE)
  Player.Position.lin = math.ceil(Player.Position.y / TILE_SIZE)
  if Player.Position.lin > MapSize.h then Player.Position.lin = MapSize.h end
  if Player.Position.lin < 1 then Player.Position.lin = 1 end
  
  myComboBox.Update(dt)
  
  if myMouse.clicked then
    myComboBox.opened = true
    myComboBox.dimensions.x = Player.Position.col * TILE_SIZE - TILE_SIZE/2
    myComboBox.dimensions.y = Player.Position.lin * TILE_SIZE - TILE_SIZE/2
    myMouse.clicked = false
  end
end

function Player.Draw()
  myComboBox.Draw()
  love.graphics.printf("X : "..Player.Position.x.." / Y : "..Player.Position.y, 5, windowHeight - 40, 500, "left")
  love.graphics.printf("Column : "..Player.Position.col.." / Line : "..Player.Position.lin, 5, windowHeight - 20, 500, "left")
end

return Player