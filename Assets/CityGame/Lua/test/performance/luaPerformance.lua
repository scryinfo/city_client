---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/18 18:22
---

if not CityGlobal.G_PERFORMANCETEST then return {} end

testtime = require 'test/performance/testTime'

--[[
 如果我们明确table中的数据全部存放在线性数组中, 调用ipairs或者pairs均可, 并无太大差异(注意ipairs时中间不要出现nil值,
 否则会导致遍历中断), 如果我们明确遍历hash表中的值, 则使用pairs
]]--
local tb = {"oh", [3] = "god", "my", [5] = "hello", [4] = "world"}
testtime(1000000,"ipairs performance", function()
    for k,v in ipairs(tb) do
        v = 1
    end
end)

testtime(1000000,"pairs performance", function()
    for k,v in pairs(tb) do
        v = 1
    end
end)

testtime(1000000,"tb[i] performance", function()
    for i = 1, #tb do
        tb[i] = 1
    end
end)

--输出
--[performance][    ipairs performance    ]     0.048999999999978
--[performance][    pairs performance    ]     0.042000000000002
--[performance][    tb[i] performance    ]     0.030000000000001

local sin = math.sin  --local reference to math.sin
local testValue = 0
testtime(1,"test local performance", function()
    for i = 1,1000000 do
        testValue = testValue + sin(i)
    end
end
)

testValue = 0
testtime(1,"test global performance", function()
    for i = 1,1000000 do
        testValue = testValue + math.sin(i)
    end
end
)
-- [performance][    test local performance    ]     0.037000000000006
-- [performance][    test global performance    ]     0.036999999999978

local func1 = function(a,b,func)
    return func(a+b)
end

testtime(100000,"将函数体定义作为参数传递", function()
    local x = func1( 1, 2, function(a) return a*2 end )
end
)

local func2 = function( c )
    return c*2
end

testtime(100000, "使用局部变量传递函数参数",function()
    local x = func1( 1, 2, func2 )
end)

--[performance][    将函数体定义作为参数传递    ]     0.0060000000000002
--[performance][    使用局部变量传递函数参数    ]     0.0010000000000048

local a = {}
local table_insert = table.insert
local testcount = 1000000
testtime(1, "使用table.insert()",function()
    for i = 1,testcount do
        table_insert( a, i )
    end
end)

a = {}
testtime(1, "使用循环的计数",function()
    for i = 1,testcount do
        a[i] = i
    end
end)

a = {}
testtime(1, "使用table的size",function()
    for i = 1,testcount do
        a[#a+1] = i
    end
end)

a = {}
local index = 1
testtime(1, "使用计数器",function()
    for i = 1,testcount do
        a[index] = i
        index = index+1
    end
end)

--[performance][    使用table.insert()    ]     0.10599999999999
--[performance][    使用循环的计数    ]     0.0049999999999955
--[performance][    使用table的size    ]     0.10599999999999
--[performance][    使用计数器    ]     0.0060000000000002

local tb_unpack = { 100, 200, 300, 400 }
local tb_unpackRet = {}
testtime(100000, "使用 unpack()函数",function()
    tb_unpackRet = unpack(tb_unpack)
end)

tb_unpackRet = {}
testtime(100000, "不使用unpack()函数",function()
    for i = 1,#tb_unpack do
        tb_unpackRet[i] =  tb_unpack[i]
    end
end)

--使用 unpack()函数    0.048000000000002
--不使用unpack()函数    0.03000000000003
a = {}
for n = 1,1000 do
    a[n] = {x = n}
end
testtime(1, "缓存table的元素",function()
    for i = 1,1000 do
        for n = 1,1000 do
            local y = a[n]
            y.x = y.x + 1
        end
    end
end)
testtime(1, "不缓存table的元素",function()
    for i = 1,1000 do
        for n = 1,1000 do
            a[n].x = a[n].x + 1
        end
    end
end)

--[performance][    缓存table的元素    ]     0.0020000000000095
--[performance][    不缓存table的元素    ]     0.0020000000000095