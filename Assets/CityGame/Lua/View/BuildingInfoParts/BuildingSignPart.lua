---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---建筑主界面调整工资底部
BuildingSignPart = class('BuildingSignPart', BasePart)
--
BuildingSignPart.ESignState =
{
    NotSet = 1,  --未设置未开启
    Signing = 2,  --签约中
    WaitToSign = 3,  --等待签约
}
--
function BuildingSignPart:PrefabName()
    return "BuildingSignPart"
end
--
function BuildingSignPart:GetDetailClass()
    return BuildingSignDetailPart
end
--
function  BuildingSignPart:_ResetTransform()
    self:toggleSignState()
    self:_language()
end
--
function BuildingSignPart:_InitTransform()
    self:_getComponent(self.transform)
end
--
function BuildingSignPart:_InitChildClick(mainPanelLuaBehaviour)
    mainPanelLuaBehaviour:AddClick(self.notSetBtn.gameObject, function ()
        self:clickNotSetSignBtn()
    end , self)
end
--
function BuildingSignPart:_RemoveChildClick()
    self.notSetBtn.onClick:RemoveAllListeners()
end
--
function BuildingSignPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
end
--
function BuildingSignPart:_getComponent(transform)
    self.waitToSign = transform:Find("Top/waitToSign")
    self.waitToSignPriceText = transform:Find("Top/waitToSign/priceText"):GetComponent("Text")
    self.waitToSignTimeText = transform:Find("Top/waitToSign/signTimeText"):GetComponent("Text")
    self.signing = transform:Find("Top/signing")
    self.signingText01 = transform:Find("Top/signing/Text"):GetComponent("Text")
    self.signingCompanyText = transform:Find("Top/signing/companyText"):GetComponent("Text")
    self.notSet = transform:Find("Top/notSet")
    self.notSetText02 = transform:Find("Top/notSet/Text"):GetComponent("Text")
    self.notSetBtn = transform:Find("notSetBtn"):GetComponent("Button")
    --
    self.unSelectText03 = transform:Find("UnselectBtn/Text"):GetComponent("Text")
    self.selectText04 = transform:Find("SelectBtn/Text"):GetComponent("Text")
end
--
function BuildingSignPart:_initFunc()
    if self.m_data.contractInfo == nil then
        return
    end
    local contractInfo = self.m_data.contractInfo
    if contractInfo.isOpen == false then
        self:toggleSignState(BuildingSignPart.ESignState.NotSet)
        --如果是其他人进入建筑则不能点开详情
        if self.m_data.info.ownerId ~= DataManager.GetMyOwnerID() then
            self.notSetBtn.transform.localScale = Vector3.one
        end
    else
        --等待签约
        if contractInfo.contract == nil then
            self:toggleSignState(BuildingSignPart.ESignState.WaitToSign)
            local price = GetClientPriceString(contractInfo.price)
            self.waitToSignPriceText.text = string.format("%s: <color=#ffc926><size=30>E%s</size></color>", GetLanguage(12345678), price)
            self.waitToSignTimeText.text = string.format("%s: <color=#91c5ff><size=30>%dh</size></color>", GetLanguage(12345678), contractInfo.hours)
        else
            self:toggleSignState(BuildingSignPart.ESignState.Signing)
            PlayerInfoManger.GetInfos({[1] = contractInfo.contract.signId}, self._getSignerInfo, self)
        end
    end
end
--
function BuildingSignPart:_language()
    self.signingText01.text = "签约公司:"
    self.notSetText02.text = "暂未开启签约"
    self.unSelectText03.text = "签约"
    self.selectText04.text = "签约"

    local trueTextW01 = self.unSelectText03.preferredWidth
    self.unSelectText03.rectTransform.sizeDelta = Vector2.New(trueTextW01, self.unSelectText03.rectTransform.sizeDelta.y)
    local trueTextW02 = self.selectText04.preferredWidth
    self.selectText04.rectTransform.sizeDelta = Vector2.New(trueTextW02, self.selectText04.rectTransform.sizeDelta.y)
end
--签约者信息
function BuildingSignPart:_getSignerInfo(info)
    local data = info[1]
    if data ~= nil then
        self.signerInfo = data
        self.signingCompanyText.text = self.signerInfo.companyName
    end
end
--
function BuildingSignPart:toggleSignState(state)
    self.notSetBtn.transform.localScale = Vector3.zero
    if state == nil then
        self.waitToSign.localScale = Vector3.zero
        self.signing.localScale = Vector3.zero
        self.notSet.localScale = Vector3.zero
        return
    end

    if state == BuildingSignPart.ESignState.NotSet then
        self.notSet.localScale = Vector3.one
        self.waitToSign.localScale = Vector3.zero
        self.signing.localScale = Vector3.zero

    elseif state == BuildingSignPart.ESignState.Signing then
        self.signing.localScale = Vector3.one
        self.notSet.localScale = Vector3.zero
        self.waitToSign.localScale = Vector3.zero

    elseif state == BuildingSignPart.ESignState.WaitToSign then
        self.waitToSign.localScale = Vector3.one
        self.signing.localScale = Vector3.zero
        self.notSet.localScale = Vector3.zero
    end
end
--
function BuildingSignPart:clickNotSetSignBtn()
    Event.Brocast("SmallPop", "尚未开启签约", 300)
end