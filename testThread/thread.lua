math.randomseed(os.time()) --initialiser le random


truc = math.random(0, 10)
print("truc", truc)

-- call the channel with the right name
hereItIs = love.thread.getChannel( "test" )


local bidule = nil
--for i = 1, 3 do
  bidule = hereItIs:pop() -- retrieve the message from the channel
  -- once it had been read, the message disapeared
  print("bidule", bidule)
--end

for i = 0, 800, 10 do
  hereItIs:push(i)
end
