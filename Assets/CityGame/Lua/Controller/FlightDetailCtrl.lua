---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/21 10:35
---

FlightDetailCtrl = class('FlightDetailCtrl',UIPanel)
UIPanel:ResgisterOpen(FlightDetailCtrl)

function FlightDetailCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function FlightDetailCtrl:bundleName()
    return "Assets/CityGame/Resources/View/FlightDetailPanel.prefab"
end

function FlightDetailCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function FlightDetailCtrl:Awake(go)
    self.gameObject = go
    local behaviour = self.gameObject:GetComponent('LuaBehaviour')
    behaviour:AddClick(FlightDetailPanel.backBtn.gameObject, function ()
        self:backFunc()
    end , self)
    behaviour:AddClick(FlightDetailPanel.betBtn.gameObject, function ()
        self:betFunc()
    end , self)
    behaviour:AddClick(FlightDetailPanel.ruleBtn.gameObject, function ()
        self:ruleFunc()
    end , self)
end
--
function FlightDetailCtrl:Refresh()
    self:_initData()
end
--
function FlightDetailCtrl:Active()
    UIPanel.Active(self)
    self:_language()
end
--
function FlightDetailCtrl:Hide()
    UIPanel.Hide(self)
end
--
function FlightDetailCtrl:_initData()
    if self.m_data ~= nil then
        local flightData = self.m_data.data

        if self.m_data.dataType == 0 then  --热门预测界面
            flightData = self.m_data.detail.data
        elseif self.m_data.dataType == 1 then  --历史界面

        end

        FlightDetailPanel.moneyText.text = self.m_data.sumBetAmount
        FlightDetailPanel.timeText.text = flightData.FlightDeptimePlanDate  --计划起飞时间 --精确到天
        FlightDetailPanel.flightText.text = flightData.FlightCompany  --需要多语言
        FlightDetailPanel.numText.text = flightData.FlightNo  --CA4506
        FlightDetailPanel.endCodeText.text = flightData.FlightArrcode
        FlightDetailPanel.endPlaceText.text = flightData.FlightArrAirport  --需要多语言
        FlightDetailPanel.startCodeText.text = flightData.FlightDepcode
        FlightDetailPanel.startPlaceText.text = flightData.FlightDepAirport  --需要多语言

        FlightDetailPanel.planTimeText.text = flightData.FlightDeptimePlanDate  --计划起飞时间 精确到秒
        FlightDetailPanel.trueTimeText.text = flightData.FlightDeptimeDate
        FlightDetailPanel.joinCountText.text = flightData.FlightDepAirport

        local trueWidth01 = FlightDetailPanel.timeText.preferredWidth
        FlightDetailPanel.timeText.rectTransform.sizeDelta = Vector2.New(trueWidth01, FlightDetailPanel.timeText.rectTransform.sizeDelta.y)
        local trueWidth02 = FlightDetailPanel.moneyText.preferredWidth
        FlightDetailPanel.moneyText.rectTransform.sizeDelta = Vector2.New(trueWidth02, FlightDetailPanel.moneyText.rectTransform.sizeDelta.y)

        --判断航班状态
        --可押注
        if self.m_data.myBet == nil and flightData.FlightState == "计划" then
            FlightDetailPanel.SetState(0)
            return
        end
        --提示已参加预测  --判定需要看具体数据是否为""
        if self.m_data.myBet ~= nil and flightData.FlightDeptimeDate == "" then
            FlightDetailPanel.SetState(1)
            FlightDetailPanel.infoText.text = GetLanguage(32030019, self.m_data.myBet.delay, self.m_data.myBet.amount)
            return
        end
        --已出结果
        if self.m_data.myBet ~= nil and flightData.FlightDeptimeDate ~= "" then
            FlightDetailPanel.SetState(2)
            local plan = getTimeUnixByFormat(flightData.FlightDeptimePlanDate)
            local ture = getTimeUnixByFormat(flightData.FlightDeptimeDate)
            local delay = (ture - plan) / 60  --只判断分钟
            if delay > 0 then  --延误
                FlightDetailPanel.value03Text.text = ""..self.m_data.myBet.amount  --净赚积分
            end

            FlightDetailPanel.value01Text.text = self.m_data.myBet.delay  --预测延误时间
            FlightDetailPanel.value02Text.text = flightData.FlightDepAirport  --实际延误时间
            return
        end
    end
end
--
function FlightDetailCtrl:_language()
    FlightDetailPanel.titleText01.text = GetLanguage(32030008)
    FlightDetailPanel.planTimeText02.text = GetLanguage(32030001)
    FlightDetailPanel.trueTimeText03.text = GetLanguage(32030002)
    FlightDetailPanel.joinCountText04.text = GetLanguage(32030004)
    FlightDetailPanel.moneyText05.text = GetLanguage(32030005)
    FlightDetailPanel.value01Text06.text = GetLanguage(32030026)
    FlightDetailPanel.value02Text07.text = GetLanguage(32030027)
    FlightDetailPanel.value03Text08.text = GetLanguage(32030028)
    FlightDetailPanel.betBtnText09.text = GetLanguage(32030020)
    FlightDetailPanel.ruleBtnText10.text = GetLanguage(32030029)
end
--
function FlightDetailCtrl:backFunc()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--下注，判断自己的钱
function FlightDetailCtrl:betFunc()
    PlayMusEff(1002)
    ct.OpenCtrl("FlightBetCtrl")
end
--
function FlightDetailCtrl:ruleFunc()
    PlayMusEff(1002)
    ct.OpenCtrl("FlightRuleDialogPageCtrl")
end