---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/26 17:29
---SignContractCtrl
SignContractCtrl = class('SignContractCtrl',UIPanel)
UIPanel:ResgisterOpen(SignContractCtrl)

function SignContractCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function SignContractCtrl:bundleName()
    return "Assets/CityGame/Resources/View/SignContractPanel.prefab"
end

function SignContractCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function SignContractCtrl:Awake(go)
    local behaviour = self.gameObject:GetComponent('LuaBehaviour')
    behaviour:AddClick(SignContractPanel.backBtn.gameObject, self._backBtnFunc, self)
    behaviour:AddClick(SignContractPanel.confirmBtn.gameObject, function ()
        self:_confirmFunc()
    end , self)
end

function SignContractCtrl:Refresh()
    self:_initPanelData()
end

function SignContractCtrl:Active()
    UIPanel.Active(self)
    SignContractPanel.titleText01.text = "签订合约"
    SignContractPanel.titleText02.text = "人流量推广加成"
    SignContractPanel.ABuildingText03.text = "流量建筑"
    SignContractPanel.BBuildingText04.text = "推广公司"
    SignContractPanel.priceText05.text = "价格"
    SignContractPanel.signHourText06.text = "签约时长"
    SignContractPanel.totalText07.text = "总价"
    SignContractPanel.tipText08.text = "若对方拆除建筑，合约无法继续执行"
end

function SignContractCtrl:Hide()
    UIPanel.Hide(self)
    if self.partAAvatar ~= nil then
        AvatarManger.CollectAvatar(self.partAAvatar)
    end
    if self.partBAvatar ~= nil then
        AvatarManger.CollectAvatar(self.partBAvatar)
    end
end

function SignContractCtrl:Close()
    UIPanel.Close(self)
end

---初始化
function SignContractCtrl:_initPanelData()
    if self.m_data == nil then
        return
    end
    PlayerInfoManger.GetInfos({[1] = self.m_data.info.ownerId}, self._showPartAInfo, self)
    local partBInfo = DataManager.GetMyPersonalHomepageInfo()
    self.partBAvatar = AvatarManger.GetSmallAvatar(partBInfo.faceId, SignContractPanel.BPortraitImg,0.5)
    SignContractPanel.BNameText.text = partBInfo.name
    SignContractPanel.BCompanyText.text = partBInfo.companyName

    SignContractPanel.ABuildingText.text = self.m_data.info.name
    SignContractPanel.BBuildingText.text = partBInfo.companyName
    SignContractPanel.priceText.text = "E"..GetClientPriceString(self.m_data.contractInfo.price)
    SignContractPanel.signHourText.text = self.m_data.contractInfo.hours.."h"
    local total = self.m_data.contractInfo.price * self.m_data.contractInfo.hours
    SignContractPanel.totalPriceText.text = "E"..GetClientPriceString(total)
end
--
function SignContractCtrl:_showPartAInfo(info)
    local data = info[1]
    if data ~= nil then
        self.partAAvatar = AvatarManger.GetSmallAvatar(data.faceId, SignContractPanel.APortraitImg,0.5)
        SignContractPanel.ANameText.text = data.name
        SignContractPanel.ACompanyText.text = data.companyName
    end
end
--返回按钮
function SignContractCtrl:_backBtnFunc()
    PlayMusEff(1002)
    UIPanel:ClosePage()
end
--确认按钮
function SignContractCtrl:_confirmFunc()
    PlayMusEff(1002)
    local needPrice = self.m_data.contractInfo.price * self.m_data.contractInfo.hours
    if DataManager.GetMoney() >= needPrice then
        UIPanel:ClosePage()
        self:m_ReqContract(self.m_data.info.id, self.m_data.contractInfo.price, self.m_data.contractInfo.hours)
    else
        Event.Brocast("SmallPop", "您的钱不够", 300)
    end
end
--签约
function SignContractCtrl:m_ReqContract(buildingId, price, hours)
    local msgId = pbl.enum("gscode.OpCode","signContract")
    local pMsg = assert(pbl.encode("gs.SignContract", {buildingId = buildingId, price = price, hours = hours}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end