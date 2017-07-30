local Credits = {}

local windowWidth, windowHeight, fontSize

local dataObject = {} -- all the credits
local dataBloc = {} -- bloc of credits
local dataNumberLines = 3 -- title, name, url
local itemFonts = {}

local myPicture = require("loadPictures")

function Credits.Load(pWindowWidth, pWindowHeight, pFontSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  fontSize = pFontSize
  
  itemFonts.credits1 = love.graphics.newFont("fonts/Pacifico.ttf", fontSize * 2)
  itemFonts.credits2 = love.graphics.newFont("fonts/Times_New_Roman_Normal.ttf", fontSize)
  
  dataObject = {}
  
  local iteration = 0
  for line in love.filesystem.lines("data/dataCredits.txt") do
    table.insert(dataBloc, line)
    iteration = iteration + 1
    
    if iteration == 3 then
      iteration = 0      
      table.insert(dataObject, dataBloc)
      dataBloc = {}
    end
  end
end

function Credits.Update(dt, pGameState)
  if love.keyboard.isDown("escape") then pGameState = "title" end
  return pGameState
end

function Credits.Draw()
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(itemFonts.credits1)
  love.graphics.printf("The Credits", 0, windowHeight * 0.02, windowWidth, "center")
  
  love.graphics.setFont(itemFonts.credits2)
  local i, j
  for i = 1, #dataObject do
    for j = 1, #dataObject[i] do
      love.graphics.printf(dataObject[i][j],
                           windowWidth * 0.1,
                           -- offset 10%       + offset between 2 blocks   + offset between 2 lines in the same block
                           windowHeight * 0.2 + (i - 1) * fontSize * 3.5 + (j - 1) * fontSize,
                           windowWidth, "left")
    end
  end
  
  -- draw the back instructions
  love.graphics.setColor(255, 255, 255)
  myPicture.Draw(myPicture.backArrow.src, windowWidth*0.01, windowHeight*0.01, 32/myPicture.backArrow.w, 32/myPicture.backArrow.h)
  love.graphics.setFont(itemFonts.credits2)
  love.graphics.print("Esc ", windowWidth*0.06, windowHeight*0.01)
  
end

return Credits