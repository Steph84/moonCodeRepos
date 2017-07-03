io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local windowWidth = 800 -- default value
local windowHeight = 600 -- default value

local listColors = {}

function love.load()
  love.window.setMode(windowWidth, windowHeight)
  love.window.setTitle("my Title")
  
  local rayon = windowWidth/4
  
  local i
  for i = 1, 12 do
    local item = {}
    item.id = i
    item.x = windowWidth/2 + rayon * math.cos((i-1) * (math.pi * 2)/12)
    item.y = windowHeight/2 + rayon * math.sin((i-1) * (math.pi * 2)/12)
    item.diam = 64
    item.color = {255, 255, 255}
    table.insert(listColors, item)
  end
  
  listColors[10].color = {255, 0, 0} -- red
  listColors[9].color = {255, 64, 0} -- vermilion
  listColors[8].color = {255, 128, 0} -- orange
  listColors[7].color = {255, 192, 0} -- amber
  listColors[6].color = {255, 255, 0} -- yellow
  
  listColors[11].color = {192, 0, 64} -- cinnabar
  listColors[12].color = {128, 0, 128} -- purple
  listColors[1].color = {64, 0, 192} -- violet
  listColors[2].color = {0, 0, 255} -- blue
  
  listColors[3].color = {0, 128, 128} -- teal
  listColors[4].color = {0, 255, 0} -- green
  listColors[5].color = {128, 255, 0} -- chartreuse
  
end

function love.update(dt)

end

function love.draw()
  local i
  for i = 1, #listColors do
    local c = listColors[i]
    love.graphics.setColor(c.color)
    love.graphics.circle("fill", c.x, c.y, c.diam)
    
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(i, c.x + 16, c.y + 16)
  end
end