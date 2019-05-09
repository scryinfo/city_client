---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/10 16:08
---推广公司曲线图
PromoteCurveCtrl = class('PromoteCurveCtrl',UIPanel)
UIPanel:ResgisterOpen(PromoteCurveCtrl)

local curveBehaviour

function PromoteCurveCtrl:bundleName()
    return "Assets/CityGame/Resources/View/PromoteCurvePanel.prefab"
end

function PromoteCurveCtrl:initialize()
    --UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end
function PromoteCurveCtrl:Awake()
    curveBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    curveBehaviour:AddClick(PromoteCurvePanel.back,self.OnBack,self);
    self:initData()
end

function PromoteCurveCtrl:Active()
    UIPanel.Active(self)
    PromoteCurvePanel.curve.anchoredPosition = Vector3.New(-1252, 59,0)
    PromoteCurvePanel.curve.sizeDelta = Vector2.New(2878, 402)  --MaxWidth
end

function PromoteCurveCtrl:Refresh()
    local typeId
    if self.m_data.Data.typeId == 2251 then
        typeId = 1651
        LoadSprite("Assets/CityGame/Resources/Atlas/PromoteCompany/icon-food.png", PromoteCurvePanel.icon)
    elseif self.m_data.Data.typeId == 2252 then
        typeId = 1652
        LoadSprite("Assets/CityGame/Resources/Atlas/PromoteCompany/icon-clothes.png", PromoteCurvePanel.icon)
    elseif self.m_data.Data.typeId == 1300 then
        typeId = 1653
        LoadSprite("Assets/CityGame/Resources/Atlas/PromoteCompany/icon-supermarket.png", PromoteCurvePanel.icon)
    elseif self.m_data.Data.typeId == 1400 then
        typeId = 1654
        LoadSprite("Assets/CityGame/Resources/Atlas/PromoteCompany/icon-house.png", PromoteCurvePanel.icon)
    end
    PromoteCurvePanel.name.text = self.m_data.Data.name
    DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_PromoAbilityHistory',self.m_data.insId,typeId)
end

function PromoteCurveCtrl:Hide()
    UIPanel.Hide(self)
    PromoteCurvePanel.graph:Close()
    PromoteCurvePanel.slide:Close()
    PromoteCurvePanel.curve.anchoredPosition = Vector3.New(-1252, 59,0)
    PromoteCurvePanel.curve.sizeDelta = Vector2.New(2878, 402)  --MaxWidth
end

function PromoteCurveCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function PromoteCurveCtrl:initData()

end

--返回
function PromoteCurveCtrl:OnBack()
    UIPanel.ClosePage()
end

function PromoteCurveCtrl:m_PromoteHistoryCurve(data)
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local second = tonumber(ts.second)
    local minute = tonumber(ts.minute)
    if second ~= 0 then
        currentTime = currentTime -second
    end
    if minute ~= 0 then
        currentTime = currentTime - minute * 60
    end
    local oneDay = currentTime - 23*3600
    local updataTime = oneDay
    local time = {}
    local boundaryLine = {}
    local line = {}
    for i = 1, 24 do
        if tonumber(getFormatUnixTime(updataTime).hour) == 0 then
            time[i] = getFormatUnixTime(updataTime).month .. "/" .. getFormatUnixTime(updataTime).day
            table.insert(boundaryLine,(updataTime - oneDay +3600) / 3600 * 120)
        else
            time[i] = tostring(getFormatUnixTime(updataTime  ).hour)
        end
        line[i] = {}
        line[i].value = 0
        line[i].ts = updataTime
        if data then
            for i, v in pairs(data) do
                if line[i].ts == v.ts then
                    line[i].value = v.value
                end
            end 
        end
        line[i].ts = (updataTime - oneDay + 3600) / 3600 * 120
        updataTime = updataTime +3600
    end
    local lineValeu = {}
    for i, v in ipairs(line) do
        lineValeu[i] = Vector2.New(v.ts,v.value)  --
    end
    table.insert(time,1,"0")
    table.insert(boundaryLine,1,0)
    table.insert(lineValeu,1,Vector2.New(0,0))
    local max = 0
    for i, v in ipairs(lineValeu) do
        if v.y > max then
            max = v.y
        end
    end
    local scale = SetYScale(max,4,PromoteCurvePanel.yScale,true)
    local lineVet = {}
    for i, v in ipairs(lineValeu) do
        if scale == 0 then
            lineVet[i] = v
        else
            lineVet[i] = Vector2.New(v.x,v.y / scale * 67)
        end
    end
    PromoteCurvePanel.slide:SetXScaleValue(time,120)
    PromoteCurvePanel.graph:BoundaryLine(boundaryLine)

    PromoteCurvePanel.graph:DrawLine(lineVet,Color.New(213 / 255, 137 / 255, 0 / 255, 255 / 255),1)
    PromoteCurvePanel.slide:SetCoordinate(lineVet,lineValeu,Color.New(213 / 255, 137 / 255, 0 / 255, 255 / 255),1)

    PromoteCurvePanel.curve.localPosition = PromoteCurvePanel.curve.localPosition + Vector3.New(0.01, 0,0)
    PromoteCurvePanel.curve.sizeDelta = PromoteCurvePanel.curve.sizeDelta + Vector2.New(0.01, 0)
end

