---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/26 17:29
---FlightBetCtrl
FlightBetCtrl = class('FlightBetCtrl',UIPanel)
UIPanel:ResgisterOpen(FlightBetCtrl)

function FlightBetCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end
--
function FlightBetCtrl:bundleName()
    return "Assets/CityGame/Resources/View/FlightBetPanel.prefab"
end
--
function FlightBetCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end
--
function FlightBetCtrl:Awake(go)
    local behaviour = self.gameObject:GetComponent('LuaBehaviour')
    behaviour:AddClick(FlightBetPanel.backBtn.gameObject, self._backBtnFunc, self)
    behaviour:AddClick(FlightBetPanel.confirmBtn.gameObject, function ()
        self:_confirmBtnFunc()
    end, self)
    behaviour:AddClick(FlightBetPanel.timeReduceBtn.gameObject, function ()
        self:_timeReduceFunc()
    end, self)
    behaviour:AddClick(FlightBetPanel.timeAddBtn.gameObject, function ()
        self:_timeAddFunc()
    end, self)
    behaviour:AddClick(FlightBetPanel.betReduceBtn.gameObject, function ()
        self:_betReduceFunc()
    end, self)
    behaviour:AddClick(FlightBetPanel.betAddBtn.gameObject, function ()
        self:_betAddFunc()
    end, self)
    FlightBetPanel.timeSlider.onValueChanged:AddListener(function(value)
        self.timeValue = value
        FlightBetPanel.timeValueText.text = self.timeValue
        if value < 0 then
            FlightBetPanel.timeText05.text = GetLanguage(32030011)
        else
            FlightBetPanel.timeText05.text = GetLanguage(32030010)
        end
    end)
    FlightBetPanel.betSlider.onValueChanged:AddListener(function(value)
        self.betValue = value
        FlightBetPanel.betValueText.text = self.betValue
    end)
end
--
function FlightBetCtrl:Refresh()
    Event.AddListener("c_betFlightEvent", self._betFlightEvent, self)

    self:_initPanelData()
end
--
function FlightBetCtrl:Active()
    UIPanel.Active(self)
    self:_language()
end
--
function FlightBetCtrl:_language()
    FlightBetPanel.titleText01.text = GetLanguage(32030008)
    FlightBetPanel.timeText02.text = GetLanguage(32030009)
    FlightBetPanel.timeText03.text = GetLanguage(32030012)
    FlightBetPanel.timeText04.text = GetLanguage(32030013)
    FlightBetPanel.timeText05.text = GetLanguage(32030010)  --延误/提前

    FlightBetPanel.betText06.text = GetLanguage(32030014)
    FlightBetPanel.betText07.text = GetLanguage(32030016)
    FlightBetPanel.betText08.text = GetLanguage(32030017)
    FlightBetPanel.betText09.text = GetLanguage(32030015)
    FlightBetPanel.tipText10.text = GetLanguage(32030018)
end
--
function FlightBetCtrl:Hide()
    Event.RemoveListener("c_betFlightEvent", self._betFlightEvent, self)

    UIPanel.Hide(self)
end
--
function FlightBetCtrl:_betFlightEvent(data)
    UIPanel.ClosePage()
end
--
function FlightBetCtrl:Close()
    UIPanel.Close(self)
end
--
function FlightBetCtrl:_initPanelData()
    FlightBetPanel.timeSlider.minValue = FlightConfig.MinTime
    FlightBetPanel.timeSlider.maxValue = FlightConfig.MaxTime
    FlightBetPanel.timeSlider.value = 0
    self.timeValue = 0
    FlightBetPanel.timeValueText.text = self.timeValue

    FlightBetPanel.betSlider.minValue = FlightConfig.MinBet
    FlightBetPanel.betSlider.maxValue = FlightConfig.MaxBet
    FlightBetPanel.betSlider.value = FlightBetPanel.betSlider.minValue
    self.betValue = FlightBetPanel.betSlider.value
    FlightBetPanel.betValueText.text = self.betValue
end
--
function FlightBetCtrl:_backBtnFunc()
    PlayMusEff(1002)
    UIPanel:ClosePage()
end
--
function FlightBetCtrl:_confirmBtnFunc()
    --发送协议后，等待回调再关闭界面
    --FlightMainModel.m_ReqBetFlight(id, delay, score)
    UIPanel:ClosePage()

    PlayMusEff(1002)
end
--
function FlightBetCtrl:_timeReduceFunc()
    PlayMusEff(1002)
    self.timeValue = self.timeValue - 1
    if self.timeValue < FlightConfig.MinTime then
        self.timeValue = FlightConfig.MinTime
    end
    FlightBetPanel.timeValueText.text = self.timeValue
    FlightBetPanel.timeSlider.value = self.timeValue
end
--
function FlightBetCtrl:_timeAddFunc()
    PlayMusEff(1002)
    self.timeValue = self.timeValue + 1
    if self.timeValue > FlightConfig.MaxTime then
        self.timeValue = FlightConfig.MaxTime
    end
    FlightBetPanel.timeValueText.text = self.timeValue
    FlightBetPanel.timeSlider.value = self.timeValue
end
--
function FlightBetCtrl:_betReduceFunc()
    PlayMusEff(1002)
    self.betValue = self.betValue - 1
    if self.betValue < FlightConfig.MinBet then
        self.betValue = FlightConfig.MinBet
    end
    FlightBetPanel.betValueText.text = self.betValue
    FlightBetPanel.betSlider.value = self.betValue
end
--
function FlightBetCtrl:_betAddFunc()
    PlayMusEff(1002)
    self.betValue = self.betValue + 1
    if self.betValue > FlightConfig.MaxBet then
        self.betValue = FlightConfig.MaxBet
    end
    FlightBetPanel.betValueText.text = self.betValue
    FlightBetPanel.betSlider.value = self.betValue
end