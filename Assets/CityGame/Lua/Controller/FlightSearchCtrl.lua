---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/21 10:35
---
-----

FlightSearchCtrl = class('FlightSearchCtrl',UIPanel)
UIPanel:ResgisterOpen(FlightSearchCtrl)

function FlightSearchCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function FlightSearchCtrl:bundleName()
    return "Assets/CityGame/Resources/View/FlightSearchPanel.prefab"
end

function FlightSearchCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function FlightSearchCtrl:Awake(go)
    self.gameObject = go
    local behaviour = self.gameObject:GetComponent('LuaBehaviour')
    behaviour:AddClick(FlightSearchPanel.backBtn.gameObject, function ()
        self:backFunc()
    end , self)
    behaviour:AddClick(FlightSearchPanel.startBtn.gameObject, function ()
        self:startChooseFunc()
    end , self)
    behaviour:AddClick(FlightSearchPanel.endBtn.gameObject, function ()
        self:endChooseFunc()
    end , self)
    behaviour:AddClick(FlightSearchPanel.timeBtn.gameObject, function ()
        self:timeChooseFunc()
    end , self)
    behaviour:AddClick(FlightSearchPanel.exchangeBtn.gameObject, function ()
        self:exchangeBtnFunc()
    end , self)
    behaviour:AddClick(FlightSearchPanel.checkBtn.gameObject, function ()
        self:checkBtnFunc()
    end , self)
end

function FlightSearchCtrl:Refresh()
    Event.AddListener("c_getSearchFlightResult", self._getSearchFlightResult, self)
    self:_initData()
end

function FlightSearchCtrl:Active()
    UIPanel.Active(self)
    self:_language()
end

function FlightSearchCtrl:Hide()
    Event.RemoveListener("c_getSearchFlightResult", self._getSearchFlightResult, self)
    UIPanel.Hide(self)
end
--
function FlightSearchCtrl:_initData()
    --默认出发地为北京，目的地为上海
    FlightSearchPanel.timeText.text = os.date("%W, %Y-%m-%d", os.time())
    self.startCode = "CTU"
    self.arriveCode = "NKG"
    self.timeValue = "2019-06-19"
end
--
function FlightSearchCtrl:_language()
    FlightSearchPanel.titleText01.text = GetLanguage(32010003)
    FlightSearchPanel.titleText02.text = GetLanguage(32020001)
    FlightSearchPanel.startText03.text = GetLanguage(32020002)
    FlightSearchPanel.endText04.text = GetLanguage(32020003)
    FlightSearchPanel.timeText05.text = GetLanguage(32020004)
end
--
function FlightSearchCtrl:backFunc()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--选择起飞地
function FlightSearchCtrl:startChooseFunc()
    PlayMusEff(1002)
    ct.OpenCtrl("FlightChoosePlaceCtrl", {callback = function(data)
        self:startChooseResult(data)
    end})
end
--选择目的地
function FlightSearchCtrl:endChooseFunc()
    PlayMusEff(1002)
    ct.OpenCtrl("FlightChoosePlaceCtrl", {callback = function(data)
        self:endChooseResult(data)
    end})
end
--选择时间
function FlightSearchCtrl:timeChooseFunc()
    PlayMusEff(1002)
    --ct.OpenCtrl("FlightChoosePlaceCtrl", {callback = self.timeChooseResult})
end
--起始地目的地交换
function FlightSearchCtrl:exchangeBtnFunc()
    PlayMusEff(1002)
    local start = self.startCode
    local arrive = self.arriveCode
    self.startCode = arrive
    self.arriveCode = start
    FlightSearchPanel.startText.text = self.startCode
    FlightSearchPanel.endText.text = self.arriveCode
end
--开始搜索
function FlightSearchCtrl:checkBtnFunc()
    PlayMusEff(1002)
    FlightMainModel.m_ReqSearchFlight(self.startCode, self.arriveCode, self.timeValue)
end
--起点选择的回调
function FlightSearchCtrl:startChooseResult(data)
    self.startCode = data
    FlightSearchPanel.startText.text = data.value
end
--终点选择的回调
function FlightSearchCtrl:endChooseResult(data)
    self.arriveCode = data
    FlightSearchPanel.endText.text = data.value
end
--起点选择的回调
function FlightSearchCtrl:timeChooseResult(data)
    --self.timeValue = data
    FlightSearchPanel.timeText.text = data.value
end
--服务器回调
function FlightSearchCtrl:_getSearchFlightResult(data)
    if data ~= nil and data.data ~= nil and #data.data > 0 then
        --接到服务器回调之后再打开界面
        ct.OpenCtrl("FlightChooseFlightCtrl", data.data)
    else
        Event.Brocast("SmallPop", GetLanguage(32030031))
    end
end