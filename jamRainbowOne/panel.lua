local Panel = {}

Panel.pic = {}
Panel.wid = {}
Panel.hei = {}

function Panel.Load()
  Panel.pic[1] = love.graphics.newImage("pictures/Panel_Red.png")
  Panel.pic[2] = love.graphics.newImage("pictures/Panel_Yellow.png")
  
  Panel.wid[1] = Panel.pic[1]:getWidth()
  Panel.wid[2] = Panel.pic[2]:getWidth()
  
  Panel.hei[1] = Panel.pic[1]:getHeight()
  Panel.hei[2] = Panel.pic[2]:getHeight()

return Panel.wid[1]

end

function Panel.Draw(pWindowWidth, pWindowHeight, pScreenScale)
  love.graphics.draw(Panel.pic[1], 0, pWindowHeight - (Panel.hei[1] * (pScreenScale - 1)), 0, pScreenScale, pScreenScale - 1)
end







return Panel