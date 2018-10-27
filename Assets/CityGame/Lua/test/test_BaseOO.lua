---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/8/20 18:08
---

local lu = require "Framework/pbl/luaunit"
local assert_not = lu.assertEvalToFalse
local eq       = lu.assertEquals
local table_eq = lu.assertItemsEquals
local fail     = lu.assertErrorMsgContains



Person = class('Person') --this is the same as class('Person', Object) or Object:subclass('Person') 没有基类的类，默认基类是Object，不需要写而已
function Person:initialize(name)
    self.name = name
end
function Person:speak()
    logDebug('Hi, I am ' .. self.name ..'.')
end

AgedPerson = class('AgedPerson', Person) -- or Person:subclass('AgedPerson') 派生新的类
AgedPerson.static.ADULT_AGE = 18 --this is a class variable 支持类的静态成员变量
function AgedPerson:initialize(name, age)
    Person.initialize(self, name) -- this calls the parent's constructor (Person.initialize) on self 这里相当于super方法的调用 ，把自己作为参数传递给基类的方法，复用基类的 speak
    self.age = age
    Event.AddListener("class_cb", self.class_cb,self);
end
function AgedPerson:initialize(name, age, testoverload)
    local test = testoverload
    Person.initialize(self, name) -- this calls the parent's constructor (Person.initialize) on self 这里相当于super方法的调用 ，把自己作为参数传递给基类的方法，复用基类的 speak
    self.age = age
    Event.AddListener("class_cb", self.class_cb,self);
end
function AgedPerson:class_cb(newAge)
    self.age = age
end
function AgedPerson:speak()
    Person.speak(self) -- prints "Hi, I am xx."
    if(self.age < AgedPerson.ADULT_AGE) then --accessing a class variable from an instance method 在实例中访问静态成员
        logDebug('I am underaged.')
    else
        logDebug('I am an adult.')
    end
end

UnitTest.Exec("abel_w6_UIFrame", "test_oo",  function ()
    --print("hahaha")
    local xxx = false
    --eq (xxx == true, "true")
    local p0 = Person:new('Man01', 30) --传入的参数会转发到 initialize
    p0:speak()
    local p1 = AgedPerson:new('Billy the Kid', 13) -- this is equivalent to AgedPerson('Billy the Kid', 13) - the :new part is implicit
    local p2 = AgedPerson:new('Luke Skywalker', 21)
    local p3 = AgedPerson:new('Luke Skywalker', 21, true) --重载测试
    p1:speak()
    p2:speak()
    Event.Brocast("class_cb", 100);
end )


