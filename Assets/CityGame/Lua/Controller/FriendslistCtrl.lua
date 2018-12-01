---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/11/30 15:16
---
FriendslistCtrl = class('FriendslistCtrl', UIPage)
--注册打开方法
UIPage:ResgisterOpen(FriendslistCtrl)

function FriendslistCtrl:initialize()
    ct.log("tina_w15_friends", "FriendsBlacklistCtrl:initialize")
    UIPage.initialize(self, UIType.Normal, UIMode.NeedBack, UICollider.None)
end

function FriendslistCtrl:bundleName()
    ct.log("tina_w15_friends", "FriendsBlacklistCtrl:bundleName")
    return "FriendslistPanel"
end

function FriendslistCtrl:Awake(go)
    ct.log("tina_w15_friends", "FriendsBlacklistCtrl:Awake")
end

function FriendslistCtrl:OnCreate(go)
    ct.log("tina_w15_friends", "FriendsBlacklistCtrl:OnCreate")
    --调用基类方法处理实例的数据
    UIPage.OnCreate(self, go)

    --添加UI事件点击监听
    local luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")
    luaBehaviour:AddClick(FriendslistPanel.backBtn, function ()
        UIPage.ClosePage()
    end)

    --初始化进入状态
    --self:_initState()
end

-- 刷新
function FriendslistCtrl:Refresh()
    self:_initState()
end

function FriendslistCtrl:Close()

end

--初始首次进入所需数据
function FriendslistCtrl:_initState()
    local type = self.m_data.type
    if type == 3 then
        FriendslistPanel.panelNameText.text = "MANAGE"
        self.m_data.friendsMgr:_createListItems(type)
        FriendslistPanel.friendsNumberImage:SetActive(false)
        FriendslistPanel.friendsNumberText.text = ""
    elseif type == 4 then
        FriendslistPanel.panelNameText.text = "BLACK LIST"
        self.m_data.friendsMgr:_createListItems(type)
        FriendslistPanel.friendsNumberImage:SetActive(true)
        FriendslistPanel.friendsNumberText.text = "20"
    elseif type == 5 then
        FriendslistPanel.panelNameText.text = "ADD NEW FRIENDS"
        self.m_data.friendsMgr:_createListItems(type)
        FriendslistPanel.friendsNumberImage:SetActive(false)
        FriendslistPanel.friendsNumberText.text = ""
    elseif type == 6 then
        FriendslistPanel.panelNameText.text = "APPLICATION LIST"
        self.m_data.friendsMgr:_createListItems(type)
        FriendslistPanel.friendsNumberImage:SetActive(false)
        FriendslistPanel.friendsNumberText.text = ""
    elseif type == 7 then
        FriendslistPanel.panelNameText.text = "MANAGE"
        self.m_data.friendsMgr:_createListItems(type)
        FriendslistPanel.friendsNumberImage:SetActive(false)
        FriendslistPanel.friendsNumberText.text = ""
    end

end