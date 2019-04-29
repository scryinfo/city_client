---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---建筑主界面签约
BuildingSignDetailPart = class('BuildingSignDetailPart', BasePartDetail)
--
BuildingSignDetailPart.EOpenState =
{
    SelfNotSet = 1,  --自己尚未设置签约
    WaitSignSelfOpen = 2,  --自己设置了，查看
    WaitSignOtherOpen = 3,  --自己设置了，别人查看
    SelfSigningSelfOpen = 4,  --自己签自己，查看
    SelfSigningOtherOpen = 5,  --自己签自己，别人
    OtherSigningSignerOpen = 6,  --其他人签约，签约者查看
    OtherSigningThirdOpen = 7,  --其他人签约，非签约者或建筑拥有者查看
}
--
BuildingSignDetailPart.BtnDisSelectColor = Vector3.New(46, 58, 100)
BuildingSignDetailPart.BtnSelectColor = Vector3.New(255, 255, 255)
--
function BuildingSignDetailPart:PrefabName()
    return "BuildingSignDetailPart"
end
--
function BuildingSignDetailPart:Show(data)
    BasePartDetail.Show(self)
    self.m_data = data
    self:_initFunc()
    --只在打开界面的时候刷新数据
    self:_toggleBtn(1)
    self:_reqLiftCurve()
end
--
function BuildingSignDetailPart:_InitClick(mainPanelLuaBehaviour)
    mainPanelLuaBehaviour:AddClick(self.closeBtn.gameObject, function ()
        self:clickCloseBtn()
    end , self)
    mainPanelLuaBehaviour:AddClick(self.settingBtn.gameObject, function ()
        self:clickSettingBtn()
    end , self)
    mainPanelLuaBehaviour:AddClick(self.otherSignBtn.gameObject, function ()
        self:clickOtherSignBtn()
    end , self)
    mainPanelLuaBehaviour:AddClick(self.selfSignDelBtn.gameObject, function ()
        self:clickSelfSignDelBtn()
    end , self)
    --
    mainPanelLuaBehaviour:AddClick(self.tipClose01Btn.gameObject, function ()
        self:clickTipBtn()
    end , self)
    mainPanelLuaBehaviour:AddClick(self.tipClose02Btn.gameObject, function ()
        self:clickTipBtn()
    end , self)
    mainPanelLuaBehaviour:AddClick(self.infoBtn.gameObject, function ()
        self:clickOpenTipBtn()
    end , self)

    --
    mainPanelLuaBehaviour:AddClick(self.liftBtn.gameObject, function ()
        self:clickLiftBtn()
    end , self)
    mainPanelLuaBehaviour:AddClick(self.npcBtn.gameObject, function ()
        self:clickNpcBtn()
    end , self)
end
--
function BuildingSignDetailPart:_ResetTransform()
    self.timeSlider.value = 0
    self.tipRoot.localScale = Vector3.zero
    self:_language()
    self:_setTextSuitableWidth()

    self.curve.anchoredPosition = Vector3.New(-1302, 62,0)
    self.curve.sizeDelta = Vector2.New(2814, 260)  --MaxWidth

    --
    self.liftCurveData = nil
    self.npcCurveData = nil
end
--
function BuildingSignDetailPart:_RemoveClick()
    self.timeSlider.onValueChanged:RemoveAllListeners()
    self.closeBtn.onClick:RemoveAllListeners()
    self.selfSignDelBtn.onClick:RemoveAllListeners()
    self.settingBtn.onClick:RemoveAllListeners()
    self.otherSignBtn.onClick:RemoveAllListeners()
    self.liftBtn.onClick:RemoveAllListeners()
    self.npcBtn.onClick:RemoveAllListeners()
end
--
function BuildingSignDetailPart:_InitEvent()
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryBuildingFlow","ss.BuildingFlow", self.n_OnGetNpcCurve, self)
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryBuildingLift","ss.BuildingLift", self.n_OnGetLiftCurve, self)
end
--
function BuildingSignDetailPart:_RemoveEvent()
    DataManager.ModelNoneInsIdRemoveNetMsg("sscode.OpCode", "queryBuildingFlow", self)
    DataManager.ModelNoneInsIdRemoveNetMsg("sscode.OpCode", "queryBuildingLift", self)
end
--
function BuildingSignDetailPart:RefreshData(data)
    self:_ResetTransform()
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
end
--
function BuildingSignDetailPart:_InitTransform()
    self:_getComponent(self.transform)
    self.curve.anchoredPosition = Vector3.New(-1302, 62,0)
    self.curve.sizeDelta = Vector2.New(2814, 260)  --MaxWidth
end
--
function BuildingSignDetailPart:_getComponent(transform)
    if transform == nil then
        return
    end
    self.closeBtn = transform:Find("root/closeBtn"):GetComponent("Button")
    self.settingBtn = transform:Find("root/settingBtn"):GetComponent("Button")
    self.otherSignBtn = transform:Find("root/otherSignBtn"):GetComponent("Button")

    self.selfNotSet = transform:Find("root/stateRoot/selfNotSet")  --还未设置签约，自己查看
    self.selfNotSetText01 = transform:Find("root/stateRoot/selfNotSet/Text"):GetComponent("Text")
    self.signingState = transform:Find("root/stateRoot/signing")  --正在签约
    self.signerPortrait = transform:Find("root/stateRoot/signing/protaitRoot/bg/Image")  --签约者头像
    self.signerNameText = transform:Find("root/stateRoot/signing/infoBg/nameText"):GetComponent("Text")  --签约者名字
    self.signerCompanyText = transform:Find("root/stateRoot/signing/infoBg/companyText"):GetComponent("Text")  --签约者公司名
    --非建筑拥有者签约，查看
    self.otherSign = transform:Find("root/stateRoot/signing/otherSign")  --
    self.otherSignTimeText = transform:Find("root/stateRoot/signing/otherSign/signTime/signTimeText"):GetComponent("Text")
    self.otherSignTimeText02 = transform:Find("root/stateRoot/signing/otherSign/signTime"):GetComponent("Text")
    self.timeSlider = transform:Find("root/stateRoot/signing/otherSign/timeSlider"):GetComponent("Slider")
    self.usedTimeText = transform:Find("root/stateRoot/signing/otherSign/timeSlider/Fill Area/Fill/timeText"):GetComponent("Text")  --已经使用了的时间
    self.usedTimeSmallText = transform:Find("root/stateRoot/signing/otherSign/timeSlider/Fill Area/Fill/smallTimeText"):GetComponent("Text")  --已经使用过的时间，小

    self.selfSee = transform:Find("root/stateRoot/signing/otherSign/selfSee")  --私有信息，只向建筑主人和签约人展示
    self.selfSeeLiftText = transform:Find("root/stateRoot/signing/otherSign/selfSee/lift/liftText"):GetComponent("Text")
    self.selfSeeLiftText03 = transform:Find("root/stateRoot/signing/otherSign/selfSee/lift"):GetComponent("Text")
    self.selfSeeUnitPriceText = transform:Find("root/stateRoot/signing/otherSign/selfSee/unit/unitPriceText"):GetComponent("Text")
    self.selfSeeUnitPriceText04 = transform:Find("root/stateRoot/signing/otherSign/selfSee/unit"):GetComponent("Text")
    self.otherSee = transform:Find("root/stateRoot/signing/otherSign/otherSee")  --公共信息
    self.otherSeeLiftText = transform:Find("root/stateRoot/signing/otherSign/otherSee/lift/liftText"):GetComponent("Text")
    self.otherSeeLiftText05 = transform:Find("root/stateRoot/signing/otherSign/otherSee/lift"):GetComponent("Text")
    --建筑所有人签约，查看
    self.selfSign = transform:Find("root/stateRoot/signing/selfSign")
    self.selfSignLiftText = transform:Find("root/stateRoot/signing/selfSign/lift/liftText"):GetComponent("Text")  --加成
    self.selfSignLiftText06 = transform:Find("root/stateRoot/signing/selfSign/lift"):GetComponent("Text")
    self.selfSignUsedTimeText = transform:Find("root/stateRoot/signing/selfSign/usedTime/usedTimeText"):GetComponent("Text")  --已经加成的时间
    self.selfSignUsedTimeText07 = transform:Find("root/stateRoot/signing/selfSign/usedTime"):GetComponent("Text")
    self.selfSignDelBtn = transform:Find("root/stateRoot/signing/selfSign/delBtn"):GetComponent("Button")

    --尚未签约
    self.waitToSign = transform:Find("root/stateRoot/waitToSign")
    self.waitToSignPriceText = transform:Find("root/stateRoot/waitToSign/priceText"):GetComponent("Text")
    self.waitToSignPriceText08 = transform:Find("root/stateRoot/waitToSign/Text01"):GetComponent("Text")
    self.waitToSignSignTime = transform:Find("root/stateRoot/waitToSign/signTime/signTimeText"):GetComponent("Text")
    self.waitToSignSignTime09 = transform:Find("root/stateRoot/waitToSign/signTime"):GetComponent("Text")
    self.waitToSignTotalPriceText = transform:Find("root/stateRoot/waitToSign/otherSeeTotal/totalPriceText"):GetComponent("Text")
    self.waitToSignTotalPriceText10 = transform:Find("root/stateRoot/waitToSign/otherSeeTotal"):GetComponent("Text")

    --提示
    self.infoBtn = transform:Find("root/stateRoot/infoBtn")
    self.tipRoot = transform:Find("root/tipRoot")
    self.tipClose01Btn = transform:Find("root/tipRoot/close01Btn")
    self.tipText11 = transform:Find("root/tipRoot/close01Btn/Text"):GetComponent("Text")
    self.tipClose02Btn = transform:Find("root/tipRoot/close02Btn")

    --曲线图
    self.yScale = transform:Find("root/lineRoot/leftValue")
    self.curve = transform:Find("root/lineRoot/curveBg/curve"):GetComponent("RectTransform")
    self.slide = transform:Find("root/lineRoot/curveBg/curve"):GetComponent("Slide")
    self.graph = transform:Find("root/lineRoot/curveBg/curve"):GetComponent("FunctionalGraph")

    self.liftBtn = transform:Find("root/lineRoot/btnRoot/promotion/btn"):GetComponent("Button")
    self.liftShowBg = transform:Find("root/lineRoot/btnRoot/promotion/showBg")
    self.liftText = transform:Find("root/lineRoot/btnRoot/promotion/Text"):GetComponent("Text")
    self.npcBtn = transform:Find("root/lineRoot/btnRoot/npc/btn"):GetComponent("Button")
    self.npcShowBg = transform:Find("root/lineRoot/btnRoot/npc/showBg")
    self.npcText = transform:Find("root/lineRoot/btnRoot/npc/Text"):GetComponent("Text")
end
--如果传入1，则选中liftBtn，2选中npcBtn
function BuildingSignDetailPart:_toggleBtn(index)
    if index == 1 then
        self.liftShowBg.localScale = Vector3.one
        self.npcShowBg.localScale = Vector3.zero
        self.liftText.color = getColorByVector3(BuildingSignDetailPart.BtnSelectColor)
        self.npcText.color = getColorByVector3(BuildingSignDetailPart.BtnDisSelectColor)
    elseif index == 2 then
        self.liftShowBg.localScale = Vector3.zero
        self.npcShowBg.localScale = Vector3.one
        self.liftText.color = getColorByVector3(BuildingSignDetailPart.BtnDisSelectColor)
        self.npcText.color = getColorByVector3(BuildingSignDetailPart.BtnSelectColor)
    end
end
--text调整宽度，放在多语言之后
function BuildingSignDetailPart:_setTextSuitableWidth()
    self.otherSignTimeText02.rectTransform.sizeDelta = Vector2.New(self.otherSignTimeText02.preferredWidth, self.otherSignTimeText02.rectTransform.sizeDelta.y)
    self.selfSeeLiftText03.rectTransform.sizeDelta = Vector2.New(self.selfSeeLiftText03.preferredWidth, self.selfSeeLiftText03.rectTransform.sizeDelta.y)
    self.selfSeeUnitPriceText04.rectTransform.sizeDelta = Vector2.New(self.selfSeeUnitPriceText04.preferredWidth, self.selfSeeUnitPriceText04.rectTransform.sizeDelta.y)
    self.otherSeeLiftText05.rectTransform.sizeDelta = Vector2.New(self.otherSeeLiftText05.preferredWidth, self.otherSeeLiftText05.rectTransform.sizeDelta.y)
    self.selfSignLiftText06.rectTransform.sizeDelta = Vector2.New(self.selfSignLiftText06.preferredWidth, self.selfSignLiftText06.rectTransform.sizeDelta.y)
    self.waitToSignSignTime09.rectTransform.sizeDelta = Vector2.New(self.waitToSignSignTime09.preferredWidth, self.waitToSignSignTime09.rectTransform.sizeDelta.y)
end
--
function BuildingSignDetailPart:_language()
    self.selfNotSetText01.text = "尚未设置签约:"
    self.otherSignTimeText02.text = "签约时间:"
    self.selfSeeLiftText03.text = "平均人流量加成:"
    self.selfSeeUnitPriceText04.text = "单价:"
    self.otherSeeLiftText05.text = "平均人流量加成:"
    self.selfSignLiftText06.text = "平均人流量加成:"
    self.selfSignUsedTimeText07.text = "已加成时间:"
    self.waitToSignPriceText08.text = "单价:"
    self.waitToSignSignTime09.text = "签约时间:"
    self.waitToSignTotalPriceText10.text = "总价:"
    self.tipText11.text = "Human traffic can improve the promotion ability of the promotion company!"
end
--
function BuildingSignDetailPart:_createCurve(info)
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
                    turnoverTab[i].flow = tonumber(GetClientPriceString(v.flow))
                end
            end
        end

        updataTime = updataTime + 3600
    end

    local turnover = {}
    for i, v in ipairs(turnoverTab) do
        turnover[i] = Vector2.New(v.coordinate,v.flow)  --
    end
    table.insert(time,1,"0")
    table.insert(boundaryLine,1,0)
    table.insert(turnover,1,Vector2.New(0,0))
    local max = 0
    for i, v in ipairs(turnover) do
        if v.y > max then
            max = v.y
        end
    end
    local scale = SetYScale(max,5,self.yScale)
    local turnoverVet = {}
    for i, v in ipairs(turnover) do
        if scale == 0 then
            turnoverVet[i] = v
        else
            if scale == 0 then
                turnoverVet[i] = Vector2.New(v.x, v.y)
            else
                turnoverVet[i] = Vector2.New(v.x,v.y / scale * 63)
            end
        end
    end
    self.slide:SetXScaleValue(time,118)
    self.graph:BoundaryLine(boundaryLine)

    self.graph:DrawLine(turnoverVet, getColorByInt(53, 72, 117))
    local temp1 = {[1] = turnoverVet[#turnoverVet]}
    local temp2 = {[1] = turnover[#turnover]}
    self.slide:SetCoordinate(temp1, temp2, Color.white)

    self.curve.localPosition = self.curve.localPosition + Vector3.New(0.01, 0,0)
    self.curve.sizeDelta = self.curve.sizeDelta + Vector2.New(0.01, 0)
end
--签约者信息
function BuildingSignDetailPart:_getSignerInfo(info)
    local data = info[1]
    if data ~= nil then
        self.signerInfo = data
        self.avatar = AvatarManger.GetSmallAvatar(self.signerInfo.faceId, self.signerPortrait.transform,0.2)
        self.signerNameText.text = self.signerInfo.name
        self.signerCompanyText.text = self.signerInfo.companyName
    end
end
--
function BuildingSignDetailPart:_initFunc()
    if self.m_data.contractInfo == nil then
        return
    end
    --
    local contractInfo = self.m_data.contractInfo
    --有人签约
    if contractInfo.contract ~= nil then
        PlayerInfoManger.GetInfos({[1] = contractInfo.contract.signId}, self._getSignerInfo, self)

        --自己签自己
        if contractInfo.contract.signId == self.m_data.info.ownerId then
            if self.m_data.info.ownerId == DataManager.GetMyOwnerID() then
                self:_toggleShowState(BuildingSignDetailPart.EOpenState.SelfSigningSelfOpen)
                self.selfSignDelBtn.transform.localScale = Vector3.one

            else
                self:_toggleShowState(BuildingSignDetailPart.EOpenState.SelfSigningOtherOpen)
                self.selfSignDelBtn.transform.localScale = Vector3.zero
            end

            self.selfSignLiftText.text = self:_getSuitableLiftStr(contractInfo.contract.lift)
            self.selfSignUsedTimeText.text = self:_getSuitableHourStr(contractInfo.contract.hours)
            self.otherSign.localScale = Vector3.zero
            self.selfSign.localScale = Vector3.one
        else
            --别人签
            self.otherSign.localScale = Vector3.one
            self.selfSign.localScale = Vector3.zero

            local hours = contractInfo.contract.hours
            self.otherSignTimeText.text = self:_getSuitableHourStr(hours)
            local usedHour = (TimeSynchronized.GetTheCurrentServerTime() - contractInfo.contract.startTs) / 3600 / 1000
            self.timeSlider.value = usedHour / hours
            local usedStr = self:_getSuitableHourStr(usedHour)
            self.usedTimeText.text = usedStr
            --如果显示的文字超过slider的显示位置，则靠右显示
            if self.usedTimeText.preferredWidth > self.timeSlider.value * 305 then
                self.usedTimeSmallText.text = usedStr
                self.usedTimeSmallText.transform.localScale = Vector3.one
                self.usedTimeText.transform.localScale = Vector3.zero
            else
                self.usedTimeSmallText.transform.localScale = Vector3.zero
                self.usedTimeText.transform.localScale = Vector3.one
            end

            if self.m_data.info.ownerId == DataManager.GetMyOwnerID() or contractInfo.contract.signId == DataManager.GetMyOwnerID() then
                self:_toggleShowState(BuildingSignDetailPart.EOpenState.OtherSigningSignerOpen)
                self.selfSee.localScale = Vector3.one
                self.otherSee.localScale = Vector3.zero
                self.selfSeeUnitPriceText.text = "E"..GetClientPriceString(contractInfo.contract.price)
                self.selfSeeLiftText.text = self:_getSuitableLiftStr(contractInfo.contract.lift)
            else
                self:_toggleShowState(BuildingSignDetailPart.EOpenState.OtherSigningThirdOpen)
                self.otherSee.localScale = Vector3.one
                self.selfSee.localScale = Vector3.zero
                self.otherSeeLiftText.text = self:_getSuitableLiftStr(contractInfo.contract.lift)
            end

        end
    else
        --待签约状态
        if contractInfo.price ~= nil and contractInfo.hours ~= nil then
            local tempHours = contractInfo.hours
            if self.m_data.info.ownerId == DataManager.GetMyOwnerID() then
                self:_toggleShowState(BuildingSignDetailPart.EOpenState.WaitSignSelfOpen)
            else
                self:_toggleShowState(BuildingSignDetailPart.EOpenState.WaitSignOtherOpen)
            end
            local price = contractInfo.price
            self.waitToSignPriceText.text = "E"..GetClientPriceString(price).."/h"
            self.waitToSignSignTime.text = tempHours.."h"
            self.waitToSignTotalPriceText.text = "E"..GetClientPriceString(price * tempHours)
        else
            --尚未设置签约信息
            self:_toggleShowState(BuildingSignDetailPart.EOpenState.SelfNotSet)
        end
    end
end
--
function BuildingSignDetailPart:_getSuitableHourStr(hours)
    local hour
    local showStr
    if hours < 1 then
        showStr = "<1h"
        return showStr
    end

    local day = math.floor(hours / 24)
    if day >= 1 then
        hour = hours - 24 * day
        showStr = day.."d "..hour.."h"
    else
        hour = hours
        showStr = hour.."h"
    end
    return showStr
end
--
function BuildingSignDetailPart:_getSuitableLiftStr(liftValue)
    local liftTemp = string.format("%0.2f", liftValue).."%"
    return liftTemp
end
--
function BuildingSignDetailPart:_toggleShowState(state)
    self.settingBtn.transform.localScale = Vector3.zero
    self.otherSignBtn.transform.localScale = Vector3.zero

    if state == BuildingSignDetailPart.EOpenState.SelfNotSet then
        self.settingBtn.transform.localScale = Vector3.one

        self.selfNotSet.transform.localScale = Vector3.one
        self.signingState.transform.localScale = Vector3.zero
        self.waitToSign.transform.localScale = Vector3.zero
    elseif state == BuildingSignDetailPart.EOpenState.WaitSignSelfOpen then
        self.settingBtn.transform.localScale = Vector3.one

        self.waitToSign.transform.localScale = Vector3.one
        self.selfNotSet.transform.localScale = Vector3.zero
        self.signingState.transform.localScale = Vector3.zero
    elseif state == BuildingSignDetailPart.EOpenState.WaitSignOtherOpen then
        self.otherSignBtn.transform.localScale = Vector3.one

        self.waitToSign.transform.localScale = Vector3.one
        self.selfNotSet.transform.localScale = Vector3.zero
        self.signingState.transform.localScale = Vector3.zero
    elseif state == BuildingSignDetailPart.EOpenState.SelfSigningSelfOpen or state == BuildingSignDetailPart.EOpenState.SelfSigningOtherOpen then
        self.signingState.transform.localScale = Vector3.one
        self.selfNotSet.transform.localScale = Vector3.zero
        self.waitToSign.transform.localScale = Vector3.zero

    elseif state == BuildingSignDetailPart.EOpenState.OtherSigningSignerOpen or state == BuildingSignDetailPart.EOpenState.OtherSigningThirdOpen then
        self.signingState.transform.localScale = Vector3.one
        self.selfNotSet.transform.localScale = Vector3.zero
        self.waitToSign.transform.localScale = Vector3.zero
    end
end
--
function BuildingSignDetailPart:clickSettingBtn()
    ct.OpenCtrl("BuildingSignSetDialogPageCtrl", self.m_data)
end
--
function BuildingSignDetailPart:clickOtherSignBtn()
    --打开签约界面
    ct.OpenCtrl("SignContractCtrl", self.m_data)
end
--
function BuildingSignDetailPart:clickSelfSignDelBtn()
    --打开弹窗
    --请求删除签约
    self:m_ReqSelfCancelContract(self.m_data.info.id)
end
--
function BuildingSignDetailPart:clickCloseBtn()
    self.groupClass.TurnOffAllOptions(self.groupClass)
end
--点击提示按钮
function BuildingSignDetailPart:clickOpenTipBtn()
    self.tipRoot.localScale = Vector3.one
end
--点击liftBtn
function BuildingSignDetailPart:clickLiftBtn()
    if self.liftCurveData == nil then
        self:_reqLiftCurve()
    else
        self:_createCurve(self.liftCurveData)
    end
    self:_toggleBtn(1)
end
--点击npcBtn
function BuildingSignDetailPart:clickNpcBtn()
    if self.npcCurveData == nil then
        self:_reqNpcCurve()
    else
        self:_createCurve(self.npcCurveData)
    end
    self:_toggleBtn(2)
end
---------------------------------------------------------------------------------------
--自己取消签约
function BuildingSignDetailPart:m_ReqSelfCancelContract(buildingId)
    local msgId = pbl.enum("gscode.OpCode","cancelContract")
    local pMsg = assert(pbl.encode("gs.Id", {id = buildingId}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--签约按钮
function BuildingSignDetailPart:m_ReqContract(buildingId, price, hours)
    local msgId = pbl.enum("gscode.OpCode","signContract")
    local pMsg = assert(pbl.encode("gs.SignContract", {buildingId = buildingId, price = price, hours = hours}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--请求人流量曲线
function BuildingSignDetailPart:_reqNpcCurve()
    local msgId = pbl.enum("sscode.OpCode","queryBuildingFlow")
    local lMsg = { id = self.m_data.info.id }
    local pMsg = assert(pbl.encode("ss.Id", lMsg))
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, pMsg, CityEngineLua._tradeNetworkInterface1)
end
--请求签约加成曲线
function BuildingSignDetailPart:_reqLiftCurve()
    local msgId = pbl.enum("sscode.OpCode","queryBuildingLift")
    local lMsg = { id = self.m_data.info.id }
    local pMsg = assert(pbl.encode("ss.Id", lMsg))
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, pMsg, CityEngineLua._tradeNetworkInterface1)
end
---------------------------------------------------------------------------------------
--人流量曲线
function BuildingSignDetailPart:n_OnGetNpcCurve(info)
    self.npcCurveData = info
    self:_createCurve(info)
end
--签约加成曲线
function BuildingSignDetailPart:n_OnGetLiftCurve(info)
    self.liftCurveData = info
    self:_createCurve(info)
end
