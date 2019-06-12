---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/21 10:35
---
-----

FlightRecordCtrl = class('FlightRecordCtrl',UIPanel)
UIPanel:ResgisterOpen(FlightRecordCtrl)

function FlightRecordCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function FlightRecordCtrl:bundleName()
    return "Assets/CityGame/Resources/View/FlightRecordPanel.prefab"
end

function FlightRecordCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function FlightRecordCtrl:Awake(go)
    self.gameObject = go
    local behaviour = self.gameObject:GetComponent('LuaBehaviour')
    behaviour:AddClick(FlightRecordPanel.backBtn.gameObject, function ()
        self:backFunc()
    end , self)
    behaviour:AddClick(FlightRecordPanel.leftBtn.gameObject, function ()
        self:leftPageFunc()
    end , self)
    behaviour:AddClick(FlightRecordPanel.rightBtn.gameObject, function ()
        self:rightPageFunc()
    end , self)

    self.pageEvent = ScrollPageEventData.New()  --滑动翻页事件
    self.pageEvent.mProvideData = FlightRecordCtrl.static.ProvideFunc
    self.pageEvent.mClearData = FlightRecordCtrl.static.ClearFunc
    self.pageEvent.mLeftEndFunc = FlightRecordCtrl.static.LeftEndFunc
    self.pageEvent.mRightEndFunc = FlightRecordCtrl.static.RightEndFunc
    self.pageEvent.mBtnNomalFunc = FlightRecordCtrl.static.BtnNormalFunc
end
--
function FlightRecordCtrl:Refresh()
    self:_initData()
end
--
function FlightRecordCtrl:Active()
    UIPanel.Active(self)
    self:_language()
end
--
function FlightRecordCtrl:Hide()
    UIPanel.Hide(self)
end
--
FlightRecordCtrl.static.ProvideFunc = function(transform, idx)
    idx = idx + 1
    local item = FlightRecordPageItem:new(transform, FlightRecordCtrl.listValue[idx])
    FlightRecordCtrl.static.itemsList[idx] = item
end
--
FlightRecordCtrl.static.ClearFunc = function(transform) end

--正常状态
FlightRecordCtrl.static.BtnNormalFunc = function()
    FlightRecordPanel.rightBtn.localScale = Vector3.one
    FlightRecordPanel.leftBtn.localScale = Vector3.one
end
--到达最左边
FlightRecordCtrl.static.LeftEndFunc = function()
    FlightRecordPanel.leftBtn.localScale = Vector3.zero
end
--到达最右边
FlightRecordCtrl.static.RightEndFunc = function()
    FlightRecordPanel.rightBtn.localScale = Vector3.zero
end
--
function FlightRecordCtrl:_initData()
    --temp
    self.m_data = {}
    self.m_data.valueList = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,}

    if self.m_data ~= nil then
        self:cleanItemList()
        FlightRecordCtrl.listValue = self.m_data.valueList
        FlightRecordPanel.scrollPage:InitData(self.pageEvent, #self.m_data.valueList)
    end
end
--
function FlightRecordCtrl:cleanItemList()
    if FlightRecordCtrl.static.itemsList == nil then
        FlightRecordCtrl.static.itemsList = {}
        return
    end
    for i, value in pairs(FlightRecordCtrl.static.itemsList) do
        value:Close()
    end
end
--
function FlightRecordCtrl:_language()
    FlightRecordPanel.titleText01.text = GetLanguage(32010002)
end
--
function FlightRecordCtrl:backFunc()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--翻页左按钮
function FlightRecordCtrl:leftPageFunc()
    PlayMusEff(1002)
    FlightRecordPanel.scrollPage:PrevPage()
end
--右翻页
function FlightRecordCtrl:rightPageFunc()
    PlayMusEff(1002)
    FlightRecordPanel.scrollPage:NextPage()
end