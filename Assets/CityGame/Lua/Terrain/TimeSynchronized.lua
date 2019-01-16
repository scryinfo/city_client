--与服务器同步时间数据
TimeSynchronized = {}

--本地时间与服务器时间比较
local m_TimeOffset = nil

--同步服务器时间
function  TimeSynchronized.SynchronizationServerTime(ServerTime)
    m_TimeOffset = ServerTime - os.time()
end

--本地判断时间是否同步
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

--获取服务器的当前时间
function TimeSynchronized.GetTheCurrentServerTime()
    if JudgeIsRightTimeOffset() == true then
        return os.time() + m_TimeOffset
    end
    return nil
end

--获取目标时间与当前时间（服务器）的差值
--若大于0则表示时间未到
function TimeSynchronized.GetTheDifferenceFromTheCurrentTime(targetTime)
    if JudgeIsRightTimeOffset() == true then
        return targetTime - (os.time() + m_TimeOffset)
    end
    return nil
end


--退出登录时做清空处理
function TimeSynchronized.ExitTheServer()
    m_TimeOffset = nil
end