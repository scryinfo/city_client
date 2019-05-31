---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ljw.
--- DateTime: 2019/4/22 18:08
---

MyShutDownCtrl = class('MyShutDownCtrl',UIPanel)
UIPanel:ResgisterOpen(MyShutDownCtrl)

function MyShutDownCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal)
end

function MyShutDownCtrl:bundleName()
    return "Assets/CityGame/Resources/View/MyShutDownPanel.prefab"
end

function MyShutDownCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function MyShutDownCtrl:Awake(go)
    self.gameObject = go
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(MyShutDownPanel.closeBtn.gameObject,self._clickCloseBtn,self)
    self.luaBehaviour:AddClick(MyShutDownPanel.startBtn.gameObject,self._clickStartBtn,self)

end

function MyShutDownCtrl:Active()
    UIPanel.Active(self)
end

function MyShutDownCtrl:Refresh()
    UIPanel.Refresh(self)
end

function MyShutDownCtrl:Hide()
    UIPanel.Hide(self)
end

---------------------------------------------------------------------------------------------
--取消关闭页面
function MyShutDownCtrl:_clickCloseBtn()
    UIPanel.ClosePage()
end

--设置后关闭页面
function MyShutDownCtrl:_clickStartBtn(go)
    local data = {}
    data.buildingId = go.m_data.m_data.insId
    data.rentCapacity = 0
    data.minHourToRent = 0
    data.maxHourToRent = 0
    data.rent = 0
    data.enableRent = false
    SetRenTableWareHousePanel.spaceText.text = data.rentCapacity
    SetRenTableWareHousePanel.priceText.text = data.rent
    SetRenTableWareHousePanel.mintimeText.text = data.minHourToRent
    SetRenTableWareHousePanel.maxtimeText.text = data.maxHourToRent
    DataManager.OpenDetailModel(BuidingWareHouseModel,data.buildingId)
    DataManager.DetailModelRpcNoRet(data.buildingId, 'm_ReqShutSentHouseDetailInfo',data)
   UIPanel.BackToPage(MainRenTableWarehouseCtrl)
end
