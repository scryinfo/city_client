---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/12/3 14:59
---
---
FriendsGrouplistCtrl = class('FriendsGrouplistCtrl', UIPage)
UIPage:ResgisterOpen(FriendsGrouplistCtrl)

function FriendsGrouplistCtrl:initialize()
    ct.log("tina_w8_friends", "FriendsGrouplistCtrl:initialize")
    UIPage.initialize(self, UIType.Normal, UIMode.NeedBack, UICollider.None)
end

function FriendsGrouplistCtrl:bundleName()
    ct.log("tina_w8_friends", "FriendsGrouplistCtrl:bundleName")
    return "Assets/CityGame/Resources/View/FriendsGrouplistPanel.prefab"
end

function FriendsGrouplistCtrl:Awake(go)
    ct.log("tina_w8_friends", "FriendsGrouplistCtrl:Awake")
    self.groupSource = UnityEngine.UI.LoopScrollDataSource.New()  --群组
    self.groupSource.mProvideData = FriendsGrouplistCtrl.static.GroupProvideData
    self.groupSource.mClearData = FriendsGrouplistCtrl.static.GroupClearData
end

function FriendsGrouplistCtrl:OnCreate(go)
    ct.log("tina_w8_friends", "FriendsGrouplistCtrl:OnCreate")
    --调用基类方法处理实例的数据
    UIPage.OnCreate(self, go)

    --添加UI事件点击监听
    FriendsGrouplistCtrl.luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")
    FriendsGrouplistCtrl.luaBehaviour:AddClick(FriendsGrouplistPanel.backBtn, function ()
        UIPage.ClosePage()
        FriendsCtrl.type = 1
    end)

    --初始化进入状态
    --self:_initState()
end

-- 刷新
function FriendsGrouplistCtrl:Refresh()
    self:_initState()
end

function FriendsGrouplistCtrl:Close()

end

--初始首次进入所需数据
function FriendsGrouplistCtrl:_initState()
    FriendsGrouplistPanel.groupView:ActiveLoopScroll(self.groupSource, #FriendsCtrl.data[2])
    FriendsGrouplistPanel.panelNameText.text = "MANAGE"
end

FriendsGrouplistCtrl.static.GroupProvideData = function(transform, idx)
    idx = idx + 1
    local item = GroupItem:new(2, FriendsGrouplistCtrl.luaBehaviour, transform, FriendsCtrl.data[2][idx])
    --FriendsCtrl.friendsMgr.allItems[4][idx] = item
end

FriendsGrouplistCtrl.static.GroupClearData = function(transform)
end