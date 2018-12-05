---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/5 10:00
---
AddLineChooseItemCtrl = class('AddLineChooseItemCtrl',UIPage)
UIPage:ResgisterOpen(AddLineChooseItemCtrl)

function AddLineChooseItemCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function AddLineChooseItemCtrl:bundleName()
    return "AddLineChooseItemPanel"
end

function AddLineChooseItemCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function AddLineChooseItemCtrl:Awake(go)
    self.gameObject = go
    self.behaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.behaviour:AddClick(AddLineChooseItemPanel.backBtn.gameObject, self._backBtn, self)
    --self.behaviour:AddClick(AddLineChooseItemPanel.searchBtn.gameObject, self._backBtn, self)
    self:_addListener()
end

function AddLineChooseItemCtrl:Refresh()
    self:_initData()
end
function AddLineChooseItemCtrl:_addListener()
    Event.AddListener("c_onReceiveHouseDetailInfo", self._receiveHouseDetailInfo, self)
end
function AddLineChooseItemCtrl:_removeListener()
    Event.RemoveListener("c_onReceiveHouseDetailInfo", self._receiveHouseDetailInfo, self)
end

function AddLineChooseItemCtrl:_initData()
    --在最开始的时候创建所有左右toggle信息，然后每次初始化的时候只需要设置默认值就行了


end

