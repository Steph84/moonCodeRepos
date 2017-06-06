local Game = {}

local windowWidth, windowHeight
local sizeFonts = {}
sizeFonts.fontSize = 32

local myScenario = require("scenario")
local myEpisodeOne = require("episodeOne")

function Game.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  Game.gameState = "scenario"
  
  myScenario.Load(windowWidth, windowHeight, sizeFonts.fontSize)
  myEpisodeOne.Load(windowWidth, windowHeight)
  
end

function Game.Update(dt)
  if Game.gameState == "scenario" then Game.gameState = myScenario.Update(dt, Game.gameState) end
  if Game.gameState == "episodeOne" then Game.gameState = myEpisodeOne.Update(dt, Game.gameState) end
end

function Game.Draw()
  if Game.gameState == "scenario" then myScenario.Draw() end
  if Game.gameState == "episodeOne" then myEpisodeOne.Draw() end
end

return Game