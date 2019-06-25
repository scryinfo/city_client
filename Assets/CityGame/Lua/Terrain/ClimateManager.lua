ClimateManager = {}
local m_Timer = nil
local m_Date = -1
local m_Hour = -1
local m_WeatherID = nil
local m_DayAndNightID = nil

local m_Rain = nil
local m_Snow = nil

ClimateManager.Temperature = nil        --温度
ClimateManager.WeatherType = nil        --天气类型
ClimateManager.WeatherIcon = nil        --天气图片
ClimateManager.TimeSlotType = nil       --时间段

--收到天气返回数据,对数据进行更新
local function ReceviedWeatherInfo(data)
    if data ~= nil then
        ClimateManager.ChangeTemperature(data.temp)
        ClimateManager.ChangeWeatherType(data.icon)
    end
end

--获取服务器当前天气【整点调用一次】
local function GetWeatherNow()
    local msgId = pbl.enum("gscode.OpCode","queryWeatherInfo")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end


local function TransClimateID(hours)
    if  hours ~= nil and ClimateTimeConfig[hours] ~= nil then
        return ClimateTimeConfig[hours]
    end
    return nil
end

local function TransWeatherID(serverWeather)
    if  serverWeather ~= nil and WeatherTypeConfig[serverWeather] ~= nil then
        return WeatherTypeConfig[serverWeather]
    end
    return nil
end

--改变材质
local function CaculationShader()
    if ClimateManager.WeatherType ~= nil and ClimateManager.TimeSlotType ~= nil and WeatherIDConfig[ClimateManager.WeatherType] ~= nil then
        local setting = WeatherIDConfig[ClimateManager.WeatherType] * 6 + ClimateManager.TimeSlotType
        if DayAndNightConfig[setting] ~= nil then
            return DayAndNightConfig[setting]
        end
    end
    return nil
end

--时段变化
local function ClimateChange()
    local shaderSetting =CaculationShader()
    if shaderSetting ~= nil then
        MapObjectsManager.ChangeShader(shaderSetting)
    end
end

--天气变化
local function WeatherTypeChange()
    ClimateChange()
    --切换天气粒子特效
    m_Rain:SetActive(false)
    m_Snow:SetActive(false)
    if m_WeatherID == 0 then        --晴天/阴天

    elseif m_WeatherID == 1 then    --下雨
        --m_Rain:SetActive(true)
    elseif m_WeatherID == 2 then    --下雪
        --m_Snow:SetActive(true)
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
        --小时变化
       if ClimateManager.TimeSlotType == nil or ClimateManager.TimeSlotType ~= TransClimateID(m_Hour) then
           ClimateManager.TimeSlotType = TransClimateID(m_Hour)
           ClimateChange()
       end
        GetWeatherNow()
    end
end


function ClimateManager.Init()
    ClimateManager.Temperature = 0
    ClimateManager.TimeSlotType = 0
    m_Date = -1
    m_Hour = -1
    m_Timer = Timer.New(RefreshWeather, 20, -1, true)
    m_Timer.time = 0
    m_Rain = UnityEngine.GameObject.Find("CameraRoot/Effect/Effect_Rain")
    m_Snow = UnityEngine.GameObject.Find("CameraRoot/Effect/Effect_Snow")

    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryWeatherInfo"),ReceviedWeatherInfo)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryWeatherInfo","gs.Weather",ReceviedWeatherInfo)
end

function ClimateManager.Star()
    if m_Timer ~= nil then
        m_Timer:Start()
    end
end

function ClimateManager.Stop()
    if m_Timer ~= nil then
        m_Timer:Stop()
    end
end

--改变温度
function ClimateManager.ChangeTemperature(tempTemperature)
    if tempTemperature ~= nil and ClimateManager.Temperature ~= tempTemperature then
        ClimateManager.Temperature = tempTemperature
        Event.Brocast("TemperatureChange")
    end
end

--改变天气
function ClimateManager.ChangeWeatherType(tempWeather)
    local tempWeatherType = TransWeatherID(tempWeather)
    if tempWeatherType ~= nil and ClimateManager.WeatherType ~= tempWeatherType then
        ClimateManager.WeatherType  = tempWeatherType
        WeatherTypeChange()
    end
    if tempWeather ~= nil and (ClimateManager.WeatherIcon == nil or ClimateManager.WeatherIcon ~= tempWeather) then
        ClimateManager.WeatherIcon = tempWeather
        Event.Brocast("WeatherIconChange")
    end
end





