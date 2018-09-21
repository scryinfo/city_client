---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/17 11:18
---
local lu = require "Framework/pbl/luaunit"
local assert_not = lu.assertEvalToFalse
local eq       = lu.assertEquals
local table_eq = lu.assertItemsEquals
local fail     = lu.assertErrorMsgContains
local log = log

UnitTest("abel_w4", "test_ipairs",  function ()
    local tb = {"oh", [3] = "god", "my", [5] = "hello", [6] = "world"}
    for k,v in ipairs(tb) do
        log("abl_w5", tostring("[test_ipairs] for in  ipairs: "),k, v)
    end
end)

UnitTest("abel_w4", "test_pairs",  function ()
    local tb = {"oh", [3] = "god", "my", [5] = "hello", [6] = "world"}
    for k,v in pairs(tb) do
        log("abl_w5", tostring("[test_pairs] for in  pairs: "),k, v)
    end
end)

UnitTest("abel_w4", "test_len",  function ()
    local tb = {"oh", [3] = "god", "my", [5] = "hello", [6] = "world"}
    log("abel_w4",tostring("[examination] test_len: #tb "..#tb))
end)

--[[
1、 table.sort是排序函数，它要求要排序的目标table的必须是从1到n连续的，即中间不能有nil。
2、 当比较函数没有写的时候，table.sort默认按照lua里面的排序规则升序排序；当额外写了比较函数时，
    相当于用你额外写的比较函数重载了lua中自带的“<”操作符。这就有一个特别要注意的问题，
    当两个数相等的时候，比较函数一定要返回false！
]]--
UnitTest("abel_w4", "test_table_sort",  function ()
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
            return true--这里是不对的
        end
    end )
end)

--逻辑操作符---Lua: and,or,not 对比 C++：&&，||，!
--https://www.cnblogs.com/pixs-union/p/4852731.html
--[[
采用短路求值（short-circuit evaluation）的策略。
即：逻辑与和逻辑或操作符都是先求左侧运算对象的值再求右侧运算对象的值，
当且仅当左侧运算对象无法确定表达式的结果时才会计算右侧运算对象的值。
]]--

--[[
and连接多个操作数时，表达式的返回值就是从左到右第一个为假的值，若所有操作数值都不为假，则表达式的返回值为最后一个操作数；
]]--
UnitTest("abel_w4", "test_and",  function ()
    log("abel_w4","[test_and] 'a' and 'b' and 'c' and 'd' and nil and false and 'e' and 'f' = ",'a' and 'b' and 'c' and 'd' and nil and false and 'e' and 'f')
    log("abel_w4","[test_and] 'a' and 'b' and 'c' and false and 'd' and nil and 'e' and 'f' =",'a' and 'b' and 'c' and false and 'd' and nil and 'e' and 'f')
    log("abel_w4","[test_and] 0 and 'b' and 'c' and nil = ",0 and 'b' and 'c' and nil)
    log("abel_w4","[test_and] 'b' and 0 and 'c' = ",'b' and 0 and 'c')
    log("abel_w4","[test_and] ","[test] test_and end")
    --nil
    --false
    --nil
    --c
end)

--[[
or连接多个操作数时，表达式的返回值就是从左到右第一个不为假的值，若所有操作数值都为假，则表达式的返回值为最后一个操作数；
]]--
UnitTest("abel_w4", "test_or",  function ()
    log("abel_w4","[test_or]  测试开始: ")
    --[[
    Lua中所有的逻辑运算符将false和nil视为假，其他任何东西视为真，0也视为真。
    ]]--
    local ret = 0 or 1
    ret = 1 or 0
    ret = 0 and 1
    ret = 1 and 0
    log("abel_w4","[test_or] " ,"0 or 1: ",0 or 1)
    log("abel_w4","[test_or] " ,"1 or 0: ",1 or 0)
    log("abel_w4","[test_or] " ,"0 and 1: ",0 and 1)
    log("abel_w4","[test_or] " ,"1 and 0: ",1 and 0)

    log("abel_w4","[test_or] nil or 'a' or 'b' or 'c' or 'd'   or false or 'e' or 'f' = " ,nil or 'a' or 'b' or 'c' or 'd'   or false or 'e' or 'f')
    log("abel_w4","[test_or] false or 'b' or nil or 'c' or false or 'd'   or 'e' or 'f' =" ,false or 'b' or nil or 'c' or false or 'd'   or 'e' or 'f')
    log("abel_w4","[test_or] 'a' or nil or 'b' or 'c' or false or 'd'   or 'e' or 'f' = " ,'a' or nil or 'b' or 'c' or false or 'd'   or 'e' or 'f')
    log("abel_w4","[test_or] 'a' or nil or 'b' or 'c' or false or 'd'   or 'e' or 'f' = " ,0 or 'a' or 'b' or 'c' or false or 'd'   or 'e' or 'f')
    log("abel_w4","[test_or] 'a' or nil or 'b' or 'c' or false or 'd'   or 'e' or 'f' = " ,nil or false)
    --a
    --b
    --a
    --false
end)

--https://www.jianshu.com/p/7c25d5624c9e
--Lua中还会用到 "a and b or c ",这类似于C系语言中的表达式 a ? b : c： max = (a > b) and a or b
UnitTest("abel_w4", "test_and_or",  function ()
    log("abel_w4", "[test_and_or]  测试开始: ")
    local a = 666
    local b = 333
    local c = true
    log("abel_w4", "[test_and_or] (a > b) and a or b) = ",(a > b) and a or b)
    log("abel_w4", "[test_and_or] (a < b) and a or b) = ",(a < b) and a or b)
    log("abel_w4", "[test_and_or] (not c) and 'false' or 'true') =",(not c) and 'false' or 'true')
    --output:
    --666
    --333
    --true
end)



