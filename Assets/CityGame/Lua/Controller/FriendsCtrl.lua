---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/11/28 11:52
---

FriendsCtrl = class('FriendsCtrl', UIPage)
--注册打开方法
UIPage:ResgisterOpen(FriendsCtrl)

function FriendsCtrl:initialize()
    ct.log("tina_w15_friends", "FriendsCtrl:initialize")
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function FriendsCtrl:bundleName()
    ct.log("tina_w15_friends", "FriendsCtrl:bundleName")
    return "FriendsPanel"
end

function FriendsCtrl:Awake(go)
    ct.log("tina_w15_friends", "FriendsCtrl:Awake")
end

function FriendsCtrl:OnCreate(go)
    ct.log("tina_w15_friends", "FriendsCtrl:OnCreate")
    --调用基类方法处理实例的数据
    UIPage.OnCreate(self, go)
    --初始化管理器
    self.friendsMgr = FriendsMgr:new()

    --添加UI事件点击监听
    local luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")
    luaBehaviour:AddClick(FriendsPanel.backBtn, function ()
        UIPage.ClosePage()
    end)

    luaBehaviour:AddClick(FriendsPanel.friendsManageBtn, self.OnFriendsManage, self)
    luaBehaviour:AddClick(FriendsPanel.blacklistBtn, self.OnBlacklist, self)
    luaBehaviour:AddClick(FriendsPanel.addFriendsBtn, self.OnAddFriends, self)
    luaBehaviour:AddClick(FriendsPanel.applicationlistBtn, self.OnApplicationlist, self)
    luaBehaviour:AddClick(FriendsPanel.groupManageBtn, self.OnGroupManage, self)
    luaBehaviour:AddClick(FriendsPanel.startGroupBtn, self.OnStartGaroup, self)

    FriendsPanel.friendsToggle.onValueChanged:AddListener(function (isOn)
        self:_friendsToggleValueChange(isOn)
    end)

    FriendsPanel.groupToggle.onValueChanged:AddListener(function (isOn)
        self:_groupToggleValueChange(isOn)
    end)

    --模拟数据
    local data =
    {
        {
            data =
            {
                { name = "Edith", company = "Scry1", sign = "Everything i do i wanna put a shine on it"},
                { name = "Colin", company = "Scry2", sign = "Everything i do i wanna put a shine on it"},
                { name = "Jacob", company = "Labrador", sign = "Everything i do i wanna put a shine on it"},
                { name = "Avene", company = "Labrador", sign = "Everything i do i wanna put a shine on it"},
                { name = "TherMale", company = "Labrador", sign = "Everything i do i wanna put a shine on it"}
            }
        },
        {
            data =
            {
                { name = "Labrador", number = "122/300"},
                { name = "Scry1", number = "110/300"},
                { name = "Scry2", number = "66/300"},
                { name = "Scry3", number = "77/300"},
                { name = "Scry4", number = "88/300"}
            }
        }
    }

    --初始化进入状态
    self:_initState()
    self.friendsMgr:_createFriendsAndGroupItems(luaBehaviour, data)
end

-- 刷新
function FriendsCtrl:Refresh()
    self:_refreshState()
end

function FriendsCtrl:Close()

end

--初始首次进入所需数据
function FriendsCtrl:_initState()
    --FriendsPanel.friendsToggle.isOn = true
    --FriendsPanel.friendsNumberText.text = "20"
    --FriendsPanel.groupNumberText.text = "5"
    --UnityEngine.GameObject.AddComponent(FriendsPanel.friendsView, LuaHelper.GetType("UnityEngine.UI.LoopVerticalScrollRect"))
    --UnityEngine.GameObject.AddComponent(FriendsPanel.friendsView, LuaHelper.GetType("ActiveLoopScrollRect"))
    --UnityEngine.GameObject.AddComponent(FriendsPanel.groupView, LuaHelper.GetType("UnityEngine.UI.LoopVerticalScrollRect"))
    --UnityEngine.GameObject.AddComponent(FriendsPanel.groupView, LuaHelper.GetType("ActiveLoopScrollRect"))
end

-- 二次刷新界面的数据
function FriendsCtrl:_refreshState()
    FriendsPanel.friendsToggle.isOn = true
    self:_friendsToggleValueChange(true)
    FriendsPanel.friendsNumberText.text = "20"
    FriendsPanel.groupNumberText.text = "5"
end

-- 控制好友分页
function FriendsCtrl:_friendsToggleValueChange(isOn)
    FriendsPanel.friendsRoot:SetActive(isOn)
    FriendsPanel.groupRoot:SetActive(not isOn)
    FriendsPanel.friendsOpen:SetActive(isOn)
    FriendsPanel.friendsClose:SetActive(not isOn)
    FriendsPanel.groupOpen:SetActive(not isOn)
    FriendsPanel.groupClose:SetActive(isOn)
end

-- 控制群组分页
function FriendsCtrl:_groupToggleValueChange(isOn)
    FriendsPanel.friendsRoot:SetActive(not isOn)
    FriendsPanel.groupRoot:SetActive(isOn)
    FriendsPanel.friendsOpen:SetActive(not isOn)
    FriendsPanel.friendsClose:SetActive(isOn)
    FriendsPanel.groupOpen:SetActive(isOn)
    FriendsPanel.groupClose:SetActive(not isOn)
end

-- 管理好友
function FriendsCtrl:OnFriendsManage(go)
    local data =
    {
        type = 3,
        friendsMgr = go.friendsMgr
    }
    ct.OpenCtrl("FriendslistCtrl", data)
end

--打开黑名单
function FriendsCtrl:OnBlacklist(go)
    local data =
    {
        type = 4,
        friendsMgr = go.friendsMgr
    }
    ct.OpenCtrl("FriendslistCtrl", data)
end

--添加好友
function FriendsCtrl:OnAddFriends(go)
    local data =
    {
        type = 5,
        friendsMgr = go.friendsMgr
    }
    ct.OpenCtrl("FriendslistCtrl", data)
end

--打开申请列表
function FriendsCtrl:OnApplicationlist(go)
    local data =
    {
        type = 6,
        friendsMgr = go.friendsMgr
    }
    ct.OpenCtrl("FriendslistCtrl", data)
end

--管理群组
function FriendsCtrl:OnGroupManage(go)
    local data =
    {
        type = 7,
        friendsMgr = go.friendsMgr
    }
    ct.OpenCtrl("FriendslistCtrl", data)
end

--发起群聊
function FriendsCtrl:OnStartGaroup(go)
    UIPage.ClosePage()
end