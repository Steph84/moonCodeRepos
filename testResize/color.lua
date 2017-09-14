local Colors = {}

Colors.RGBData = {
              {255, 0, 0, 255}, -- red
              {192, 0, 64, 255}, -- cinnabar
              {128, 0, 128, 255}, -- purple
              {64, 0, 192, 255}, -- violet
              {0, 0, 255, 255}, -- blue
              {0, 64, 128, 255}, -- teal
              {0, 128, 0, 255}, -- green
              {128, 192, 0, 255}, -- chartreuse
              {255, 255, 0, 255}, -- yellow
              {255, 192, 0, 255}, -- amber
              {255, 128, 0, 255}, -- orange
              {255, 64, 0, 255}, -- vermilion
             }
             
Colors.HSLData = { -- format 255, 255, 255
              {0, 255, 128, 255}, -- red
              {241, 255, 96, 255}, -- cinnabar/crimson
              {213, 255, 64, 255}, -- purple
              {184, 255, 96, 255}, -- violet/indigo
              {170, 255, 128, 255}, -- blue
              {149, 255, 64, 255}, -- teal/navy
              {85, 255, 64, 255}, -- green
              {57, 255, 96, 255}, -- chartreuse
              {43, 255, 128, 255}, -- yellow
              {32, 255, 128, 255}, -- amber/gold
              {21, 255, 128, 255}, -- orange
              {11, 255, 128, 255}, -- vermilion/OrangeRed
             }

-- Converts HSL to RGB. (input and output range: 0 - 255)
function Colors.HSL(lValue)
  local h = lValue[1]
  local s = lValue[2] 
  local l = lValue[3]
  local a = lValue[4]
  
	if s <= 0 then return l, l, l, a end
  
	h, s, l = h / 256 * 6, s / 255, l / 255
  
	local c = (1 - math.abs(2 * l - 1)) * s
  
	local x = (1 - math.abs(h % 2 - 1)) * c
  
	local m, r, g, b = (l - 0.5 * c), 0,0,0
  
	if h < 1 then
    r, g, b = c, x, 0
	elseif h < 2 then
    r, g, b = x, c, 0
	elseif h < 3 then
    r, g, b = 0, c, x
	elseif h < 4 then
    r, g, b = 0, x, c
	elseif h < 5 then
    r, g, b = x, 0, c
	else
    r, g, b = c, 0, x
  end
  
  return (r + m) * 255, (g + m) * 255, (b + m) * 255, a
end

return Colors