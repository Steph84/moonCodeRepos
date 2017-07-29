local Machina = {}
Machina.keyPressed = false
local windowWidth, windowHeight, TILE_SIZE

local costDrill = 5
local costMove = 1
local costTeleport
local harvestOil

local myMap = require("map")

function Machina.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  local tempCol, tempLin
  tempCol, tempLin = Machina.Spawn(1, myMap)
  
  Machina.body = {col = tempCol, lin = tempLin, dir = "right", isHere = true}
  Machina.power = myMap.size.w
  Machina.action = {right = true, left = true, up = true, down = true,
                    drill = false, teleport = false, extract = false}
  
  costTeleport = myMap.size.w * 0.75
  
end

function Machina.Spawn(pLevel, pMap)
  local col, lin
  local rdCol, rdLin
  
  repeat
    rdCol = math.floor(math.random(myMap.size.w * 0.4, myMap.size.w * 0.6))
    rdLin = math.floor(math.random(myMap.size.h * 0.4, myMap.size.h * 0.6))
  until (myMap.listGrids[pLevel][rdLin][rdCol].texture ~= "block")
  
  col = rdCol
  lin = rdLin
  
  return col, lin
end

function Machina.Update(dt, pLevel, pMap)
  
  if Machina.body.isHere == false then
    local tempCol, tempLin
    tempCol, tempLin = Machina.Spawn(pLevel, myMap)
    Machina.body = {col = tempCol, lin = tempLin, dir = "right", isHere = true}
    Machina.body.isHere = true
  end
  
  if Machina.body.isHere == true then
    if love.keyboard.isDown("right", "left", "up", "down", "d", "t") then
      if Machina.keyPressed == false then
        local oldCoor = {Machina.body.col, Machina.body.lin}
        local backTo = false
        
        if love.keyboard.isDown("right") then Machina.body.col = Machina.body.col + 1 end
        if love.keyboard.isDown("left") then Machina.body.col = Machina.body.col - 1 end
        if love.keyboard.isDown("up") then Machina.body.lin = Machina.body.lin - 1 end
        if love.keyboard.isDown("down") then Machina.body.lin = Machina.body.lin + 1 end
        
        if Machina.action.drill == true then
          if love.keyboard.isDown("d") then
            pMap[Machina.body.lin][Machina.body.col].idText = 10
            pMap[Machina.body.lin][Machina.body.col].petrol = false
            Machina.power = Machina.power - costDrill
            local harvestOil = math.random(myMap.size.w/2, myMap.size.w)
            Machina.power = Machina.power + harvestOil
          end
        end
        
        if Machina.action.teleport == true then
          if love.keyboard.isDown("t") then
            Machina.power = Machina.power - costTeleport
            pLevel = pLevel + 1
          end
        end
        
        Machina.keyPressed = true
        
        if Machina.body.lin < 1 or Machina.body.col < 1 or Machina.body.lin > myMap.size.h or Machina.body.col > myMap.size.w then
          backTo = true
        elseif pMap[Machina.body.lin][Machina.body.col].texture == "block" then
          backTo = true
        end
        
        if backTo == true then
          Machina.body.col = oldCoor[1]
          Machina.body.lin = oldCoor[2]
        end
        
        if backTo == false then Machina.power = Machina.power - costMove end
        
      end
    else Machina.keyPressed = false
    end

    if pMap[Machina.body.lin][Machina.body.col].petrol == true then
      Machina.action.drill = true
    else Machina.action.drill = false
    end
  
    if pMap[Machina.body.lin][Machina.body.col].idText == 11 then
      Machina.action.extract = true
    else Machina.action.extract = false
    end

    if Machina.power > myMap.size.w * 1.5 then
      Machina.action.teleport = true
    else Machina.action.teleport = false
    end

    -- reveal tile from the fog
    local alongLine, alongColumn
    for alongLine = -1, 1, 1 do
      for alongColumn = -1, 1, 1 do
        if Machina.body.lin + alongLine > 0 and Machina.body.col + alongColumn > 1
           and Machina.body.lin + alongLine < myMap.size.h + 1 and Machina.body.col + alongColumn < myMap.size.w + 1 then
               pMap[Machina.body.lin + alongLine][Machina.body.col + alongColumn].isHidden = false
        end
      end
    end
  end
  return pLevel
end

function Machina.Draw()
  love.graphics.rectangle("fill", (Machina.body.col-1) * TILE_SIZE + 8, (Machina.body.lin-1) * TILE_SIZE + 8, 16, 16)
  love.graphics.print(Machina.power, (Machina.body.col-1) * TILE_SIZE + 8, (Machina.body.lin-1) * TILE_SIZE + 8)
  if Machina.action.drill == true then
    love.graphics.print("you can drill", 32, windowHeight - 32)
  end
  if Machina.action.teleport == true then
    love.graphics.print("you can teleport", 100, windowHeight - 32)
  end
end

return Machina