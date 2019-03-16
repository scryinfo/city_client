ClimateManager = {}
local m_Timer = nil
local m_Date = -1
local m_Hour = -1
local m_WeatherID = nil
local m_DayAndNightID = nil

local m_Rain = nil
local m_Snow = nil


local function ChangeWeather()
    m_Rain:SetActive(false)
    m_Snow:SetActive(false)
    if m_WeatherID == 0 then        --晴天/阴天

    elseif m_WeatherID == 1 then    --下雨
        --m_Rain:SetActive(true)
    elseif m_WeatherID == 2 then    --下雪
        --m_Snow:SetActive(true)
    end
end

local function ChangeDayAndNight()
    local ShaderSetting = DayAndNightConfig[m_DayAndNightID]
    if ShaderSetting ~= nil then
        MapObjectsManager.ChangeShader(ShaderSetting)
    end
end

--改变天气或昼夜
local function JudgeChangeWeatherOrChangeDaN(newClimateID)
    local tempWeatherID = math.floor(newClimateID / 100)
    local tempDayAndNightID = newClimateID % 100
    if m_WeatherID == nil or tempWeatherID ~= m_WeatherID then
        m_WeatherID = tempWeatherID
        ChangeWeather()
    end
    if m_DayAndNightID == nil or m_DayAndNightID ~= tempDayAndNightID then
        m_DayAndNightID = tempDayAndNightID
        ChangeDayAndNight()
    end
end


local function RefreshWeather()
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local date = tonumber(ts.year..ts.month..ts.day)
    local hour = tonumber(ts.hour)
    if m_Date ~= date or  m_Hour ~= hour then
        m_Date = date
        m_Hour = hour
        if ClimateConfig[date][hour] ~= nil then
            JudgeChangeWeatherOrChangeDaN(ClimateConfig[date][hour])
        end
    end
end


function ClimateManager.Init()
    m_Date = -1
    m_Hour = -1
    m_Timer = Timer.New(RefreshWeather, 20, -1, true)
    m_Timer.time = 0
    m_Timer:Start()

    m_Rain = UnityEngine.GameObject.Find("CameraRoot/Effect/Effect_Rain")
    m_Snow = UnityEngine.GameObject.Find("CameraRoot/Effect/Effect_Snow")
end



