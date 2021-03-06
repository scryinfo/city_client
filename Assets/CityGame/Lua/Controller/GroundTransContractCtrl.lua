---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/26 17:29
---GroundTransContractCtrl
GroundTransContractCtrl = class('GroundTransContractCtrl',UIPanel)
UIPanel:ResgisterOpen(GroundTransContractCtrl)

function GroundTransContractCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function GroundTransContractCtrl:bundleName()
    return "Assets/CityGame/Resources/View/GroundTransContractPanel.prefab"
end

function GroundTransContractCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function GroundTransContractCtrl:Awake(go)
    local groundAuctionBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    groundAuctionBehaviour:AddClick(GroundTransContractPanel.backBtn.gameObject, self._backBtnFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransContractPanel.buyBottomBtn.gameObject, self._buyBtnFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransContractPanel.rentBtn.gameObject, self._rentBtnFunc, self)
end

function GroundTransContractCtrl:Refresh()
    self:_initPanelData()
end

function GroundTransContractCtrl:Active()
    UIPanel.Active(self)
    GroundTransContractPanel.tipText.text = "合约"
    --GroundTransContractPanel.AText02.text = GetLanguage(22060007)
    --GroundTransContractPanel.BText03.text = GetLanguage(22060009)
    --GroundTransContractPanel.buyAreaText04.text = GetLanguage(22010002)
    --GroundTransContractPanel.rentAreaText05.text = GetLanguage(22040006)
    --GroundTransContractPanel.rentTenancyText06.text = GetLanguage(22050005)
    --GroundTransContractPanel.rentDailyText07.text = GetLanguage(22050006)
    GroundTransContractPanel.prosperityText.text = GetLanguage(20170003)
    GroundTransContractPanel.priceText.text = GetLanguage(20150001)
    GroundTransContractPanel.minersfeeText.text = "矿工费用:"
    GroundTransContractPanel.minersfeeValue.text = "0.4%"--Temporarily write dead, later changed to read the table
    GroundTransContractPanel.totalText08.text = GetLanguage(22040005)
end

function GroundTransContractCtrl:Hide()
    UIPanel.Hide(self)
    if self.partAAvatar ~= nil then
        AvatarManger.CollectAvatar(self.partAAvatar)
    end
    if self.partBAvatar ~= nil then
        AvatarManger.CollectAvatar(self.partBAvatar)
    end
end

function GroundTransContractCtrl:Close()
    UIPanel.Close(self)
end

---initialization
function GroundTransContractCtrl:_initPanelData()
    if self.m_data then
        self:_setShowState(self.m_data)
    end
end
--Display interface according to status
function GroundTransContractCtrl:_setShowState(data)
    --Just pick a field that is only in the rent state to judge
    if data.rentDay then
        --GroundTransContractPanel.titleText01.text = GetLanguage(22050003)
        --GroundTransContractPanel.rentTipText.text = GetLanguage(22050008)
        --GroundTransContractPanel.chooseState(true)
        --local total = data.groundInfo.rent.rentPreDay * data.rentDay
        --GroundTransContractPanel.rentDailyRentText.text = "E"..getPriceString(GetClientPriceString(data.groundInfo.rent.rentPreDay),30,24)
        --GroundTransContractPanel.totalPriceText.text = "E"..getPriceString(GetClientPriceString(total),48,36)
        --GroundTransContractPanel.rentTenancyText.text = data.rentDay.."d"
        --local nowStr = os.date("%Y/%m/%d %H:%M", TimeSynchronized.GetTheCurrentTime())
        --local endStr = os.date("%Y/%m/%d %H:%M", TimeSynchronized.GetTheCurrentTime() + data.rentDay * 86400)
        --GroundTransContractPanel.rentTenancyTimeText.text = string.format("(%s - %s)", nowStr, endStr)
        --GroundTransContractPanel.BText03.text = GetLanguage(22060006)
    else
        --GroundTransContractPanel.titleText01.text = GetLanguage(22040003)
        --GroundTransContractPanel.chooseState(false)
        --GroundTransContractPanel.BText03.text = GetLanguage(22060009)
    end
    GroundTransContractPanel.titleText01.text = GetLanguage(22040003)
    GroundTransContractPanel.chooseState(false)
    GroundTransContractPanel.prosperityValue.text = data.prosperity
    GroundTransContractPanel.priceValue.text = "E"..GetClientPriceString(data.groundInfo.sell.price)
    GroundTransContractPanel.minersfeeValue.text = "E"..GetClientPriceString(data.groundInfo.sell.price * 0.4)
    GroundTransContractPanel.totalPriceText.text = "E"..GetClientPriceString(data.groundInfo.sell.price + (data.groundInfo.sell.price * 0.4))

    --GroundTransContractPanel.rentAreaText.text = "1x1"
    --GroundTransContractPanel.buyAreaText.text = "1x1"
    if data.ownerInfo ~= nil then
        --A is the owner of the land, B is the contractor-himself
        self.partAAvatar = AvatarManger.GetBigAvatar(data.ownerInfo.faceId, GroundTransContractPanel.APortraitImg.transform,0.5)
        self.partBAvatar = AvatarManger.GetBigAvatar(DataManager.GetMyPersonalHomepageInfo().faceId, GroundTransContractPanel.BPortraitImg.transform,0.5)
        GroundTransContractPanel.AText02.text = data.ownerInfo.companyName
        GroundTransContractPanel.BText03.text = DataManager.GetCompanyName()
        GroundTransContractPanel.ANameText.text = data.ownerInfo.name
        GroundTransContractPanel.BNameText.text = DataManager.GetMyPersonalHomepageInfo().name
    end
end

---Button method
--Click elsewhere to close the entire stack and open the main interface
function GroundTransContractCtrl:_closeBtnFunc()
    PlayMusEff(1002)
    GroundTransSetPriceCtrl._closeBackToMain()
end
--Back button
function GroundTransContractCtrl:_backBtnFunc()
    PlayMusEff(1002)
    UIPanel:ClosePage()
end

--Click the buy button
function GroundTransContractCtrl:_buyBtnFunc(ins)
    PlayMusEff(1002)
    if ins.m_data.groundInfo.sell.price then
        if ins.m_data.groundInfo.sell.price > DataManager.GetMoney() then
            Event.Brocast("SmallPop", GetLanguage(41010006), 300)
            GroundTransSetPriceCtrl._closeBackToMain()
            return
        end
        GroundTransModel.m_ReqBuyGround(ins.m_data.groundInfo.sell.price)
        GroundTransSetPriceCtrl._closeBackToMain()
    end
end
--Click the rent button
--function GroundTransContractCtrl:_rentBtnFunc(ins)
--    PlayMusEff(1002)
--    if ins.m_data.groundInfo.rent then
--        if ins.m_data.groundInfo.rent.rentPreDay * ins.m_data.rentDay > DataManager.GetMoney() then
--            Event.Brocast("SmallPop", GetLanguage(41010006), 300)
--            GroundTransSetPriceCtrl._closeBackToMain()
--            return
--        end
--        GroundTransModel.m_ReqRentGround(ins.m_data.groundInfo.rent, ins.m_data.rentDay)
--        GroundTransSetPriceCtrl._closeBackToMain()
--    end
--end