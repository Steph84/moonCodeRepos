local Machina = {}
Machina.keyPressed = false
local windowWidth, windowHeight, TILE_SIZE

Machina.costDrill = 5
local costMove = 1
local harvestOil

local rightPic, upPic, downPic = {}, {}, {}
local soundEffects = {}

-- initialize oil count harvest by the machina in each level
Machina.countOil = {}
local iter
for iter = 1, 5 do
  Machina.countOil[iter] = 0
end

local myMap = require("map")

function Machina.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  -- load the sound effects
  soundEffects.bump = love.audio.newSource("sounds/bump.wav", "static")
  soundEffects.drill = love.audio.newSource("sounds/drill.wav", "static")
  soundEffects.move = love.audio.newSource("sounds/move.wav", "static")
  soundEffects.move:setVolume(0.5)
  soundEffects.extract = love.audio.newSource("sounds/extract.wav", "static")
  
  -- first spawn of the machina
  local tempCol, tempLin
  tempCol, tempLin = Machina.Spawn(1, myMap)
  
  -- initialize the different parts of the Machina
  Machina.body = {col = tempCol, lin = tempLin, dir = "right", isHere = true}
  Machina.power = myMap.size.w * 2
  Machina.action = {right = true, left = true, up = true, down = true,
                    drill = false, teleport = false, extract = false}
  
  -- determine the cost of all action
  Machina.costTeleport = myMap.size.w * 1
  Machina.costDrill = myMap.size.w * 0.25
  Machina.costExtract = myMap.size.w * 10
  
  -- load pictures of the Machina
  rightPic.src = love.graphics.newImage("pictures/TheMachina_right.png")
  upPic.src = love.graphics.newImage("pictures/TheMachina_up.png")
  downPic.src = love.graphics.newImage("pictures/TheMachina_down.png")
  
end

-- function to spawn the machina at each level beginning
function Machina.Spawn(pLevel, pMap)
  local col, lin
  local rdCol, rdLin
  
  -- determine a spawn point at the center but not on a block
  repeat
    rdCol = math.floor(math.random(myMap.size.w * 0.4, myMap.size.w * 0.6))
    rdLin = math.floor(math.random(myMap.size.h * 0.4, myMap.size.h * 0.6))
  until (myMap.listGrids[pLevel][rdLin][rdCol].texture ~= "block")
  
  col = rdCol
  lin = rdLin
  
  return col, lin
end

function Machina.Update(dt, pLevel, pMap, pMenuState)
  
  -- if the machina is not here, ie if transition level animation
  if Machina.body.isHere == false then
    local tempCol, tempLin
    tempCol, tempLin = Machina.Spawn(pLevel, myMap)
    Machina.body = {col = tempCol, lin = tempLin, dir = "right", isHere = true}
    Machina.body.isHere = true
  end
  
  -- if the machina is here, ie if it's playable
  if Machina.body.isHere == true then
    if love.keyboard.isDown("right", "left", "up", "down", "d", "t", "e") then
      if Machina.keyPressed == false then
        local oldCoor = {Machina.body.col, Machina.body.lin}
        local backTo = false
        
        -- movement along the map
        if love.keyboard.isDown("right") then
          Machina.body.col = Machina.body.col + 1
          Machina.power = Machina.power - costMove
          Machina.body.dir = "right"
          soundEffects.move:play()
        end
        if love.keyboard.isDown("left") then
          Machina.body.col = Machina.body.col - 1
          Machina.power = Machina.power - costMove
          Machina.body.dir = "left"
          soundEffects.move:play()
        end
        if love.keyboard.isDown("up") then
          Machina.body.lin = Machina.body.lin - 1
          Machina.power = Machina.power - costMove
          Machina.body.dir = "up"
          soundEffects.move:play()
        end
        if love.keyboard.isDown("down") then
          Machina.body.lin = Machina.body.lin + 1
          Machina.power = Machina.power - costMove
          Machina.body.dir = "down"
          soundEffects.move:play()
        end
        
        -- drill action
        if Machina.action.drill == true then
          if love.keyboard.isDown("d") then
            pMap[Machina.body.lin][Machina.body.col].idText = 10
            pMap[Machina.body.lin][Machina.body.col].petrol = false
            Machina.power = Machina.power - Machina.costDrill
            local harvestOil = math.random(myMap.size.w, myMap.size.w * 1.5)
            Machina.power = Machina.power + harvestOil
            myMap.countOil[pLevel] = myMap.countOil[pLevel] - 1
            Machina.countOil[pLevel] = Machina.countOil[pLevel] + 1
            soundEffects.drill:stop() -- avoid to overlap the sounds
            soundEffects.drill:play()
          end
        end
        
        -- teleport action
        if Machina.action.teleport == true then
          if love.keyboard.isDown("t") then
            Machina.power = Machina.power - Machina.costTeleport
            pLevel = pLevel + 1
          end
        end
        
        -- extract action
        if Machina.action.extract == true then
          if love.keyboard.isDown("e") then
            soundEffects.extract:play()
            Machina.power = Machina.power - Machina.costExtract
            pMap[Machina.body.lin][Machina.body.col].idText = 10
            pMenuState = "win"
          end
        end
            
        Machina.keyPressed = true
        
        -- determine if the movement is possible, ie collision or not
        if Machina.body.lin < 1 or Machina.body.col < 1 or Machina.body.lin > myMap.size.h or Machina.body.col > myMap.size.w then
          backTo = true
        elseif pMap[Machina.body.lin][Machina.body.col].texture == "block" then
          backTo = true
        end
        
        -- if movement not possible, back to early tile
        if backTo == true then
          Machina.body.col = oldCoor[1]
          Machina.body.lin = oldCoor[2]
          Machina.power = Machina.power + costMove
          soundEffects.bump:stop() -- avoid to overlap the sounds
          soundEffects.bump:play()
        end
        
      end
    else Machina.keyPressed = false
    end

    -- determine if drilling is possible
    if pMap[Machina.body.lin][Machina.body.col].petrol == true and Machina.power >= Machina.costDrill then
      Machina.action.drill = true
    else Machina.action.drill = false
    end
  
    -- determine if extraction is possible
    if pMap[Machina.body.lin][Machina.body.col].idText == 11 and Machina.power >= Machina.costExtract then
      Machina.action.extract = true
    else Machina.action.extract = false
    end

    -- determine if teleportation is possible
    if Machina.power >= Machina.costTeleport and pLevel < 5 then
      Machina.action.teleport = true
    else Machina.action.teleport = false
    end

    -- reveal tile from the fog
    local alongLine, alongColumn
    for alongLine = -2, 2, 1 do
      for alongColumn = -2, 2, 1 do
        if Machina.body.lin + alongLine > 0 and Machina.body.col + alongColumn > 0
           and Machina.body.lin + alongLine < myMap.size.h + 1 and Machina.body.col + alongColumn < myMap.size.w + 1 then
               pMap[Machina.body.lin + alongLine][Machina.body.col + alongColumn].isHidden = false
        end
      end
    end
  end
  
  if Machina.power < 1 then pMenuState = "lose" end
  
  return pLevel, pMenuState
end

function Machina.Draw()
  
  -- show the right picture for each direction
  if Machina.body.dir == "right" then
    love.graphics.draw(rightPic.src, (Machina.body.col-1) * TILE_SIZE - 4, (Machina.body.lin-1) * TILE_SIZE - 4)
  elseif Machina.body.dir == "left" then
    love.graphics.draw(rightPic.src, (Machina.body.col-1) * TILE_SIZE - 4 + 40, (Machina.body.lin-1) * TILE_SIZE - 4, 0, -1, 1)
  elseif Machina.body.dir == "up" then
    love.graphics.draw(upPic.src, (Machina.body.col-1) * TILE_SIZE - 4, (Machina.body.lin-1) * TILE_SIZE - 4)
  elseif Machina.body.dir == "down" then
    love.graphics.draw(downPic.src, (Machina.body.col-1) * TILE_SIZE - 4, (Machina.body.lin-1) * TILE_SIZE - 4)
  end
end

return Machina