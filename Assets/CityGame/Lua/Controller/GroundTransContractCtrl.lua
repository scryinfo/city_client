---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/26 17:29
---GroundTransContractCtrl
GroundTransContractCtrl = class('GroundTransContractCtrl',UIPanel)
UIPanel:ResgisterOpen(GroundTransContractCtrl)

function GroundTransContractCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.HideOther, UICollider.None)
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

function GroundTransContractCtrl:Hide()
    UIPanel.Hide(self)
end

function GroundTransContractCtrl:Close()
    UIPanel.Hide(self)
end

---初始化
function GroundTransContractCtrl:_initPanelData()
    if self.m_data then
        self:_setShowState(self.m_data)
    end
end
--根据状态显示界面
function GroundTransContractCtrl:_setShowState(data)
    if data.rentDay then
        GroundTransContractPanel.chooseState(true)
        local total = data.groundInfo.rent.rentPreDay * data.rentDay
        GroundTransContractPanel.rentDailyRentText.text = "E"..data.groundInfo.rent.rentPreDay
        GroundTransContractPanel.totalPriceText.text = "E"..total
        GroundTransContractPanel.rentTenancyText.text = data.rentDay.."d"
        local nowStr = os.date("%Y/%m/%d %H:%M", TimeSynchronized.GetTheCurrentTime())
        local endStr = os.date("%Y/%m/%d %H:%M", TimeSynchronized.GetTheCurrentTime() + data.rentDay * 86400)
        GroundTransContractPanel.rentTenancyTimeText.text = string.format("(%s - %s)", nowStr, endStr)
    else
        GroundTransContractPanel.chooseState(false)
        GroundTransContractPanel.totalPriceText.text = "E"..data.groundInfo.sell.price
    end
    GroundTransContractPanel.rentAreaText.text = "1x1"
    GroundTransContractPanel.buyAreaText.text = "1x1"
    --GroundTransContractPanel.APortraitImg.
    --GroundTransContractPanel.BPortraitImg.
    GroundTransContractPanel.ANameText.text = data.ownerInfo.name
    GroundTransContractPanel.BNameText.text = DataManager.GetMyPersonalHomepageInfo().name
end

---按钮方法
--点其他地方则关闭整个堆栈，打开主界面
function GroundTransContractCtrl:_closeBtnFunc()
    GroundTransSetPriceCtrl._closeBackToMain()
end
--返回按钮
function GroundTransContractCtrl:_backBtnFunc()
    UIPanel:ClosePage()
end

--点击购买按钮
function GroundTransContractCtrl:_buyBtnFunc(ins)
    if ins.m_data.groundInfo.sell.price then
        GroundTransModel.m_ReqBuyGround(ins.m_data.groundInfo.sell.price)
        Event.Brocast("SmallPop","Success", 300)
        GroundTransSetPriceCtrl._closeBackToMain()
    end
end
--点击租房按钮
function GroundTransContractCtrl:_rentBtnFunc(ins)
    if ins.m_data.groundInfo.rent then
        GroundTransModel.m_ReqRentGround(ins.m_data.groundInfo.rent, ins.m_data.rentDay)
        Event.Brocast("SmallPop","Success", 300)
        GroundTransSetPriceCtrl._closeBackToMain()
    end
end