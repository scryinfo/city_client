
testtime = require 'test/performance/testTime'

UnitTest.TestBlockStart()
--简单类的实现---------------------------{
ClassSimple = {
  _VERSION     = 'class v4.1.1',
  _DESCRIPTION = 'Object Orientation for Lua',
  _URL         = 'https://github.com/kikito/class',
  _LICENSE     = [[
  ]]
};

function ClassSimple:New( me )
  me = me or {};
  setmetatable(me, self);
  self.__index = self;
  return me;
end


--简单类的实现---------------------------}
local testcount = 100000

UnitTest.Exec("abel_w4_class_performance", "test_class_creation",  function ()
  UnitTest.PerformanceTest("abel_w4_class_performance","[class creation]", function()
    for i = 1, testcount do
      local pClass = class('A')
    end
  end)
end)

local A = class('A')
--[[
[instance creation]    执行时间:            0.0029999999999291
[simple instance creation]    执行时间:     0.0049999999999955
]]--
UnitTest.Exec("abel_w4_class_performance", "test_instance_creation",  function ()
  UnitTest.PerformanceTest("abel_w4_class_performance","[instance creation]", function()
    for i = 1, testcount do
      local a = A:new()
    end
  end)

  UnitTest.PerformanceTest("abel_w4_class_performance","[simple class instance creation]", function()
    for i = 1, testcount do
      local simpleClass = ClassSimple:New();
    end
  end)
end)

function A:foo()
  return 1
end

function ClassSimple:foo( )
  return 1
end

local testcount1 = 1000000000
local a = A:new()
local sClass =  ClassSimple:New()
UnitTest.Exec("abel_w4_class_performance", "test_instance_method_invocation",  function ()
  UnitTest.PerformanceTest("abel_w4_class_performance","[instance method invocation", function()
    for i = 1, testcount1 do
      a:foo()
    end
  end)
  UnitTest.PerformanceTest("abel_w4_class_performance","[simple class instance method invocation", function()
    for i = 1, testcount1 do
      sClass:foo()
    end
  end)
end)

local B = class('B', A)
local b = B:new()

--简单类的继承
SimpleSubClass = {};
SimpleSubClass = ClassSimple:New(SimpleSubClass);
local pSimpleSubClass = SimpleSubClass:New()
--[[
--继承方法的调用效率 class 不如 simple class
inherited method invocation    执行时间:     0.0030000000000001
simple class inherited method invocation    执行时间:     0.0019999999999989
]]--
UnitTest.Exec("abel_w4_class_performance", "test_inherited_method_invocation",  function ()
  UnitTest.PerformanceTest("abel_w4_class_performance",'inherited method invocation', function()
    for i = 1, testcount1 do --10000000
      b:foo()
    end
  end)
  UnitTest.PerformanceTest("abel_w4_class_performance",'simple class inherited method invocation', function()
    for i = 1, testcount1 do
      pSimpleSubClass:foo()
    end
  end)
end)

function A.static:bar()
  return 2
end
--调用派生类自己的方法（包括混入的方法）比调用从基类继承而来的方法要快30%
UnitTest.Exec("abel_w4_class_performance", "test_class_method_invocation",  function ()
  UnitTest.PerformanceTest("abel_w4_class_performance",'class method invocation', function()
    for i = 1, testcount1 do
      A:bar()
    end
  end)
end)

UnitTest.Exec("abel_w4_class_performance", "test_inherited_class_method_invocation",  function ()
  UnitTest.PerformanceTest("abel_w4_class_performance",'inherited class method invocation', function()
    for i = 1, testcount1 do
      B:bar()
    end
  end)
end)

UnitTest.TestBlockEnd()