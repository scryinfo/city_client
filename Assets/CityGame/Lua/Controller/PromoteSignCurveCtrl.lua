---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/29 11:22
---推广签约曲线
PromoteSignCurveCtrl = class('PromoteSignCurveCtrl',UIPanel)
UIPanel:ResgisterOpen(PromoteSignCurveCtrl)

local curveBehaviour

function  PromoteSignCurveCtrl:bundleName()
    return "Assets/CityGame/Resources/View/PromoteSignCurvePanel.prefab"
end

function PromoteSignCurveCtrl:initialize()
    --UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end
function PromoteSignCurveCtrl:Awake()
    curveBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    curveBehaviour:AddClick(PromoteSignCurvePanel.xBtn,self.OnBack,self)
    self:initData()
end

function PromoteSignCurveCtrl:Active()
    UIPanel.Active(self)
    PromoteSignCurvePanel.curve.anchoredPosition = Vector3.New(-1180, 40,0)
    PromoteSignCurvePanel.curve.sizeDelta = Vector2.New(2860, 402)  --MaxWidth
    Event.AddListener("c_PromoteSignCurve",self.c_PromoteSignCurve,self)

end

function PromoteSignCurveCtrl:Refresh()
    if self.m_data.dataInfo.typeId == 13 then
        LoadSprite("Assets/CityGame/Resources/Atlas/PromoteCompany/icon-supermarket.png", PromoteSignCurvePanel.building, true)
    elseif self.m_data.dataInfo.typeId  == 14 then
        LoadSprite("Assets/CityGame/Resources/Atlas/PromoteCompany/icon-house.png", PromoteSignCurvePanel.building, true)
    end
    PromoteSignCurvePanel.buildingName.text = self.m_data.dataInfo.buildingName

    PromoteSignCurvePanel.buildingType.text = GetLanguage(PlayerBuildingBaseData[self.m_data.dataInfo.typeId].typeName)
    PlayerInfoManger.GetInfos({self.m_data.dataInfo.sellerPlayerId}, self.c_OnHead, self)
    DataManager.DetailModelRpcNoRet(self.m_data.insId, '_reqLiftCurve',self.m_data.buildingId)
end

function PromoteSignCurveCtrl:c_OnHead(info)
    AvatarManger.GetSmallAvatar(info[1].faceId,PromoteSignCurvePanel.head.transform,0.14)
    PromoteSignCurvePanel.name.text = info[1].name
end

function PromoteSignCurveCtrl:Hide()
    UIPanel.Hide(self)
    PromoteSignCurvePanel.curve.anchoredPosition = Vector3.New(-1180, 40,0)
    PromoteSignCurvePanel.curve.sizeDelta = Vector2.New(2860, 402)  --MaxWidth
    Event.RemoveListener("c_PromoteSignCurve",self.c_PromoteSignCurve,self)
    PromoteSignCurvePanel.graph:Close()
    PromoteSignCurvePanel.slide:Close()
end

function PromoteSignCurveCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function PromoteSignCurveCtrl:initData()
end

function PromoteSignCurveCtrl:OnBack()
    UIPanel.ClosePage()
end

function PromoteSignCurveCtrl:c_PromoteSignCurve(info)
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
    currentTime = math.floor(currentTime)               --当前小时数-整数
    local monthAgo = currentTime - 86400 + 3600         --1天前的0点
    local updataTime = monthAgo
    local time = {}
    local boundaryLine = {}
    local turnoverTab = {}

    for i = 1, 24 do
        if tonumber(getFormatUnixTime(updataTime).hour) == 0 then
            time[i] = getFormatUnixTime(updataTime).hour
            table.insert(boundaryLine,(updataTime - monthAgo + 3600) / 3600 * 118)
        else
            time[i] = tostring(getFormatUnixTime(updataTime).hour)
        end
        turnoverTab[i] = {}
        turnoverTab[i].coordinate = (updataTime - monthAgo + 3600) / 3600 * 118
        turnoverTab[i].flow = 0  --看具体字段
        if info.nodes ~= nil then
            for k, v in pairs(info.nodes) do
                if updataTime == v.time / 1000 then
                    turnoverTab[i].lift = v.lift
                end
            end
        end

        updataTime = updataTime + 3600
    end

    local turnover = {}
    for i, v in ipairs(turnoverTab) do
        turnover[i] = Vector2.New(v.coordinate,v.lift)  --
    end
    table.insert(time,1,"0")
    table.insert(boundaryLine,1,0)
    table.insert(turnover,1,Vector2.New(0,0))

    local scale = 0.2
    local turnoverVet = {}
    local showNumValue = {}  --用于点的显示
    for i, v in ipairs(turnover) do
            if scale == 0 then
                turnoverVet[i] = Vector2.New(v.x, v.y)
            else
                turnoverVet[i] = Vector2.New(v.x,v.y / scale * 80)
            end
        showNumValue[i] = Vector2.New(v.x,v.y * 100)
    end
    PromoteSignCurvePanel.slide:SetXScaleValue(time,118)
    PromoteSignCurvePanel.graph:BoundaryLine(boundaryLine)

    PromoteSignCurvePanel.graph:DrawLine(turnoverVet, getColorByInt(53, 72, 117),1)
    PromoteSignCurvePanel.slide:SetCoordinate(turnoverVet, showNumValue, Color.blue,1)

    PromoteSignCurvePanel.curve.localPosition = PromoteSignCurvePanel.curve.localPosition + Vector3.New(0.01, 0,0)
    PromoteSignCurvePanel.curve.sizeDelta = PromoteSignCurvePanel.curve.sizeDelta + Vector2.New(0.01, 0)
end
