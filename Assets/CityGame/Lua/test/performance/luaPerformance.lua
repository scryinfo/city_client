---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/18 18:22
---

UnitTest.TestBlockStart()---------------------------------------------------------

testtime = require 'test/performance/testTime'

--[[
 If we are clear that all the data in the table is stored in a linear array, ipairs is twice as fast as ,pairs; but nil value cannot appear in the middle of ipairs,
  Otherwise it will cause the traversal to be interrupted), if we traverse the values in the hash table explicitly, then use pairs
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
    When using the local cache function, the performance has been greatly improved by 21.70 times!
     Execution time: 0.49900000000002
     Execution time: 0.0029999999999291
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
The efficiency of table_insert is very low, use with caution!
[Expand array with table insert] Execution time: 1.5029999999988
[Expand array with loop counter] Execution time: 0.0059999999994034
[Expand array with table size] Execution time: 0.10900000000038
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

    --Merge log
     local timeMg = UnitTest.PerformanceTest("abel_w11_loadstring_log","[test_w11_loadstring_log] merge log", function()
        local fun = loadstring(code)
        if fun then
            for i = 1, count do
                loadstring(code)()
            end
        end
    end)
    -- Independent printing
    local timeSp = UnitTest.PerformanceTest("abel_w11_loadstring_log","[test_w11_loadstring_log] separate log", function()
        for i = 1, count do
            ct.log("abel_w11_loadstring_log","E_C2S_GET_SERVER_LIST")
            ct.log("abel_w11_loadstring_log","E_C2S_GET_GAME_ANN")
            ct.log("abel_w11_loadstring_log","count = 100000")
            ct.log("abel_w11_loadstring_log","addct.log(msgname)")
        end
    end)
    ct.log("abel_w11_loadstring_log","[test_w11_loadstring_log] combined log printing time:",timeMg, "independent printing time:",timeSp)
    --Conclusion: There is no difference, the execution efficiency is very close
end)

UnitTest.Exec("abel_w13_abel_sort", "test_w13_abel_sort",  function ()
    ct.log("abel_w13_abel_sort","[test_w13_abel_sort] 排序性能比对 ")
    local temp = 0
    function swap(list, p1, p2)
        temp = list[p1]
        list[p2] = list[p1]
        list[p1] = temp
    end
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
                    --printT(t)
                end
            end
        end
        return t
    end

    --[[--
-   partition: Get fast-track mediation position
-	@param: list, low, high-parameter description
-	@return: pivotKeyIndex-mediate index
]]
    function partition(list, low, high)
        local low = low
        local high = high
        local pivotKey = list[low] -- define an intermediate value

        -- Now move the intermediary value to the middle of the list
        -- Stop the loop when the left index is adjacent to the right index
        while low <high ​​do
            -- If the current rvalue is greater than or equal to the intermediary value, the right index moves to the left
            -- Otherwise swap the intermediary and rvalue positions
            while low <high ​​and list[high] >= pivotKey do
                high = high-1
            end
            swap(list, low, high)

            -- If the current left value is less than or equal to the intermediary value, the left index moves to the right
            -- Otherwise swap the intermediary and lvalue positions
            while low <high ​​and list[low] <= pivotKey do
                low = low + 1
            end
            swap(list, low, high)
        end
        return low
    end

    --[[--
    -orderByQuick: quick sort
    -@param: list, low, high-parameter description
    -@return: list-table
    ]]
    function QuickSort(list, low, high)
        if low <high ​​then
            -- Returns the position of the intermediary value in the list, the values ​​on the left of the position are less than or equal to the intermediary value, and the values ​​on the right are greater than or equal to the intermediary value
            local pivotKeyIndex = partition(list, low, high)
            -- Recursively sort the lists on the left and right of the intermediary value
            QuickSort(list, low, pivotKeyIndex - 1)
            QuickSort(list, pivotKeyIndex + 1, high)
        end
    end

    local orderedTable = {}
    local randTable={}
    local count = 50000
    local resetTable = function()
        for i = 1, count do
            orderedTable[i] = i
            randTable[i] =  math.random(i*50)
        end
    end

    resetTable()

    --noneOrdered table
    tb = ct.deepCopy(randTable)
    ct.log("abel_w13_abel_sort","sort noneOrdered table using Bubbling ")
    UnitTest.PerformanceTest("abel_w13_abel_sort","[test_w13_O_abel_sort] sort noneOrdered table using Bubbling", function()
        table.orderByBubbling(tb)
    end)

    tb = ct.deepCopy(randTable)
    ct.log("abel_w13_abel_sort","sort noneOrdered table using  QuickSort ")
    UnitTest.PerformanceTest("abel_w13_abel_sort","[test_w13_O_abel_sort] sort noneOrdered table using  QuickSort", function()
        QuickSort(tb, 1, count)
    end)

    tb = ct.deepCopy(randTable)
    ct.log("abel_w13_abel_sort","sort noneOrdered table using  lua table.sort ")
    UnitTest.PerformanceTest("abel_w13_abel_sort","[test_w13_O_abel_sort] sort noneOrdered table using  lua table.sort", function()
        table.sort(tb)
    end)
    --[[
    Test Results
         Call table.sort (the native fast sort method in encapsulated c) sorting speed is much higher than sorting in Lua, 50,000 elements sorting table.sort is 26 times faster than the fast sorting in Lua, 448 times faster than bubbling
    --]]

end)

local printT = function(logid, msg, t)
    ct.log(logid,msg,"printT ---------------")
    for k,v in pairs(t) do
        ct.log(logid,k, v.v)
    end
    ct.log(logid,msg,"---------------")
end

UnitTest.Exec("abel_w13_abel_sort_tb", "test_abel_sort_tb",  function ()
    local count = 20
    local tb1 = { }

    local resetfun = function()
        for i = 1, count do
            tb1[i] = { v = math.random(i*50)}
        end
    end

    resetfun()

    --Descending order
    local tb = ct.deepCopy(tb1)
    UnitTest.PerformanceTest("abel_w13_abel_sort_tb","[test_w13_O_abel_sort] lua table.sort > ", function()
        table.sort(tb, function (element1, element2)
            return element1.v > element2.v
        end)
    end)
    printT("abel_w13_abel_sort_tb","",tb)

    --Ascending order
    tb = ct.deepCopy(tb1)
    UnitTest.PerformanceTest("abel_w13_abel_sort_tb","[test_w13_O_abel_sort] lua table.sort < ", function()
        table.sort(tb, function (element1, element2)
            return element1.v < element2.v
        end)
    end)
    printT("abel_w13_abel_sort_tb","",tb)

end)

UnitTest.Exec("abel_w13_abel_sort_tb_eq", "test_abel_sort_tb_eq",  function ()
    local count = 20
    local tb1 = { }

    local resetfun = function()
        for i = 1, count do
            tb1[i] = { v = math.random(i*50)}
        end
        tb1[ct.getIntPart(count/2)] = {v = 200}
        tb1[ct.getIntPart(count/3)] = {v = 200}
        tb1[ct.getIntPart(count/4)] = {v = 200}
    end
    resetfun()

    --There is equal, the test is also successful
     local tb = ct.deepCopy(tb1)

     --Sort error
     UnitTest.PerformanceTest("abel_w13_abel_sort_tb_eq","[test_w13_O_abel_sort_tb_eq] lua table.sort <= ", function()
         table.sort(tb, function (element1, element2)
             return element1.v <= element2.v
         end)
     end)
     printT("abel_w13_abel_sort_tb_eq"," <= ",tb)

     --Sort error
     tb = ct.deepCopy(tb1)
     UnitTest.PerformanceTest("abel_w13_abel_sort_tb_eq","[test_w13_O_abel_sort_tb_eq] lua table.sort >= ", function()
         table.sort(tb, function (element1, element2)
             return element1.v >= element2.v
         end)
     end)
     printT("abel_w13_abel_sort_tb_eq",">=",tb)

     --Note: The tests for <= and >= will fail, and the sorting conditions cannot be equal, either greater or less than
end)

UnitTest.Exec("abel_w18_tableDestroy", "abel_w18_tableDestroy", function ()
     local testcount = 100000 -- number of resources loaded
     local ResPathList = {} -- resource path
    local resLoad  = resMgr:LoadRes_S('TempIcon/A'..1, ct.getType(UnityEngine.Sprite))
    local objIns = {}

    local initialData = function()
        for i = 1, testcount do
            objIns[#objIns+1] = UnityEngine.GameObject.Instantiate(resLoad._asset);
        end
    end

    initialData()
    UnitTest.PerformanceTest("abel_w18_tableDestroy","[使用 pairs 遍历table并destroy]", function()
        for i, v in pairs(objIns) do
            GameObject.DestroyImmediate(objIns[#objIns], true)
        end
        objIns = {}
    end)

    collectgarbage("collect")

    initialData()
    UnitTest.PerformanceTest("abel_w18_tableDestroy","[倒序destroy]", function()
        --Do not use pairs traversal for table destruction, although there will be no errors, but the efficiency is not high, so delete directly from the last element
         while #objIns> 0 do
            GameObject.DestroyImmediate(objIns[#objIns], true)
            objIns[#objIns] = nil--here must be assigned nil, otherwise it is an infinite loop
        end
    end)

    --[[
    Test Results
        [abel_w18_tableDestroy][Use pairs to traverse table and destroy] Execution time: 0.039999999999964
        [abel_w18_tableDestroy][Reverse order destroy] Execution time: 0.39799999999991
        * Iterator traversal efficiency is indeed much higher
    --]]

end)

UnitTest.TestBlockEnd()-----------------------------------------------------------