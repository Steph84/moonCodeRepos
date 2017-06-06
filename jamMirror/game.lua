local Game = {}

local windowWidth, windowHeight
local sizeFonts = {}
sizeFonts.fontSize = 32

local myScenario = require("scenario")

function Game.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  Game.gameState = "scenario"
  
  myScenario.Load(windowWidth, windowHeight, sizeFonts.fontSize)
  
end

function Game.Update(dt)
  
  if Game.gameState == "scenario" then Game.gameState = myScenario.Update(dt, Game.gameState) end
  if Game.gameState == "episodeOne" then
    
  end
end

function Game.Draw()
  if Game.gameState == "scenario" then myScenario.Draw() end
  if Game.gameState == "episodeOne" then
    
  end
end

return Game