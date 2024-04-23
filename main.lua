-- Base love functions
graphics = love.graphics
window = love.window
event = love.event

function love.load()
  -- Prepare some of the bird's features
    birdX, birdY, birdW, birdH = 50, 20, 20, 20
    
    -- Gravity starts at a measly 1 pixel per second
    gravity = 1
    
    -- Variables to replicate the "tween" effect the bird does when it flaps
    flapped = false
    flapTimer = 0
    
    -- Other variables
    pipes = {}
    pipeWidth = 70
    pipeGap = 150
    pipeSpeed = 160
end


function love.update(dt)
    birdY = birdY + gravity
    if flapped == false then
    gravity = gravity + 0.5
  end
  if flapTimer > 0 then 
    flapped = true
    flapTimer = flapTimer - 1 
  else
    flapped = false 
  end
  if birdY > (graphics.getHeight() - birdH) or birdY < 0  then -- if the box has hit the top or the bottom
        window.requestAttention()
        window.showMessageBox("Fail","Sorry you're dead")
        event.quit()
    end
    -- Make the pipes move
  for i, pipe in ipairs(pipes) do
        pipe.x = pipe.x - pipeSpeed * dt

      -- If the pipe isn't on the window then off with it
      if pipe.x + pipeWidth < 0 then
          table.remove(pipes, i)
      end
      -- If our bird hits the pipes then end the game
      if birdX >= (pipe.x + birdW) and birdY >= (pipe.y + pipeGap + birdH) then
        window.requestAttention()
        window.showMessageBox("Fail","Sorry you're dead")
        event.quit()
      end
  end

    -- Used GPT for this part as I wasn't really sure on the exact measures
  if #pipes < 1 or graphics.getWidth() - (pipes[#pipes].x + pipeWidth) > 200 then
      local pipePosition = math.random(graphics.getHeight()/ 4, graphics.getHeight() - pipeGap - graphics.getHeight() / 4)
      table.insert(pipes, {x = graphics.getWidth(), y = pipePosition})
  end
end

function love.mousepressed()
   flapTimer = 5
   gravity = 1
   birdY = birdY - 50 
end

function love.draw()
  -- Draw our little birdy :D
    graphics.setColor(0.8, 0.8, 0)
    birdie = graphics.rectangle("fill", birdX, birdY, birdW, birdH)
    
  -- Draw the evil pipes :(
    graphics.setColor(0.4, 0.9, 0.3)
    for _, pipe in ipairs(pipes) do
        graphics.rectangle('fill', pipe.x, 0, pipeWidth, pipe.y)
        graphics.rectangle('fill', pipe.x, pipe.y + pipeGap, pipeWidth, graphics.getHeight())
    end
end

window.setTitle("Flappy Brick")
