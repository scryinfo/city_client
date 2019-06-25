--与服务器同步时间数据
--TODO:应做时间处理.放置用户修改本地时间（目前不修改，因服务器会做校验）
TimeSynchronized = {}

--本地时间与服务器时间比较
local m_TimeOffset = nil

--同步服务器时间
function  TimeSynchronized.SynchronizationServerTime(ServerTime)
    if m_TimeOffset == nil then
        --ClimateManager.Init()
    end
    m_TimeOffset = ServerTime - tolua.gettime() * 1000

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

--获取服务器的当前时间(毫秒)
function TimeSynchronized.GetTheCurrentServerTime()
    if JudgeIsRightTimeOffset() == true then
        return tolua.gettime() * 1000 + m_TimeOffset
    end
    return nil
end

--获取与服务器同步的当前时间(秒)
function TimeSynchronized.GetTheCurrentTime()
    if JudgeIsRightTimeOffset() == true then
        return (tolua.gettime() * 1000 + m_TimeOffset) / 1000
    end
    return nil
end

--获取目标时间与当前时间（服务器）的差值
--若大于0则表示时间未到
function TimeSynchronized.GetTheDifferenceFromTheCurrentTime(targetTime)
    if JudgeIsRightTimeOffset() == true then
        return targetTime - (tolua.gettime() * 1000 + m_TimeOffset)
    end
    return nil
end


--退出登录时做清空处理
function TimeSynchronized.ExitTheServer()
    m_TimeOffset = nil
end