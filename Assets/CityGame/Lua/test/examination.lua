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


function _G.test_ipairs()
   local tb = {"oh", [3] = "god", "my", [5] = "hello", [6] = "world"}
    for k,v in ipairs(tb) do
        log(tostring("[examination] test_ipairs  for in  ipairs: "),k, v)
    end
end

function _G.test_pairs()
    local tb = {"oh", [3] = "god", "my", [5] = "hello", [6] = "world"}
    for k,v in pairs(tb) do
        log(tostring("[examination] test_pairs  for in  pairs: "),k, v)
    end
end

function _G.test_len()
    local tb = {"oh", [3] = "god", "my", [5] = "hello", [6] = "world"}
    --log(tostring("[examination] test_len: tb.len: "..table.getn(tb)))
    log(tostring("[examination] test_len: #tb "..#tb))
end


function _G.test_and()
    logWarn("[test] test_and start:")
    logWarn(tostring('a' and 'b' and 'c' and 'd' and nil and false and 'e' and 'f'))
    logWarn(tostring('a' and 'b' and 'c' and false and 'd' and nil and 'e' and 'f'))
    logWarn(tostring("[test] test_and end"))
end

function _G.test_or()
    logWarn("[test] test_or start: ")
    local testt = 0 or 1
    testt = 1 or 0
    testt = 0 and 1
    testt = 1 and 0

    testt = true or false
    testt = false and true
    testt = ture and false

    logDebug(tostring(nil or 'a' or 'b' or 'c' or 'd'   or false or 'e' or 'f'))
    logDebug(tostring('a' or nil or 'b' or 'c' or false or 'd'   or 'e' or 'f'))
    logDebug(tostring('a' or 'b' or nil or 'c' or false or 'd'   or 'e' or 'f'))
    logDebug("[test] test_or end ")
end

function _G.test_and_or()
    logWarn("[test] test_and_or start: ")
    local a = 666
    local b = 333
    local c = true
    logWarn(tostring(a > b) and a or b)
    logWarn(tostring(a < b) and a or b)
    logWarn(tostring(not c) and 'false' or 'true')
    logWarn("[test] test_and_or end ")
    --output:
    --666
    --333
    --true
end


