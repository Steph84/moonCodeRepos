-- allow to play the background music
function backgroundMusic()
  bgm = love.audio.newSource("musics/dkTheme.mp3", "stream")
  bgm:setLooping(true)
  bgm:setVolume(0.25)
  bgm:play()
end

function updateMenu()
  
end

function updateBody()
  
end


