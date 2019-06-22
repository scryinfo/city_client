---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/26 17:29
---
GroundTransRentAndBuyCtrl = class('GroundTransRentAndBuyCtrl',UIPanel)
UIPanel:ResgisterOpen(GroundTransRentAndBuyCtrl)

function GroundTransRentAndBuyCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function GroundTransRentAndBuyCtrl:bundleName()
    return "Assets/CityGame/Resources/View/GroundTransRentAndBuyPanel.prefab"
end

function GroundTransRentAndBuyCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function GroundTransRentAndBuyCtrl:Awake(go)
    local groundAuctionBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    groundAuctionBehaviour:AddClick(GroundTransRentAndBuyPanel.bgBtn.gameObject, self._closeBtnFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransRentAndBuyPanel.backBtn.gameObject, self._backBtnFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransRentAndBuyPanel.ownerBtn.gameObject, self._portraitBtnFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransRentAndBuyPanel.buyBtn.gameObject, self._buyBtnFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransRentAndBuyPanel.rentBtn.gameObject, self._rentBtnFunc, self)
    GroundTransRentAndBuyPanel.tenancySlider.onValueChanged:AddListener(function(value)
        if GroundTransRentAndBuyCtrl.tempRentPreDay == nil then
            return
        end
        GroundTransRentAndBuyPanel.tenancyInput.text = value
        GroundTransRentAndBuyPanel.totalRentalText.text = "E"..GetClientPriceString(value * GroundTransRentAndBuyCtrl.tempRentPreDay)
    end)

    GroundTransRentAndBuyPanel.tenancyInput.onValueChanged:AddListener(function()
        if GroundTransRentAndBuyPanel.tenancyInput.text == "" then
            return
        end
        local num = tonumber(GroundTransRentAndBuyPanel.tenancyInput.text)
        if num > GroundTransRentAndBuyPanel.tenancySlider.maxValue then
            num = GroundTransRentAndBuyPanel.tenancySlider.maxValue
        end
        if num == 0 then
            num = 1
        end
        GroundTransRentAndBuyPanel.tenancyInput.text = num
        GroundTransRentAndBuyPanel.tenancySlider.value = num
    end)
end

function GroundTransRentAndBuyCtrl:Refresh()
    self:_initPanelData()
end

function GroundTransRentAndBuyCtrl:Active()
    UIPanel.Active(self)
    GroundTransRentAndBuyPanel.titleText01.text = GetLanguage(22040002)
    GroundTransRentAndBuyPanel.sellPriceText02.text = GetLanguage(22040004)
    GroundTransRentAndBuyPanel.tenancyText03.text = GetLanguage(22050005)
    GroundTransRentAndBuyPanel.rentalText04.text = GetLanguage(22060004)
    GroundTransRentAndBuyPanel.totalPriceText05.text = GetLanguage(22040005)
    GroundTransRentAndBuyPanel.sellBtnText07.text = GetLanguage(22040001)
    GroundTransRentAndBuyPanel.rentBtnText08.text = GetLanguage(22050001)
end

function GroundTransRentAndBuyCtrl:Hide()
    UIPanel.Hide(self)
    if self.ownerAvatar ~= nil then
        AvatarManger.CollectAvatar(self.ownerAvatar)
    end
end

function GroundTransRentAndBuyCtrl:Close()
    UIPanel.Close(self)
end

---初始化
function GroundTransRentAndBuyCtrl:_initPanelData()
    if self.m_data and self.m_data.groundInfo then
        PlayerInfoManger.GetInfos({[1] = self.m_data.groundInfo.ownerId}, self._showPersonalInfo, self)
        self:_setShowState(self.m_data.groundInfo, self.m_data.groundState)
    end
end
--根据状态显示界面
function GroundTransRentAndBuyCtrl:_setShowState(groundInfo, groundState)
    GroundTransRentAndBuyPanel.sellRoot.localScale = Vector3.zero
    GroundTransRentAndBuyPanel.rentRoot.localScale = Vector3.zero

    if groundState == GroundTransState.Rent then
        GroundTransRentAndBuyPanel.rentRoot.localScale = Vector3.one
        GroundTransRentAndBuyPanel.tenancySlider.minValue = groundInfo.rent.rentDaysMin
        GroundTransRentAndBuyPanel.tenancySlider.maxValue = groundInfo.rent.rentDaysMax
        GroundTransRentAndBuyPanel.tenancySlider.value = GroundTransRentAndBuyPanel.tenancySlider.maxValue
        GroundTransRentAndBuyPanel.tenancyInput.text = GroundTransRentAndBuyPanel.tenancySlider.value
        GroundTransRentAndBuyPanel.dayRentalText.text = "E"..GetClientPriceString(groundInfo.rent.rentPreDay)
        GroundTransRentAndBuyPanel.totalRentalText.text = "E"..GetClientPriceString(groundInfo.rent.rentPreDay * GroundTransRentAndBuyPanel.tenancySlider.value)
        GroundTransRentAndBuyCtrl.tempRentPreDay = groundInfo.rent.rentPreDay  --显示日租金

    elseif groundState == GroundTransState.Sell then
        GroundTransRentAndBuyPanel.sellRoot.localScale = Vector3.one
        GroundTransRentAndBuyPanel.sellPriceText.text = "E"..GetClientPriceString(groundInfo.sell.price)
    end
end

--显示头像+名字信息
function GroundTransRentAndBuyCtrl:_showPersonalInfo(roleInfo)
    self.roleInfo = roleInfo[1]
    GroundTransRentAndBuyPanel.nameText.text = self.roleInfo.name
    self.ownerAvatar = AvatarManger.GetSmallAvatar(self.roleInfo.faceId, GroundTransRentAndBuyPanel.portraitImg.transform,0.2)
end

---按钮方法
--点其他地方则关闭整个堆栈，打开主界面
function GroundTransRentAndBuyCtrl:_closeBtnFunc()
    PlayMusEff(1002)
    --关闭所有界面
    GroundTransSetPriceCtrl._closeBackToMain()
end
--返回按钮
function GroundTransRentAndBuyCtrl:_backBtnFunc()
    PlayMusEff(1002)
    UIPanel:ClosePage()
end

--点击购买按钮
function GroundTransRentAndBuyCtrl:_buyBtnFunc(ins)
    PlayMusEff(1002)
    if ins.m_data.groundInfo.sell.price then
        ct.OpenCtrl("GroundTransContractCtrl", {ownerInfo = ins.roleInfo, groundInfo = ins.m_data.groundInfo})
    end
end
--点击租房按钮
function GroundTransRentAndBuyCtrl:_rentBtnFunc(ins)
    PlayMusEff(1002)
    if ins.m_data.groundInfo.rent then
        ct.OpenCtrl("GroundTransContractCtrl", {ownerInfo = ins.roleInfo, groundInfo = ins.m_data.groundInfo, rentDay = tonumber(GroundTransRentAndBuyPanel.tenancySlider.value)})
    end
end
--点击头像
function GroundTransRentAndBuyCtrl:_portraitBtnFunc(ins)
    PlayMusEff(1002)
    if ins.roleInfo then
        ct.OpenCtrl("PersonalHomeDialogPageCtrl", ins.roleInfo)
    end
end