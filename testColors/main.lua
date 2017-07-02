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
  listColors[2].color = {42, 96, 153} -- blue
  listColors[6].color = {255, 255, 0} -- yellow
  listColors[4].color = {0, 169, 51} -- green
  listColors[8].color = {255, 128, 0} -- orange
  listColors[12].color = {128, 0, 128} -- purple
  listColors[3].color = {21, 132, 102} -- teal
  listColors[7].color = {255, 191, 0} -- amber
  listColors[5].color = {129, 212, 26} -- chartreuse
  listColors[9].color = {255, 64, 0} -- vermilion
  listColors[1].color = {85, 48, 141} -- violet
  listColors[11].color = {191, 0, 65} -- cinnabar

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