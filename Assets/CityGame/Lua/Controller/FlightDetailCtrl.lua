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
        local flightData
        FlightDetailPanel.infoRoot.localScale = Vector3.zero
        FlightDetailPanel.betBtn.localScale = Vector3.zero
        FlightDetailPanel.resultRoot.localScale = Vector3.zero
        if self.m_data.dataType == 0 then  --热门预测界面
            flightData = self.m_data.detail.data
            self:_hot(self.m_data.detail)
        elseif self.m_data.dataType == 1 then  --历史界面
            flightData = self.m_data.detail.data
            self:_history(self.m_data.detail)
        elseif self.m_data.dataType == 2 then  --从搜索过来的详情
            flightData = self.m_data.detail
            self:_search(self.m_data.detail)
        end
        self.id = flightData.FlightNo
        self.date = flightData.FlightDeptimePlanDate  --bet界面所需数据
        FlightDetailPanel.timeText.text = flightData.FlightDeptimePlanDate  --计划起飞时间 --精确到天
        FlightDetailPanel.flightText.text = flightData.FlightCompany  --需要多语言
        FlightDetailPanel.numText.text = flightData.FlightNo  --CA4506
        FlightDetailPanel.endCodeText.text = flightData.FlightArrcode
        FlightDetailPanel.endPlaceText.text = flightData.FlightArrAirport  --需要多语言
        FlightDetailPanel.startCodeText.text = flightData.FlightDepcode
        FlightDetailPanel.startPlaceText.text = flightData.FlightDepAirport  --需要多语言

        local trueWidth01 = FlightDetailPanel.timeText.preferredWidth
        FlightDetailPanel.timeText.rectTransform.sizeDelta = Vector2.New(trueWidth01, FlightDetailPanel.timeText.rectTransform.sizeDelta.y)
    end
end
--
function FlightDetailCtrl:_hot(value)
    local flightData = value.data
    FlightDetailPanel.hotTran.localScale = Vector3.one
    FlightDetailPanel.historyTran.localScale = Vector3.zero
    flightData = value.data
    FlightDetailPanel.hotMoneyText.text = value.sumBetAmount
    FlightDetailPanel.hotPlanTimeText.text = flightData.FlightDeptimePlanDate  --计划起飞时间 精确到秒
    if flightData.FlightDeptimeDate == "" then
        FlightDetailPanel.hotTrueTimeText.text = "--"
    else
        FlightDetailPanel.hotTrueTimeText.text = flightData.FlightDeptimeDate
    end
    FlightDetailPanel.hotJoinCountText.text = flightData.FlightDepAirport
    local trueWidth02 = FlightDetailPanel.hotMoneyText.preferredWidth
    FlightDetailPanel.hotMoneyText.rectTransform.sizeDelta = Vector2.New(trueWidth02, FlightDetailPanel.hotMoneyText.rectTransform.sizeDelta.y)

    --可押注
    if value.myBet == nil and flightData.FlightState == "计划" then
        FlightDetailPanel.betBtn.localScale = Vector3.one
    end
    --提示已参加预测  --判定需要看具体数据是否为""
    if value.myBet ~= nil and flightData.FlightDeptimeDate == "" then
        FlightDetailPanel.infoRoot.localScale = Vector3.one
        FlightDetailPanel.infoText.text = GetLanguage(32030019, value.myBet.delay, value.myBet.amount)
    end
    --提示航班已过投注时间
    if value.myBet == nil and flightData.FlightDeptimeDate ~= "计划" then
        FlightDetailPanel.infoRoot.localScale = Vector3.one
        FlightDetailPanel.infoText.text = GetLanguage(32030023)
    end
end
--
function FlightDetailCtrl:_history(value)
    local flightData = value.data
    FlightDetailPanel.historyTran.localScale = Vector3.one
    FlightDetailPanel.hotTran.localScale = Vector3.zero
    FlightDetailPanel.historyPlanTimeText.text = flightData.FlightDeptimePlanDate  --计划起飞时间 精确到秒
    if flightData.FlightDeptimeDate == "" then
        FlightDetailPanel.historyTrueTimeText.text = "--"
    else
        FlightDetailPanel.historyTrueTimeText.text = flightData.FlightDeptimeDate
    end

    if value.win == nil then
        FlightDetailPanel.infoRoot.localScale = Vector3.one
        FlightDetailPanel.infoText.text = GetLanguage(32030019, value.delay, value.amount)
        return
    end

    --已经有结果
    if value.win == true then
        FlightDetailPanel.value03Text.text = ""..value.amount  --净赚积分
    else
        FlightDetailPanel.value03Text.text = "-"..value.amount
    end
    local plan = getTimeUnixByFormat(flightData.FlightDeptimePlanDate)
    local ture = getTimeUnixByFormat(flightData.FlightDeptimeDate)
    local delay = (ture - plan) / 60  --只判断分钟

    FlightDetailPanel.value01Text.text = value.delay..GetLanguage(20160005)  --预测延误时间
    FlightDetailPanel.value02Text.text = delay..GetLanguage(20160005)  --实际延误时间
end
--
function FlightDetailCtrl:_search(value)
    local flightData = value
    FlightDetailPanel.historyTran.localScale = Vector3.one
    FlightDetailPanel.hotTran.localScale = Vector3.zero
    FlightDetailPanel.historyPlanTimeText.text = flightData.FlightDeptimePlanDate  --计划起飞时间 精确到秒
    if flightData.FlightDeptimeDate == "" then
        FlightDetailPanel.historyTrueTimeText.text = "--"
    else
        FlightDetailPanel.historyTrueTimeText.text = flightData.FlightDeptimeDate
    end
    --如果没有对应数据，则没下过注
    local tempBet = FlightMainModel.getFlightById(flightData.FlightNo)
    if tempBet ~= nil then
        value.delay = tempBet.delay
        value.amount = tempBet.amount
        value.win = tempBet.win
    else
        if flightData.FlightState == "计划" then
            FlightDetailPanel.betBtn.localScale = Vector3.one  --可以下注
        else
            FlightDetailPanel.infoRoot.localScale = Vector3.one
            FlightDetailPanel.infoText.text = GetLanguage(32030023)
        end
        return
    end

    --还没起飞
    if value.win == nil then
        FlightDetailPanel.infoRoot.localScale = Vector3.one
        FlightDetailPanel.infoText.text = GetLanguage(32030019, value.delay, value.amount)
    else
        --已经有结果
        if value.win == true then
            FlightDetailPanel.value03Text.text = ""..value.amount  --净赚积分
        else
            FlightDetailPanel.value03Text.text = "-"..value.amount
        end
        local plan = getTimeUnixByFormat(flightData.FlightDeptimePlanDate)
        local ture = getTimeUnixByFormat(flightData.FlightDeptimeDate)
        local delay = (ture - plan) / 60  --只判断分钟

        FlightDetailPanel.value01Text.text = value.delay..GetLanguage(20160005)  --预测延误时间
        FlightDetailPanel.value02Text.text = delay..GetLanguage(20160005)  --实际延误时间
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
    FlightDetailPanel.historyPlanTimeText11.text = GetLanguage(32030001)
    FlightDetailPanel.historyTrueTimeText12.text = GetLanguage(32030002)
end
--
function FlightDetailCtrl:backFunc()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--下注，判断自己的钱
function FlightDetailCtrl:betFunc()
    PlayMusEff(1002)
    ct.OpenCtrl("FlightBetCtrl", {id = self.id, date = self.date})
end
--
function FlightDetailCtrl:ruleFunc()
    PlayMusEff(1002)
    ct.OpenCtrl("FlightRuleDialogPageCtrl")
end