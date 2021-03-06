package.path = package.path .. ';src/?.lua' -- To skip src folder when including
io.stdout:setvbuf("no") -- To get print statements to work properly

-- All requires here

require 'utils.extension'

local love = love
local game, input

function love.load(arg)
  local fps = false
  for k, v in ipairs(arg) do
    if v == "-debug" then
      require("mobdebug").start()
    elseif v == "-showfps" then
      fps = true
    end
  end
  
  game  = require 'game.game'
  input = require 'input.input'
  
  game.show_fps = fps
  
  love.mouse.setVisible(false)
  love.window.setTitle "Puzzle thing"
  love.keyboard.setKeyRepeat(true)
  game:init()
end

function love.update(dt)
  input:update(dt)
  game:update(dt)
  input:clear(dt)
end

function love.draw()
  game:draw()
end

function love.keypressed(key, scancode, isrepeat)
  input:keyboard_button(scancode, true)
end

function love.keyreleased(key, scancode)
  input:keyboard_button(scancode, false)
end

function love.textinput(text)
  input:add_text_input(text)
end

function love.mousepressed(x, y, button, istouch)
  if button >=1 and button <= 3 then
    input:mouse_button(button, x, y, true)
  end
end

function love.mousereleased(x, y, button, istouch)
  if button >=1 and button <= 3 then
    input:mouse_button(button, x, y, false)
  end
end

function love.wheelmoved(x, y)
    input:mouse_update_scroll(x, y)
end

function love.focus(focus)
  -- TODO
end

function love.mousefocus(focus)
  -- TODO?
end

function love.conf(t)
  t.console = true -- Remove later
end

function love.resize(w, h)
  -- TODO?
end

-- function love.errhand(msg)
  -- TODO
-- end

function love.quit()
  -- TODO
end