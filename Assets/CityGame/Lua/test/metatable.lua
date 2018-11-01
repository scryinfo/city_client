---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/17 16:37
---

UnitTest.TestBlockStart()---------------------------------------------------------

local lu = require "Framework/pbl/luaunit"
local notEq = lu.assertEvalToFalse
local eq       = lu.assertEquals
local table_eq = lu.assertItemsEquals
local fail     = lu.assertErrorMsgContains
local log = log

local parent = {
    house = 1
}

parent.__index = parent    --如果没有这一句话  child即使是设置parent为元表  也不能找到parent中的内容. __index指向的内容是nil（补充：更关键的是，派生类不能做到动态绑定）

--__index 只有两个形参， table 和 key， 这里的第三个参数是nil， 所以只适查找操作，而不适合赋值操作，如果当前表中没有对应key，那么找原表中对应的__index指向的方法或者表进行查找操作
-- __index 应对的是表中key的查找；  __newindex处理得是表中key的赋值
--parent.__index = function ( t, k ,v )
--    -- t[k] = v
--    local ret = 0
--    if k == "house" then
--        parent[k] = 2
--        ret = 123
--    end
--    return ret
--end

--parent.__index = {
--    house = "1111",
--}
local child = {
    wife = 2
}

local returnTb = setmetatable(child, parent) --setmetatable 返回值是传入的参数中第一个表

ct.log("[metatable] setmetatable child"..tostring(child))
ct.log("[metatable] setmetatable parent"..tostring(parent))
ct.log("[metatable] setmetatable returnTb"..tostring(returnTb))

ct.log("[metatable] __index test: child.house"..tostring(child.house))
ct.log("[metatable] __index test: child.wife"..tostring(child.wife))

parent.__newindex = function ( t, k ,v )  --赋值操作，如果当前表中没有对应key，那么找原表中对应的__newindex指向的方法或者表进行赋值操作
    -- t[k] = v
    if k == "house" then
        parent[k] = v * 2
    end
end
-- 等效于
-- parent.__newindex = parent

UnitTest.Exec("abel_w4", "test_metatable__newindex",  function ()
    child.house = 3
    child.wife = 4

    ct.log('abel_w4','[test__newindex] parent.__newindex not nil, child.house',tostring(child.house))
    ct.log('abel_w4','[test__newindex] parent.__newindex not nil, child.wife', tostring(child.wife))

    parent.__index = nil

    child.house = 5
    child.wife = 6
    --assert(child.house,"[metatable] __newindex test: child.house: nil")
    ct.log('abel_w4',"[test__newindex] __newindex test: child.house: ".. tostring(child.house))
    ct.log('abel_w4',"[test__newindex] __newindex test: child.wife: "..tostring(child.wife))

end)


local Parent = {}

function Parent:new()
    local newParent = { house = "white house" }
    self.__index = self
    return setmetatable(newParent, self)
end

function Parent:Wife( )
    ct.log('abel_w4',"mother live in the "..self.house )
end
function Parent:Position()
    ct.log('abel_w4',"Parent live in the "..self.house)
    self:Wife()
end
parent = Parent:new()
parent:Wife()


--通过类似类的方式来继承
Child = Parent:new()
function Child:Position()
    local ChildHouse = self.house
    ct.log('abel_w4',"child live in the "..ChildHouse)
    self:Wife()
end

--通过类似类的方式来继承
Child1 = Parent:new()
function Child1:Position()
    local ChildHouse = self.house
    ct.log('abel_w4',"Child1 live in the "..ChildHouse)
    self:Wife()
end

UnitTest.Exec("abel_w4", "test_metatable_DynamicBind",  function ()
    child = Child:new()
    child1 = Child1:new()

    child:Position()

    local testArray = {}
    testArray[0] = child
    testArray[1] = child1
    for k,v in pairs(testArray)  do
        v:Position()
    end
end)

-- lua中检查某值得顺序：比如child 的house 属性。  先到Child中去检查有没有某个字段。就会去检索__index这个元方法。
-- 即当需要访问一个字段在table中不存在的时候，解释器会去查找一个叫__index的元方法，如果没有该元方法，那么访问结果就是nil,不然就由这个元方法来提供最终结果。
UnitTest.Exec("abel_w4", "test_metatable__index",  function ()
    test1 = { param1 = 1}
    test2 = { param2 = 2}
    test3 = { param3 = 3}

    -- test2.__index = test1  等价于:
    test2.__index = function(testTable , key)
        ct.log("abel_w4",testTable)
        ct.log("abel_w4",test3)
        ct.log("abel_w4",key)
        ct.log("abel_w4",test1[key])
        return test1[key]
    end
    setmetatable(test3 , test2)

    ct.log("abel_w4","test3.param1: "..tostring(test3.param1))
    ct.log("abel_w4","test3.param2: "..tostring(test3.param2))
    ct.log("abel_w4","test3.param3: "..tostring(test3.param3))

    -- 这里的__index赋值就相当于  test2.__index = test1

    --注释部分打印得出的结果是:
    -- table: 0x7fe038c05440
    -- table: 0x7fe038c05440
    -- param1
    -- 1
    -- nil
    -- table: 0x7fe038c05440
    -- table: 0x7fe038c05440
    -- param2
    -- nil
    -- nil
    -- 3
end)

--testTable的地址和test3的地址相同 ,由此可知，__index这种元方法会有一个默认形参是该表本身。而这里setmetatable只是给表设置了元表，
--真正查询字段的是根据元表中__index元方法所指向的表中的字段。而不是元表中的字段。

UnitTest.TestBlockEnd()-----------------------------------------------------------
