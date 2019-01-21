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
        GroundTransRentAndBuyPanel.tenancyText.text = value
        GroundTransRentAndBuyPanel.totalRentalText.text = "E"..value * GroundTransRentAndBuyCtrl.tempRentPreDay
    end)
end

function GroundTransRentAndBuyCtrl:Refresh()
    Event.AddListener("c_GroundTranReqPlayerInfo",self._showPersonalInfo, self)
    self:_initPanelData()
end

function GroundTransRentAndBuyCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_GroundTranReqPlayerInfo",self._showPersonalInfo, self)
end

function GroundTransRentAndBuyCtrl:Close()
    UIPanel.Hide(self)
end

---初始化
function GroundTransRentAndBuyCtrl:_initPanelData()
    if self.m_data and self.m_data.groundInfo then
        GroundTransModel.m_ReqPlayersInfo({[1] = self.m_data.groundInfo.ownerId})
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
        GroundTransRentAndBuyPanel.tenancyText.text = GroundTransRentAndBuyPanel.tenancySlider.value
        GroundTransRentAndBuyPanel.dayRentalText.text = "E"..groundInfo.rent.rentPreDay
        GroundTransRentAndBuyPanel.totalRentalText.text = "E"..groundInfo.rent.rentPreDay * GroundTransRentAndBuyPanel.tenancySlider.value
        GroundTransRentAndBuyCtrl.tempRentPreDay = groundInfo.rent.rentPreDay  --显示日租金

    elseif groundState == GroundTransState.Sell then
        GroundTransRentAndBuyPanel.sellRoot.localScale = Vector3.one
        GroundTransRentAndBuyPanel.sellPriceText.text = groundInfo.sell.price
    end
end

--显示头像+名字信息
function GroundTransRentAndBuyCtrl:_showPersonalInfo(roleInfo)
    if roleInfo.info ~= nil and #roleInfo.info == 1 and roleInfo.info[1].id == self.m_data.groundInfo.ownerId then
        self.roleInfo = roleInfo.info[1]
        GroundTransRentAndBuyPanel.nameText.text = self.roleInfo.name
        LoadSprite(PlayerHead[self.roleInfo.faceId].MainPath, GroundTransRentAndBuyPanel.portraitImg)
        --GroundTransRentAndBuyPanel.portraitImg.
    end
end

---按钮方法
--点其他地方则关闭整个堆栈，打开主界面
function GroundTransRentAndBuyCtrl:_closeBtnFunc()
    --关闭所有界面
    GroundTransSetPriceCtrl._closeBackToMain()
end
--返回按钮
function GroundTransRentAndBuyCtrl:_backBtnFunc()
    UIPanel:ClosePage()
end

--点击购买按钮
function GroundTransRentAndBuyCtrl:_buyBtnFunc(ins)
    if ins.m_data.groundInfo.sell.price then
        ct.OpenCtrl("GroundTransContractCtrl", {ownerInfo = ins.roleInfo, groundInfo = ins.m_data.groundInfo})
    end
end
--点击租房按钮
function GroundTransRentAndBuyCtrl:_rentBtnFunc(ins)
    if ins.m_data.groundInfo.rent then
        ct.OpenCtrl("GroundTransContractCtrl", {ownerInfo = ins.roleInfo, groundInfo = ins.m_data.groundInfo, rentDay = tonumber(GroundTransRentAndBuyPanel.tenancyText.text)})
    end
end
--点击头像
function GroundTransRentAndBuyCtrl:_portraitBtnFunc(ins)
    if ins.roleInfo then
        ct.OpenCtrl("PersonalHomeDialogPageCtrl", ins.roleInfo)
    end
end