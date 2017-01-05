io.stdout:setvbuf('no')

if arg[#arg] == "-debug" then require("mobdebug").start() end

local myThread
local mySecondThread

function love.load()
  -- create threads with the same lua file
  myThread = love.thread.newThread( "thread.lua" )
  mySecondThread = love.thread.newThread( "thread.lua" )
  
  -- create channel with a name to be called in the thread easily
  myChannel = love.thread.getChannel("test")

  -- send a message via this channel
  myChannel:push("hello")
  
  -- start a thread with its channel
  -- myThread:start(myChannel)
  -- the channel name is not necessary
  myThread:start() -- arguments are used to send into the thread
  love.timer.sleep(1) -- tempo for the random seed
  mySecondThread:start()

end

function love.update(dt)

end

function love.draw()
    
end

function love.keypressed(key)
  
  print(key)
  
end