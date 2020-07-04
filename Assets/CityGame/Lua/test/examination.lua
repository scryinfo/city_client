---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/17 11:18
---
UnitTest.TestBlockStart()---------------------------------------------------------


local lu = require "Framework/pbl/luaunit"
local assert_not = lu.assertEvalToFalse
local eq       = lu.assertEquals
local table_eq = lu.assertItemsEquals
local fail     = lu.assertErrorMsgContains
local log = log

UnitTest.Exec("abel_w4", "test_ipairs",  function ()
    local tb = {"oh", [3] = "god", "my", [5] = "hello", [6] = "world"}
    for k,v in ipairs(tb) do
        ct.log("abl_w5", tostring("[test_ipairs] for in  ipairs: "),k, v)
    end
end)

UnitTest.Exec("abel_w4", "test_pairs",  function ()
    local tb = {"oh", [3] = "god", "my", [5] = "hello", [6] = "world"}
    for k,v in pairs(tb) do
        ct.log("abl_w5", tostring("[test_pairs] for in  pairs: "),k, v)
    end
end)

UnitTest.Exec("abel_w4", "test_len",  function ()
    local tb = {"oh", [3] = "god", "my", [5] = "hello", [6] = "world"}
    ct.log("abel_w4",tostring("[examination] test_len: #tb "..#tb))
end)

--[[
1. table.sort is a sorting function, which requires that the target table to be sorted must be continuous from 1 to n, that is, there cannot be nil in the middle.
2. When the comparison function is not written, table.sort defaults to sorting in ascending order in lua; when the comparison function is additionally written,
    This is equivalent to overloading the "<" operator that comes with Lua with the comparison function you wrote. There is a special issue that needs attention.
    When the two numbers are equal, the comparison function must return false!
]]--
UnitTest.Exec("abel_w4", "test_table_sort",  function ()
    local a = 5
    local b = 5
    local c = 5
    local d = {a, b, c}
    --table.sort( d,function(a,b) return a>=b end )
    table.sort(d,function(first,second)
        if first < second then
            return true
        elseif first > second then
            return false
        else
            return true
        end
    end )
end)

--Logical operators --- Lua: and, or, not vs. C++: &&, ||,!
--https://www.cnblogs.com/pixs-union/p/4852731.html
--[[
Use short-circuit evaluation (short-circuit evaluation) strategy.
That is: the logical AND and logical OR operators are to first calculate the value of the left operation object and then the value of the right operation object,
The value of the right operation object is calculated if and only if the left operation object cannot determine the result of the expression.
]]--

--[[
and connect multiple operands, the return value of the expression is the first value from left to right is false, if all operand values ​​are not false, the return value of the expression is the last operand;
]]--
UnitTest.Exec("abel_w4", "test_and",  function ()
    ct.log("abel_w4","[test_and] 'a' and 'b' and 'c' and 'd' and nil and false and 'e' and 'f' = ",'a' and 'b' and 'c' and 'd' and nil and false and 'e' and 'f')
    ct.log("abel_w4","[test_and] 'a' and 'b' and 'c' and false and 'd' and nil and 'e' and 'f' =",'a' and 'b' and 'c' and false and 'd' and nil and 'e' and 'f')
    ct.log("abel_w4","[test_and] 0 and 'b' and 'c' and nil = ",0 and 'b' and 'c' and nil)
    ct.log("abel_w4","[test_and] 'b' and 0 and 'c' = ",'b' and 0 and 'c')
    ct.log("abel_w4","[test_and] ","[test] test_and end")
    --nil
    --false
    --nil
    --c
end)

--[[
or When connecting multiple operands, the return value of the expression is the first value from left to right that is not false. If all operand values ​​are false, the return value of the expression is the last operand;
]]--
UnitTest.Exec("abel_w4", "test_or",  function ()
    ct.log("abel_w4","[test_or]  测试开始: ")
    --[[
    Lua中所有的逻辑运算符将false和nil视为假，其他任何东西视为真，0也视为真。
    ]]--
    local ret = 0 or 1
    ret = 1 or 0
    ret = 0 and 1
    ret = 1 and 0
    ct.log("abel_w4","[test_or] " ,"0 or 1: ",0 or 1)
    ct.log("abel_w4","[test_or] " ,"1 or 0: ",1 or 0)
    ct.log("abel_w4","[test_or] " ,"0 and 1: ",0 and 1)
    ct.log("abel_w4","[test_or] " ,"1 and 0: ",1 and 0)

    ct.log("abel_w4","[test_or] nil or 'a' or 'b' or 'c' or 'd'   or false or 'e' or 'f' = " ,nil or 'a' or 'b' or 'c' or 'd'   or false or 'e' or 'f')
    ct.log("abel_w4","[test_or] false or 'b' or nil or 'c' or false or 'd'   or 'e' or 'f' =" ,false or 'b' or nil or 'c' or false or 'd'   or 'e' or 'f')
    ct.log("abel_w4","[test_or] 'a' or nil or 'b' or 'c' or false or 'd'   or 'e' or 'f' = " ,'a' or nil or 'b' or 'c' or false or 'd'   or 'e' or 'f')
    ct.log("abel_w4","[test_or] 'a' or nil or 'b' or 'c' or false or 'd'   or 'e' or 'f' = " ,0 or 'a' or 'b' or 'c' or false or 'd'   or 'e' or 'f')
    ct.log("abel_w4","[test_or] 'a' or nil or 'b' or 'c' or false or 'd'   or 'e' or 'f' = " ,nil or false)
    --a
    --b
    --a
    --false
end)

--https://www.jianshu.com/p/7c25d5624c9e
--"A and b or c "is also used in Lua, which is similar to the expression in the C language a ? b : c： max = (a > b) and a or b
UnitTest.Exec("abel_w4", "test_and_or",  function ()
    ct.log("abel_w4", "[test_and_or]  测试开始: ")
    local a = 666
    local b = 333
    local c = true
    ct.log("abel_w4", "[test_and_or] ((a > b) and a or b) = ",(a > b) and a or b)
    ct.log("abel_w4", "[test_and_or] ((a < b) and a or b) = ",(a < b) and a or b)
    ct.log("abel_w4", "[test_and_or] ((not c) and 'false' or 'true') =",(not c) and 'false' or 'true')
    --output:
    --666
    --333
    --true
end)




UnitTest.TestBlockEnd()-----------------------------------------------------------
