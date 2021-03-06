local Menu = {}
--Menu.__index = Menu

Menu.Title = {}
-- the title I want to draw
Menu.Title =  {
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0},
      {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0},
      {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0},
      {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0},
      {0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0},
      {0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
              }

local TITLE_WIDTH = #Menu.Title[1] 
local TITLE_HEIGHT = #Menu.Title

local TILE_WIDTH
local TILE_HEIGHT

local gapWidth
local gapHeight
local offSet = 50
local alpha1 = 0
local alphaSpeed = 1
local scene = nil
local timeElapsed = 0
local storyR = 255
local storyG = 0
local storyB = 0

Menu.TypeFace = {}

function Menu.Load(pWindowWidth, pWindowHeight, pTheTile, pListPiece)
  scene = "one"
  Menu.TypeFace[0] = nil
  Menu.TypeFace[1] = pTheTile -- I just have 1 kind of tile for this one
  
  TILE_WIDTH = Menu.TypeFace[1]:getWidth()
  TILE_HEIGHT = Menu.TypeFace[1]:getHeight()
  
  -- calculate the gap between 2 tiles
  gapWidth = ((pWindowWidth - offSet) - (TITLE_WIDTH * TILE_WIDTH))/TITLE_WIDTH
  gapHeight = ((pWindowHeight - pWindowHeight/2) - (TITLE_HEIGHT * TILE_HEIGHT))/TITLE_HEIGHT
  
  local c, l
  local n = 1
  for l = 1, TITLE_HEIGHT do 
    for c = 1, TITLE_WIDTH do
      local id = Menu.Title[l][c]
      if id == 1 then
        -- determinate the target coordinates of all the pieces
        pListPiece[n].targetX = (c-1)*(TILE_WIDTH + gapWidth) + offSet/2
        pListPiece[n].targetY = (l-1)*(TILE_HEIGHT + gapHeight) + offSet
        n = n + 1
      end
    end
  end
end

function Menu.Update(dt, pTitleDrawing, pList_pieces)
  
  if pTitleDrawing == false then
    
    timeElapsed = timeElapsed + dt
    
    if scene == "one" then
      if timeElapsed > 3 then
        scene = "two"
      end
    end
    
    if scene == "two" then
      if alpha1 <= 255 and alpha1 >= 0 then
        alpha1 = alpha1 + alphaSpeed
      end
      if alpha1 == 255 then
        alphaSpeed = 0 - alphaSpeed
      end
      if alpha1 < 0 then
        scene = "three"
        timeElapsed = 0
      end
    end
    
    if scene == "three" then
      if timeElapsed > 3 then
        scene = "four"
        pTitleDrawing = true
        timeElapsed = 0
      end
    end
    return pTitleDrawing
  end
  
  if pTitleDrawing == true then
    local colorSpeed = 1.2
    if #pList_pieces == 121 then
      timeElapsed = timeElapsed + dt
      storyR = (255/2) * (math.cos(timeElapsed/colorSpeed) + 1)
      storyG = (255/2) * (math.cos(timeElapsed/colorSpeed + (2*3.14/3)) + 1) -- offset of 2/3 PI
      storyB = (255/2) * (math.cos(timeElapsed/colorSpeed + (4*3.14/3)) + 1) -- offset of 2 * 2/3 PI
      if alpha1 < 255 then
        alpha1 = alpha1 + 1
      end
    end
  end
  
end

function Menu.Draw(pTitleDrawing, pGloX, pGloY, pList_pieces)
  -- draw a prompt following the global center
  if pTitleDrawing == false then
    love.graphics.setColor(255, 255, 255, alpha1)
    -- draw prompt "be prepared..." at the global center
    -- wrapped in 200 pixels, centered
    -- scale of 3 times
    -- offset and shearing
    love.graphics.printf("BE PREPARED ...", pGloX, pGloY, 200, "center", 0, 3, 3, 200/2, 10, -0.2, 0)
  end
  
  if pTitleDrawing == true then
    if #pList_pieces == 121 then
      -- TODO following animation
    -- draw picture with rainbow effects
    
    love.graphics.setColor(storyR, storyG, storyB, alpha1)
    love.graphics.print("S", 250, 475, 0, 5, 5, 0, 0, 0.5, 0)
    love.graphics.print("T", 300, 450, 0, 5, 5, 0, 0, 0.5, 0)
    love.graphics.print("O", 350, 425, 0, 5, 5, 0, 0, 0.5, 0)
    love.graphics.print("R", 400, 400, 0, 5, 5, 0, 0, 0.5, 0)
    love.graphics.print("Y", 450, 375, 0, 5, 5, 0, 0, 0.5, 0)
    
    end
  end

  love.graphics.setColor(255, 255, 255)
end



return Menu