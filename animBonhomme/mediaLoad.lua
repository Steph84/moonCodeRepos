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

function drawMenu()
  love.graphics.draw(menuPic, (windowWidth-menuPic:getWidth())/2, 0)
end
