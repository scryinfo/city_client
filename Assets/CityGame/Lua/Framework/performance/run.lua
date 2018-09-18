local class = require 'class'

testtime = require 'performance/time'

testtime(1,'class creation', function()
  local A = class('A')
end)

local A = class('A')

testtime(1,'instance creation', function()
  local a = A:new()
end)

function A:foo()
  return 1
end

local a = A:new()

testtime(1,'instance method invocation', function()
  a:foo()
end)

local B = class('B', A)

local b = B:new()

testtime(1,'inherited method invocation', function()
  b:foo()
end)

function A.static:bar()
  return 2
end

testtime(1,'class method invocation', function()
  A:bar()
end)

testtime(1,'inherited class method invocation', function()
  B:bar()
end)
