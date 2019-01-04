---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/26 17:29
---GroundTransSelfCheckInfoCtrl
GroundTransSelfCheckInfoCtrl = class('GroundTransSelfCheckInfoCtrl',UIPage)
UIPage:ResgisterOpen(GroundTransSelfCheckInfoCtrl)

function GroundTransSelfCheckInfoCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function GroundTransSelfCheckInfoCtrl:bundleName()
    return "GroundTransSelfCheckInfoPanel"
end

function GroundTransSelfCheckInfoCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)

    local groundAuctionBehaviour = obj:GetComponent('LuaBehaviour')
    groundAuctionBehaviour:AddClick(GroundTransSelfCheckInfoPanel.bgBtn.gameObject, self._closeBtnFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransSelfCheckInfoPanel.backBtn.gameObject, self._backBtnFunc, self)
end

function GroundTransSelfCheckInfoCtrl:Awake(go)
end

function GroundTransSelfCheckInfoCtrl:Refresh()
    self:_initPanelData()
end

function GroundTransSelfCheckInfoCtrl:Hide()
    UIPage.Hide(self)
end

function GroundTransSelfCheckInfoCtrl:Close()
    UIPage.Hide(self)
end

---初始化
function GroundTransSelfCheckInfoCtrl:_initPanelData()
    if self.m_data and self.m_data.groundInfo.rent then
        self:_setShowState(self.m_data.groundInfo.rent)
    end
end
--
function GroundTransSelfCheckInfoCtrl:_setShowState(rent)
    GroundTransSelfCheckInfoPanel.rentalText.text = rent.rentPreDay
    GroundTransSelfCheckInfoPanel.tenancyText.text = rent.rentDays.."d"
    local remainDay = math.floor(((rent.rentBeginTs / 1000 + rent.rentDays * 86400) - os.time()) / 86400)
    GroundTransSelfCheckInfoPanel.remainDayText.text = remainDay.."d"
end

---按钮方法
--点其他地方则关闭整个堆栈，打开主界面
function GroundTransSelfCheckInfoCtrl:_closeBtnFunc()
    --关闭所有界面
    GroundTransSetPriceCtrl._closeBackToMain()
end
--返回按钮
function GroundTransSelfCheckInfoCtrl:_backBtnFunc()
    UIPage:ClosePage()
end
