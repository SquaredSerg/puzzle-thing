-- game/cell.lua
local utils = require 'utils.utils'
local module = {}

local Cell = utils.make_class()

Cell.width = 50
Cell.height = 50

Cell.color = {{248/255, 40/255, 89/255}, {62/255, 193/255, 247/255}}
Cell.border_color = {{198/255, 0, 39/255}, {12/255, 143/255, 197/255}}
Cell.focused_color = {250/255, 231/255, 96/255}
Cell.focused_border_color = {200/255, 181/255, 46/255}

function Cell:_init(x, y)
  self.x = x
  self.y = y
  self.value = 1
  self.solid = false
  self.focused = false
end

function Cell:draw(x, y)
  x = x or 0
  y = y or 0
  love.graphics.setColor(self.focused and self.focused_border_color or self.border_color[self.value + 1])
  love.graphics.rectangle('fill', self.x+x, self.y+y, self.width, self.height)
  love.graphics.setColor(self.focused and self.focused_color or self.color[self.value + 1])
  love.graphics.rectangle('fill', self.x+1+x, self.y+1+y, self.width-2, self.height-2)
end

function Cell:solid()
  return self.solid
end

function Cell:can_enter()
  return not self.solid and self.value > 0
end

function Cell:enter()
  self.value = self.value - 1
end

function Cell:set_focused(focused)
  self.focused = focused
end

local WallCell = utils.make_class(Cell)
WallCell.color = {0, 0, 0}
WallCell.border_color = {25, 25, 25 }

function WallCell:_init(x, y)
  Cell._init(self, x, y) -- I am a genius
  self.value = 0
  self.solid = true
end

function WallCell:draw(x, y)
  x = x or 0
  y = y or 0
  love.graphics.setColor(self.border_color)
  love.graphics.rectangle('fill', self.x+x, self.y+y, self.width, self.height)
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x+1+x, self.y+1+y, self.width-2, self.height-2)
end

module.Cell = Cell
module.WallCell = WallCell

return module