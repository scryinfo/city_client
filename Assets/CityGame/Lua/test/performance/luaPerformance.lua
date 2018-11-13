---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/18 18:22
---

UnitTest.TestBlockStart()---------------------------------------------------------

testtime = require 'test/performance/testTime'

--[[
 如果我们明确table中的数据全部存放在线性数组中, ipairs 比 ,pairs 快一倍； 但是 ipairs时中间不能出现nil值,
 否则会导致遍历中断), 如果我们明确遍历hash表中的值, 则使用pairs
]]--
local tb = {[1] ='oh', [2] = 'god', [3]='my', [5] = 'hello', [4] = 'world'}
UnitTest.Exec("abel_w4_performance", "test_ipairs_pairs",  function ()
    UnitTest.PerformanceTest("abel_w4_performance","[使用 ipairs 迭代器遍历", function()
        for i = 1, 1000000 do
            for k,v in ipairs(tb) do
                v = 1
            end
        end
    end)

    UnitTest.PerformanceTest("abel_w4_performance","[使用 pairs 迭代器遍历", function()
        for i = 1, 1000000 do
            for k,v in pairs(tb) do
                v = 1
            end
        end
    end)

    UnitTest.PerformanceTest("abel_w4_performance","[使用 tb[i] 迭代器遍历", function()
        for i = 1, 1000000 do
            for i = 1, #tb do
                tb[i] = 1
            end
        end
    end)
end)

local testValue = 0
UnitTest.Exec("abel_w4_performance", "test_local_performance",  function ()
    local sin = math.sin  --local reference to math.sin
    UnitTest.PerformanceTest("abel_w4_performance","[使用 local 变量缓存全局数据]", function()
        for i = 1, 1000000 do
            testValue = testValue + sin(i)
        end
    end)

    testValue = 0
    UnitTest.PerformanceTest("abel_w4_performance","[直接使用全局数据]", function()
        for i = 1, 1000000 do
            testValue = testValue + math.sin(i)
        end
    end)

end)

local func1 = function(a,b,func)
    return func(a+b)
end

--[[
    在使用 local 缓存函数，性能有巨大提升， 提升 21.70 倍！
    执行时间:     0.49900000000002
    执行时间:     0.0029999999999291
]]--
UnitTest.Exec("abel_w4_performance", "test_funcAsParam",  function ()
    UnitTest.PerformanceTest("abel_w4_performance","[函数直接作为参数传递]", function()
        for i = 1, 10000000 do
            func1( 1, 2, function(a) return a*2 end )
        end
    end)

    local func2 = function( c )
        return c*2
    end

    UnitTest.PerformanceTest("abel_w4_performance","[函数的local变量作为参数传递]", function()
        for i = 1, 10000000 do
            func1( 1, 2, func2 )
        end
    end)
end)

local a = {}
local table_insert = table.insert
local testcount = 1000000
--[[
table_insert 的效率非常之低，慎用！
[使用 table insert 扩充数组]    执行时间:     1.5029999999988
[使用 loop counter 扩充数组]    执行时间:     0.0059999999994034
[使用 table size 扩充数组]    执行时间:     0.10900000000038
]]--
UnitTest.Exec("abel_w4_performance", "test_use_table_insert",  function ()
    UnitTest.PerformanceTest("abel_w4_performance","[使用 table insert 扩充数组]", function()
        for i = 1, testcount do
            table_insert( a, i )
        end
    end)
    a = {}
    UnitTest.PerformanceTest("abel_w4_performance","[使用 loop counter 扩充数组]", function()
        for i = 1, testcount do
            a[i] = i
        end
    end)

    a = {}
    UnitTest.PerformanceTest("abel_w4_performance","[使用 table size 扩充数组]", function()
        for i = 1, testcount do
            a[#a+1] = i
        end
    end)

    a = {}
    UnitTest.PerformanceTest("abel_w4_performance","[使用外部计数器扩充数组]", function()
        for i = 1, testcount do
            a[index] = i
            index = index+1
        end
    end)
end)

local tb_unpack = { 100, 200, 300, 400 }
local tb_unpackRet = {}
UnitTest.Exec("abel_w4_performance", "test_use_unpack",  function ()
    UnitTest.PerformanceTest("abel_w4_performance","[使用unpack展开table]", function()
        for i = 1, testcount do
            tb_unpackRet = unpack(tb_unpack)
        end
    end)
    tb_unpackRet = {}
    UnitTest.PerformanceTest("abel_w4_performance","[不使用unpack展开table]", function()
        for i = 1, testcount do
            tb_unpackRet[1] =  tb_unpack[1]
            tb_unpackRet[2] =  tb_unpack[2]
            tb_unpackRet[3] =  tb_unpack[3]
            tb_unpackRet[4] =  tb_unpack[4]
        end
    end)
end)

a = {}
for n = 1,1000 do
    a[n] = {x = n}
end
UnitTest.Exec("abel_w4_performance", "test_cache_table_element",  function ()
    UnitTest.PerformanceTest("abel_w4_performance1","[缓存 table element 1]", function()
        for n = 1,1000 do
            local y = a[n]
            for i = 1,1000 do
                y.x = y.x + 1
            end
        end
    end)

    UnitTest.PerformanceTest("abel_w4_performance","[缓存 table element 2]", function()
        for i = 1,1000 do
            for n = 1,1000 do
                local y = a[n]
                y.x = y.x + 1
            end
        end
    end)

    UnitTest.PerformanceTest("abel_w4_performance","[不缓存 table element 1]", function()
        for n = 1,1000 do
            for i = 1,1000 do
                a[n].x = a[n].x + 1
            end
        end
    end)

    UnitTest.PerformanceTest("abel_w4_performance","[不缓存 table element 2]", function()
        for i = 1,1000 do
            for n = 1,1000 do
                a[n].x = a[n].x + 1
            end
        end
    end)

end)

UnitTest.Exec("abel_w6_performance", "test_UnitTest",  function ()
    UnitTest.PerformanceTest("abel_w6_performance","[单元测试分组 本身执行效率 1000万次调用]", function()
        for i = 1, 10000000 do
            UnitTest.Exec("abel_w6_performance", "test_UnitTest_fun",  function ()

            end)
        end
    end)

    UnitTest.PerformanceTest("abel_w6_performance","[单元测试分组 本身执行效率 100万次调用]", function()
        for i = 1, 1000000 do
            UnitTest.Exec("abel_w6_performance", "test_UnitTest_fun1",  function ()

            end)
        end
    end)

    UnitTest.PerformanceTest("abel_w6_performance","[单元测试分组 本身执行效率 10万次调用]", function()
        for i = 1, 100000 do
            UnitTest.Exec("abel_w6_performance", "test_UnitTest_fun2",  function ()

            end)
        end
    end)

    UnitTest.PerformanceTest("abel_w6_performance","[单元测试分组 本身执行效率 1万次调用]", function()
        for i = 1, 10000 do
            UnitTest.Exec("abel_w6_performance", "test_UnitTest_fun3",  function ()

            end)
        end
    end)
end)

UnitTest.Exec("abel_w11_Comments", "test_w11_Comments",  function ()
    ct.log("abel_w11_Comments","[test_w11_Comments]")
    local funNil = nil
    --funNil("testetasdtet")
    local xxxx = 0
    --local testfun =  function(str)
    --    return str
    --end
    --local logExt = function(infun, ...)
    --    local xxx = 0
    --    local str =  "ct.log(\"abel_w11_Comments\",\""..infun(...).."\")"
    --    local fun = loadstring( str )
    --    if fun then
    --        fun()
    --    end
    --end
    --logExt(function()
    --    if TestGroup.get_TestGroupId("abel_w11_loadstring_log") == nil  then return end
    --    ct.log("abel_w11_loadstring_log","[test_w11_loadstring_log]  ")
    --end )
    --logExt("abel_w11_Comments","[test_w11_Comments] 哈哈哈")
end)

UnitTest.Exec("abel_w11_loadstring_log", "test_w11_loadstring_log",  function ()
    ct.log("abel_w11_loadstring_log","[test_w11_loadstring_log]  ")
    local count = 1000
    local  code  = ""
    local function addlog(msgname)
        --ct.log("abel_w11_Comments",msgname)
        code = code.."\n".."ct.log(\"abel_w11_loadstring_log\",\""..msgname.."\")"
    end
    addlog("E_C2S_GET_SERVER_LIST")
    addlog("E_C2S_GET_GAME_ANN")
    addlog("count = 100000")
    addlog("addct.log(msgname)")

    --合并log
    local timeMg = UnitTest.PerformanceTest("abel_w11_loadstring_log","[test_w11_loadstring_log] 合并log", function()
        local fun = loadstring(code)
        if fun then
            for i = 1, count do
                loadstring(code)()
            end
        end
    end)
    --独立打印
    local timeSp = UnitTest.PerformanceTest("abel_w11_loadstring_log","[test_w11_loadstring_log] 单独log", function()
        for i = 1, count do
            ct.log("abel_w11_loadstring_log","E_C2S_GET_SERVER_LIST")
            ct.log("abel_w11_loadstring_log","E_C2S_GET_GAME_ANN")
            ct.log("abel_w11_loadstring_log","count = 100000")
            ct.log("abel_w11_loadstring_log","addct.log(msgname)")
        end
    end)
    ct.log("abel_w11_loadstring_log","[test_w11_loadstring_log]  合并log打印时间：",timeMg, "独立打印时间：",timeSp)
    --结论： 没有什么区别，执行效率非常接近
end)

UnitTest.Exec("abel_w13_abel_sort", "test_w13_abel_sort",  function ()
    ct.log("abel_w13_abel_sort","[test_w13_abel_sort] 排序性能比对 ")
    --[[--
    -   orderByBubbling: 冒泡排序
    -   @param: t,
    -    @return: list - table
    ]]
    function table.orderByBubbling(t)
        for i = 1, #t do
            for j = #t, i + 1, -1 do
                if t[j - 1] > t[j] then
                    swap(t, j, j - 1)
                    printT(t)
                end
            end
        end
        return t
    end

    --[[--
-   partition: 获得快排中介值位置
-   @param: list, low, high - 参数描述
-   @return: pivotKeyIndex - 中介值索引
]]
    function partition(list, low, high)
        local low = low
        local high = high
        local pivotKey = list[low] -- 定义一个中介值

        -- 下面将中介值移动到列表的中间
        -- 当左索引与右索引相邻时停止循环
        while low < high do
            -- 假如当前右值大于等于中介值则右索引左移
            -- 否则交换中介值和右值位置
            while low < high and list[high] >= pivotKey do
                high = high - 1
            end
            swap(list, low, high)

            -- 假如当前左值小于等于中介值则左索引右移
            -- 否则交换中介值和左值位置
            while low < high and list[low] <= pivotKey do
                low = low + 1
            end
            swap(list, low, high)
        end
        return low
    end

    --[[--
    -   orderByQuick: 快速排序
    -   @param: list, low, high - 参数描述
    -    @return: list - table
    ]]
    function QuickSort(list, low, high)
        if low < high then
            -- 返回列表中中介值所在的位置，该位置左边的值都小于等于中介值，右边的值都大于等于中介值
            local pivotKeyIndex = partition(list, low, high)
            -- 分别将中介值左右两边的列表递归快排
            QuickSort(list, low, pivotKeyIndex - 1)
            QuickSort(list, pivotKeyIndex + 1, high)
        end
    end

    local orderedTable = {}
    local randTable={}
    local count = 10000
    local resetTable = function()
        for i = 1, count do
            orderedTable[i] = i
            randTable[i] =  math.random(i*50)
        end
    end
    --ordered table
    local timeMg = UnitTest.PerformanceTest("abel_w13_abel_sort","[test_w13_abel_sort] sort ordered table using Bubbling", function()
        table.orderByBubbling(ct.deepCopy(orderedTable))
    end)

    local timeMg1 = UnitTest.PerformanceTest("abel_w13_abel_sort","[test_w13_abel_sort] sort ordered table using  QuickSort", function()
        QuickSort(ct.deepCopy(orderedTable), 1, count)
    end)

    local timeMg2 = UnitTest.PerformanceTest("abel_w13_abel_sort","[test_w13_abel_sort] sort ordered table using  lua table.sort", function()
        table.sort(ct.deepCopy(orderedTable))
    end)

    --noneOrdered table
    local timeMg = UnitTest.PerformanceTest("abel_w13_abel_sort","[test_w13_abel_sort] sort noneOrdered table using Bubbling", function()
        table.orderByBubbling(ct.deepCopy(randTable))
    end)

    local timeMg1 = UnitTest.PerformanceTest("abel_w13_abel_sort","[test_w13_abel_sort] sort noneOrdered table using  QuickSort", function()
        QuickSort(ct.deepCopy(randTable), 1, count)
    end)

    local timeMg2 = UnitTest.PerformanceTest("abel_w13_abel_sort","[test_w13_abel_sort] sort noneOrdered table using  lua table.sort", function()
        table.sort(ct.deepCopy(randTable))
    end)

end)

UnitTest.TestBlockEnd()-----------------------------------------------------------