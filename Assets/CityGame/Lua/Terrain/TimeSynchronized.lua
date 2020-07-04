-- Synchronize time data with the server
--TODO:Time processing should be done. Place the user to modify the local time (currently not modified, because the server will do the verification)
TimeSynchronized = {}

--Comparison of local time and server time
local m_TimeOffset = nil

--Sync server time
function  TimeSynchronized.SynchronizationServerTime(ServerTime)
    if m_TimeOffset == nil then
        ClimateManager.Init()
    end
    m_TimeOffset = ServerTime - tolua.gettime() * 1000

end

-- judge whether the time is synchronized locally
local function JudgeIsRightTimeOffset()
    if m_TimeOffset == nil then
        ct.log("system","Error: 还未与服务器同步时间！！！")
    elseif type(m_TimeOffset) ~= "number"  then
        ct.log("system","Error: 同步时间错误！！！")
    else
        return true
    end
    return false
end

--Get the server's current time (milliseconds)
function TimeSynchronized.GetTheCurrentServerTime()
    if JudgeIsRightTimeOffset() == true then
        return tolua.gettime() * 1000 + m_TimeOffset
    end
    return nil
end

--Get the current time (seconds) synchronized with the server
function TimeSynchronized.GetTheCurrentTime()
    if JudgeIsRightTimeOffset() == true then
        return (tolua.gettime() * 1000 + m_TimeOffset) / 1000
    end
    return nil
end

--Get the difference between the target time and the current time (server)
--- If it is greater than 0, it means that the time has not arrived
function TimeSynchronized.GetTheDifferenceFromTheCurrentTime(targetTime)
    if JudgeIsRightTimeOffset() == true then
        return targetTime - (tolua.gettime() * 1000 + m_TimeOffset)
    end
    return nil
end


--Empty processing when logging out
function TimeSynchronized.ExitTheServer()
    m_TimeOffset = nil
end