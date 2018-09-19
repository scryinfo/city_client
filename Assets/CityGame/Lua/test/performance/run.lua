if not CityGlobal.G_PERFORMANCETEST then return {} end

local class = require 'Framework/class'

testtime = require 'test/performance/testTime'

testtime(100000,'class creation', function()
  local A = class('A')
end)

local A = class('A')

testtime(100000,'instance creation', function()
  local a = A:new()
end)

function A:foo()
  return 1
end

local a = A:new()

testtime(100000,'instance method invocation', function()
  a:foo()
end)

local B = class('B', A)

local b = B:new()

testtime(100000,'inherited method invocation', function()
  b:foo()
end)

function A.static:bar()
  return 2
end

testtime(100000,'class method invocation', function()
  A:bar()
end)

testtime(100000,'inherited class method invocation', function()
  B:bar()
end)
