local LoadPictures = {}

function LoadPictures.Load()
  LoadPictures.backArrow = {}
  LoadPictures.backArrow.src = love.graphics.newImage("pictures/backArrow.png")
  LoadPictures.backArrow.w = LoadPictures.backArrow.src:getWidth()
  LoadPictures.backArrow.h = LoadPictures.backArrow.src:getHeight()
  
  LoadPictures.backGround = {}
  LoadPictures.backGround.src = love.graphics.newImage("pictures/backGround.png")
  LoadPictures.backGround.w = LoadPictures.backGround.src:getWidth()
  LoadPictures.backGround.h = LoadPictures.backGround.src:getHeight()
end

function LoadPictures.Draw(pPicture, pX, pY, pScaleX, pScaleY)
  love.graphics.draw(pPicture, pX, pY, 0, pScaleX, pScaleY)
end

return LoadPictures