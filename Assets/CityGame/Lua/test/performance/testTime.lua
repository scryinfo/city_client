--scale 为0，那么只执行一次
--return function(scale,title, f) --前面加个 return ，能够让这个方法得到执行，而不仅仅是定义
--  assert(scale >= 0 ,"time require scale >= 0")
--
--  collectgarbage()
--
--  local startTime = os.clock()
--
--  --for i=1,scale do f() end
--
--  local endTime = os.clock()
--
--  log("performance", "[",title,"] ",endTime - startTime)
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
    log("performance", "[",fname,"] ",endTime - startTime)
end

local testfun = timeTestfun

