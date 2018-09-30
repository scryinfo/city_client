local class = require 'Framework/class'
testtime = require 'test/performance/testTime'

--简单类的实现---------------------------{
ClassSimple = {
  _VERSION     = 'class v4.1.1',
  _DESCRIPTION = 'Object Orientation for Lua',
  _URL         = 'https://github.com/kikito/class',
  _LICENSE     = [[
    MIT LICENSE

    Copyright (c) 2011 Enrique García Cota

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]]
};

function ClassSimple:New( me )
  me = me or {};
  setmetatable(me, self);
  self.__index = self;
  return me;
end


--简单类的实现---------------------------}

UnitTest.Exec("abel_w4_class_performance", "test_class_creation",  function ()
  UnitTest.PerformanceTest("abel_w4_class_performance","[class creation]", function()
    for i = 1, 100000 do
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
    for i = 1, 10000000 do
      local a = A:new()
    end
  end)

  UnitTest.PerformanceTest("abel_w4_class_performance","[simple class instance creation]", function()
    for i = 1, 10000000 do
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

local a = A:new()
local sClass =  ClassSimple:New()
UnitTest.Exec("abel_w4_class_performance", "test_instance_method_invocation",  function ()
  UnitTest.PerformanceTest("abel_w4_class_performance","[instance method invocation", function()
    for i = 1, 10000000 do
      a:foo()
    end
  end)
  UnitTest.PerformanceTest("abel_w4_class_performance","[simple class instance method invocation", function()
    for i = 1, 10000000 do
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
    for i = 1, 10000000 do --10000000
      b:foo()
    end
  end)
  UnitTest.PerformanceTest("abel_w4_class_performance",'simple class inherited method invocation', function()
    for i = 1, 10000000 do
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
    for i = 1, 100000 do
      A:bar()
    end
  end)
end)

UnitTest.Exec("abel_w4_class_performance", "test_inherited_class_method_invocation",  function ()
  UnitTest.PerformanceTest("abel_w4_class_performance",'inherited class method invocation', function()
    for i = 1, 100000 do
      B:bar()
    end
  end)
end)

