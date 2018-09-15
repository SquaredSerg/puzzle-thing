-- utils/utils.lua

local module = {}

-- Got from http://lua-users.org/wiki/ObjectOrientationTutorial
module.make_class = function (...)
  -- "cls" is the new class
  local cls, bases = {}, {...}
  -- copy base class contents into the new class
  for i, base in ipairs(bases) do
    for k, v in pairs(base) do
      cls[k] = v
    end
  end
  -- set the class' __index, and start filling an "is_a" table that contains this class and all of its bases
  -- so you can do an "instance of" check using my_instance.is_a[MyClass]
  cls.__index, cls.is_a = cls, {[cls] = true}
  for i, base in ipairs(bases) do
    for c in pairs(base.is_a) do
      cls.is_a[c] = true
    end
    cls.is_a[base] = true
  end

  -- __tostring for debug purposes
  cls.__tostring = function(t)
    s = ''
    for k, v in pairs(t) do
      s = s .. '"' .. tostring(k) .. '": "' .. tostring(v) .. '"\n'
    end
    return s
  end

  -- the class's __call metamethod
  setmetatable(cls, {__call = function (c, ...)
      local instance = setmetatable({}, c)
      -- run the init method if it's there
      local init = instance._init
      if init then init(instance, ...) end
      return instance
    end})
  -- return the new class table, that's ready to fill with methods
  return cls
end

module.file_exists = function(path)
  local info = love.filesystem.getInfo(path)
  return info ~= nil
end

module.deep_lisp = function(table, depth)
  depth = depth or 0
  if type(table) == 'table' then
    local cur = (depth > 0 and '\n' or '') .. string.rep(' ', depth) .. '(\n' 
    for k, v in pairs(table) do 
      cur = cur .. string.rep(' ', depth + 1) .. '[' .. (type(k) == 'string' and ('"' .. k .. '"') or tostring(k)) .. '] = '
      cur = cur .. module.deep_lisp(v, depth + 1) .. ',\n'
    end
    return cur .. string.rep(' ', depth) .. ')' 
  else
    return (type(table) == 'string' and ('"' .. table .. '"') or tostring(table))
  end
end

return module
