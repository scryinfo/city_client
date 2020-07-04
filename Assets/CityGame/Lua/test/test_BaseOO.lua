---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/8/20 18:08
---

UnitTest.TestBlockStart()---------------------------------------------------------

local lu = require "Framework/pbl/luaunit"
local assert_not = lu.assertEvalToFalse
local eq       = lu.assertEquals
local table_eq = lu.assertItemsEquals
local fail     = lu.assertErrorMsgContains



Person = class('Person') --this is the same as class('Person', Object) or Object:subclass('Person') No base class, the default base class is Object, no need to write
function Person:initialize(name)
    self.name = name
end
function Person:speak()
    logDebug('Hi, I am ' .. self.name ..'.')
end

AgedPerson = class('AgedPerson', Person) -- or Person:subclass('AgedPerson') Derive a new class
AgedPerson.static.ADULT_AGE = 18 --this is a class variable Support static member variables of the class
function AgedPerson:initialize(name, age)
    Person.initialize(self, name) -- this calls the parent's constructor (Person.initialize) on self This is equivalent to calling the super method, passing yourself as a parameter to the method of the base class, reusing the speak of the base class
    self.age = age
    Event.AddListener("class_cb", self.class_cb,self);
end
function AgedPerson:initialize(name, age, testoverload)
    local test = testoverload
    Person.initialize(self, name) -- this calls the parent's constructor (Person.initialize) on self This is equivalent to calling the super method, passing yourself as a parameter to the method of the base class, reusing the speak of the base class
    self.age = age
    Event.AddListener("class_cb", self.class_cb,self);
end
function AgedPerson:class_cb(newAge)
    self.age = age
end
function AgedPerson:speak()
    Person.speak(self) -- prints "Hi, I am xx."
    if(self.age < AgedPerson.ADULT_AGE) then --accessing a class variable from an instance method Access static members in an instance
        logDebug('I am underaged.')
    else
        logDebug('I am an adult.')
    end
end

UnitTest.Exec("abel_w6_UIFrame", "test_oo",  function ()
    --print("hahaha")
    local xxx = false
    --eq (xxx == true, "true")
    local p0 = Person:new('Man01', 30) --The incoming parameters will be forwarded to initialize
    p0:speak()
    local p1 = AgedPerson:new('Billy the Kid', 13) -- this is equivalent to AgedPerson('Billy the Kid', 13) - the :new part is implicit
    local p2 = AgedPerson:new('Luke Skywalker', 21)
    local p3 = AgedPerson:new('Luke Skywalker', 21, true) --Overload test
    p1:speak()
    p2:speak()
    Event.Brocast("class_cb", 100);
end )

UnitTest.Exec("abel_w24_deepcopy", "abel_w24_deepcopy",  function ()
    local tb = {}
    tb.root = AgedPerson:new('Luke Skywalker', 21)
    tb.root:speak()
    local tbn = ct.deepCopy(tb)
    tbn.root.age = 1
    tbn.root.name = "haha"
    tbn.root:speak()
    local a = 0
end)

UnitTest.TestBlockEnd()-----------------------------------------------------------
