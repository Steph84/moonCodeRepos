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
    item.x = windowWidth/2 + rayon * math.cos((i-1) * (math.pi * 2)/12 - math.pi/2)
    item.y = windowHeight/2 + rayon * math.sin((i-1) * (math.pi * 2)/12 - math.pi/2)
    item.rayon = 64
    item.color = {255, 255, 255}
    table.insert(listColors, item)
  end
  
  listColors[1].color = {255, 0, 0} -- red
  listColors[12].color = {255, 64, 0} -- vermilion
  listColors[11].color = {255, 128, 0} -- orange
  listColors[10].color = {255, 192, 0} -- amber
  listColors[9].color = {255, 255, 0} -- yellow
  
  listColors[2].color = {192, 0, 64} -- cinnabar
  listColors[3].color = {128, 0, 128} -- purple
  listColors[4].color = {64, 0, 192} -- violet
  listColors[5].color = {0, 0, 255} -- blue
  
  listColors[6].color = {0, 64, 128} -- teal
  listColors[7].color = {0, 128, 0} -- green
  listColors[8].color = {128, 192, 0} -- chartreuse
  
  
  
  listColors[1].name = "red"
  listColors[12].name = "vermilion"
  listColors[11].name = "orange"
  listColors[10].name = "amber"
  listColors[9].name = "yellow"
  
  listColors[2].name = "cinnabar"
  listColors[3].name = "purple"
  listColors[4].name = "violet"
  listColors[5].name = "blue"
  
  listColors[6].name = "teal"
  listColors[7].name = "green"
  listColors[8].name = "chartreuse"
  
end

function love.update(dt)

end

function love.draw()
  local i
  for i = 1, #listColors do
    local c = listColors[i]
    love.graphics.setColor(c.color)
    love.graphics.circle("fill", c.x, c.y, c.rayon)
  end
  for i = 1, #listColors do
    local c = listColors[i]
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(i, c.x - c.rayon, c.y - 24, c.rayon * 2, "center")
    love.graphics.printf(c.color[1].."."..c.color[2].."."..c.color[3], c.x - c.rayon, c.y, c.rayon * 2, "center")
    love.graphics.printf(c.name, c.x - c.rayon, c.y + 16, c.rayon * 2, "center")
  end
end