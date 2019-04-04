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
function BuildingSignDetailPart:PrefabName()
    return "BuildingSignDetailPart"
end
--
function  BuildingSignDetailPart:_InitEvent()
    --DataManager.ModelRegisterNetMsg(nil, "gscode.OpCode", "queryIndustryWages", "gs.QueryIndustryWages", self._getStandardWage, self)
end
--
function BuildingSignDetailPart:_InitClick(mainPanelLuaBehaviour)
    --self.timeSlider.onValueChanged:AddListener(function (value)
    --
    --end)

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
end
--
function BuildingSignDetailPart:_ResetTransform()
    --self.totalText.text = "E0.0000"

    self.timeSlider.value = 0
    self:_language()
    self:_setTextSuitableWidth()
end
--
function BuildingSignDetailPart:_RemoveEvent()
    --DataManager.ModelNoneInsIdRemoveNetMsg("gscode.OpCode", "queryIndustryWages", self)
end
--
function BuildingSignDetailPart:_RemoveClick()
    self.timeSlider.onValueChanged:RemoveAllListeners()
    self.closeBtn.onClick:RemoveAllListeners()
    self.selfSignDelBtn.onClick:RemoveAllListeners()
    self.settingBtn.onClick:RemoveAllListeners()
    self.otherSignBtn.onClick:RemoveAllListeners()
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
    self.waitToSignTotalPriceText = transform:Find("root/stateRoot/waitToSign/otherSeeTotal"):GetComponent("Text")  --如果是自己，就
    self.waitToSignTotalPriceText10 = transform:Find("root/stateRoot/waitToSign/otherSeeTotal/totalPriceText"):GetComponent("Text")
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
end
--签约者信息
function BuildingSignDetailPart:_getSignerInfo(info)
    local data = info[1]
    if data ~= nil then
        self.signerInfo = info
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
        if contractInfo.contract.signId == DataManager.GetMyOwnerID() then
            if self.m_data.info.ownerId == DataManager.GetMyOwnerID() then
                self:_toggleShowState(BuildingSignDetailPart.EOpenState.SelfSigningSelfOpen)
                self.selfSignDelBtn.transform.localScale = Vector3.one

            else
                self:_toggleShowState(BuildingSignDetailPart.EOpenState.SelfSigningOtherOpen)
                self.selfSignDelBtn.transform.localScale = Vector3.zero
            end

            self.selfSignLiftText.text = contractInfo.contract.lift.."%"
            self.selfSignUsedTimeText.text = self:_getSuitableHourStr(contractInfo.contract.lift / 3600)
        else
            --别人签
            local hours = contractInfo.contract.hours
            self.otherSignTimeText.text = self:_getSuitableHourStr(hours)
            local usedHour = (TimeSynchronized.GetTheCurrentTime() - contractInfo.contract.startTs) / 3600
            self.timeSlider.value = usedHour / hours
            local usedStr = self:_getSuitableHourStr(usedHour)
            self.usedTimeText.text = usedStr
            --如果显示的文字超过slider的显示位置，则靠右显示
            if self.usedTimeText.rectTransform.preferredWidth > self.timeSlider.value * 305 then
                self.usedTimeSmallText.text = usedStr
                self.usedTimeSmallText.transform.localScale = Vector3.one
                self.usedTimeText.transform.localScale = Vector3.one
            else
                self.usedTimeSmallText.transform.localScale = Vector3.one
            end

            if self.m_data.info.ownerId == DataManager.GetMyOwnerID() then
                self:_toggleShowState(BuildingSignDetailPart.EOpenState.OtherSigningSignerOpen)
                self.selfSee.localScale = Vector3.one
                self.otherSee.localScale = Vector3.zero
                self.selfSeeUnitPriceText.text = GetClientPriceString(contractInfo.contract.price)
                self.selfSeeLiftText.text = contractInfo.contract.lift.."%"
            else
                self:_toggleShowState(BuildingSignDetailPart.EOpenState.OtherSigningThirdOpen)
                self.otherSee.localScale = Vector3.one
                self.selfSee.localScale = Vector3.zero
                self.otherSeeLiftText.text = contractInfo.contract.lift.."%"
            end

        end
    else
        --待签约状态
        if contractInfo.price ~= nil and contractInfo.hours ~= nil then
            if self.m_data.info.ownerId == DataManager.GetMyOwnerID() then
                self:_toggleShowState(BuildingSignDetailPart.EOpenState.WaitSignSelfOpen)
            else
                self:_toggleShowState(BuildingSignDetailPart.EOpenState.WaitSignOtherOpen)
            end
            local price = contractInfo.price
            self.waitToSignPriceText.text = GetClientPriceString(price).."/h"
            self.waitToSignSignTime.text = contractInfo.hours.."h"
            self.waitToSignTotalPriceText.text = GetClientPriceString(price * contractInfo.hours)
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
    --打开签约界面  --暂时没有
    --直接发送签约请求
end
--
function BuildingSignDetailPart:clickSelfSignDelBtn()
    --打开弹窗
    --请求删除签约
end
--
function BuildingSignDetailPart:clickCloseBtn()
    self.groupClass.TurnOffAllOptions(self.groupClass)
end
