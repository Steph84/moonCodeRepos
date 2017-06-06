local EpisodeOne = {}

local windowWidth, windowHeight
local myMapE01 = require("mapEOne")

function EpisodeOne.Load(pWindowWidth, pWindowHeight)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  
  myMapE01.Load(windowWidth, windowHeight)
  
  
  
end

function EpisodeOne.Update(dt, pGameState)
  
  return pGameState
end

function EpisodeOne.Draw()
  myMapE01.Draw()
end



return EpisodeOne