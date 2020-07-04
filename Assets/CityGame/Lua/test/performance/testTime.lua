--scale is 0, then only execute once
--return function(scale,title, f) --Add a return in front, this method can be executed, not just the definition
-- assert(scale >= 0 ,"time require scale >= 0")
--
--  collectgarbage()
--
--  local startTime = os.clock()
--
--  --for i=1,scale do f() end
--
--  local endTime = os.clock()
--
--  ct.log("performance", "[",title,"] ",endTime - startTime)
--
--end

function timeTestfun(testGroupId, fname, f)
    if TestGroup.get_TestGroupId(testGroupId) == nil then
        return
    end
    collectgarbage()
    local startTime = os.clock()
    f()
    local endTime = os.clock()
    ct.log("performance", "[",fname,"] ",endTime - startTime)
end

local testfun = timeTestfun

