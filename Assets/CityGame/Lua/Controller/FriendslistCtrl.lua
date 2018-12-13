---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/11/30 15:16
---
FriendslistCtrl = class('FriendslistCtrl', UIPage)
UIPage:ResgisterOpen(FriendslistCtrl)

function FriendslistCtrl:initialize()
    ct.log("tina_w7_friends", "FriendslistCtrl:initialize")
    UIPage.initialize(self, UIType.Normal, UIMode.NeedBack, UICollider.None)
end

function FriendslistCtrl:bundleName()
    ct.log("tina_w7_friends", "FriendslistCtrl:bundleName")
    return "FriendslistPanel"
end

function FriendslistCtrl:Awake(go)
    ct.log("tina_w7_friends", "FriendslistCtrl:Awake")
    self.friendsSource = UnityEngine.UI.LoopScrollDataSource.New()  --好友
    self.friendsSource.mProvideData = FriendslistCtrl.static.FriendsProvideData
    self.friendsSource.mClearData = FriendslistCtrl.static.FriendsClearData
end

function FriendslistCtrl:OnCreate(go)
    ct.log("tina_w7_friends", "FriendslistCtrl:OnCreate")
    --调用基类方法处理实例的数据
    UIPage.OnCreate(self, go)

    --添加UI事件点击监听
    FriendslistCtrl.luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")
    FriendslistCtrl.luaBehaviour:AddClick(FriendslistPanel.backBtn, function ()
        UIPage.ClosePage()
    end)

    FriendslistCtrl.luaBehaviour:AddClick(FriendslistPanel.searchBtn, self.OnSearch, self)
end

-- 刷新
function FriendslistCtrl:Refresh()
    self:_addListener()
end

function FriendslistCtrl:Close()

end

function FriendslistCtrl:_addListener()
    -- 监听Model层网络回调
    Event.AddListener("c_OnReceiveSearchPlayerInfo", self.c_OnReceiveSearchPlayerInfo, self)
    Event.AddListener("c_OnReceiveDeleteFriend", self.c_OnReceiveDeleteFriend, self)
    --Event.AddListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self)
    Event.AddListener("c_DeleteBlacklist", self.c_DeleteBlacklist, self)
    Event.AddListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)

    self:_initState()
end

function FriendslistCtrl:Hide()
    UIPage.Hide(self)
    self:_removeListener()
end

function FriendslistCtrl:_removeListener()
    -- 监听Model层网络回调
    Event.RemoveListener("c_OnReceiveSearchPlayerInfo", self.c_OnReceiveSearchPlayerInfo, self)
    Event.RemoveListener("c_OnReceiveDeleteFriend", self.c_OnReceiveDeleteFriend, self)
    --Event.RemoveListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self)
    Event.RemoveListener("c_DeleteBlacklist", self.c_DeleteBlacklist, self)
    Event.RemoveListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)
end

--初始首次进入所需数据
function FriendslistCtrl:_initState()
    local type = self.m_data.type
    FriendslistCtrl.type = self.m_data.type
    --FriendslistPanel.listContent.offsetMax = Vector2.New(0,0)
    --好友界面数据刷新
    FriendslistCtrl.friendInfo = {}

    if type == 2 then
        FriendslistPanel.panelNameText.text = "MANAGE"
        FriendslistPanel.blacklistNumberImage:SetActive(false)
        FriendslistPanel.blacklistNumberText.text = ""
        FriendslistPanel.searchInputField:SetActive(false)
        FriendslistPanel.listScrollView.offsetMax = Vector2.New(0,-60)

        if FriendsCtrl.friendInfo then
            FriendslistCtrl.friendInfo = FriendsCtrl.friendInfo
            FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, #FriendslistCtrl.friendInfo)
        else
            FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, 0)
        end
    elseif type == 3 then
        FriendslistPanel.panelNameText.text = "BLACK LIST"
        FriendslistPanel.blacklistNumberImage:SetActive(true)
        FriendslistPanel.searchInputField:SetActive(false)
        FriendslistPanel.listScrollView.offsetMax = Vector2.New(0,-88)
        self:_showBlacklistNum()

        local blacklist = DataManager.GetMyBlacklist()
        if blacklist[1] then
            FriendslistCtrl.friendInfo = blacklist
            FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, #FriendslistCtrl.friendInfo)
        else
            FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, 0)
        end
    elseif type == 4 then
        FriendslistPanel.panelNameText.text = "ADD NEW FRIENDS"
        FriendslistPanel.blacklistNumberImage:SetActive(false)
        FriendslistPanel.blacklistNumberText.text = ""
        --显示和清空搜索框
        FriendslistPanel.searchInputField:SetActive(true)
        FriendslistPanel.searchInputField:GetComponent("InputField").text = ""
        FriendslistPanel.listScrollView.offsetMax = Vector2.New(0,-120)

        FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, 0)
    elseif type == 5 then
        FriendslistPanel.panelNameText.text = "APPLICATION LIST"
        FriendslistPanel.blacklistNumberImage:SetActive(false)
        FriendslistPanel.blacklistNumberText.text = ""
        FriendslistPanel.searchInputField:SetActive(false)
        FriendslistPanel.listScrollView.offsetMax = Vector2.New(0,-30)

        FriendslistCtrl.friendInfo = DataManager.GetMyFriendsApply()
        FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, #FriendslistCtrl.friendInfo)
    end
end

function FriendslistCtrl:OnSearch(go)
    local text = FriendslistPanel.searchInputField:GetComponent("InputField").text
    if text == "" then
        return
    end
    Event.Brocast("m_SearchPlayer", text)
end

FriendslistCtrl.static.FriendsProvideData = function(transform, idx)
    idx = idx + 1
    local item = FriendsItem:new(idx, FriendslistCtrl.type, FriendslistCtrl.luaBehaviour, transform, FriendslistCtrl.friendInfo[idx])
end

FriendslistCtrl.static.FriendsClearData = function(transform)
end

function FriendslistCtrl:_refreshItem(data)
    FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, data)
end

function FriendslistCtrl:_showBlacklistNum()
    local blacklistNum = DataManager.GetMyBlacklist()
    FriendslistPanel.blacklistNumberText.text = #blacklistNum > 0 and #blacklistNum or "0"
end

-- 网络回调
function FriendslistCtrl:c_OnReceiveSearchPlayerInfo(friendsData)
    if friendsData and friendsData.info then
        FriendslistCtrl.friendInfo = friendsData.info
        FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, #FriendslistCtrl.friendInfo)
    else
        FriendslistCtrl.friendInfo = {}
        FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, 0)
    end
end

function FriendslistCtrl:c_OnReceiveDeleteFriend(friendsId)
    DataManager.SetMyFriends({ id = friendsId.id, b = nil })
    for i, v in ipairs(FriendslistCtrl.friendInfo) do
        if v.id == friendsId.id then
            table.remove(FriendslistCtrl.friendInfo, i)
            break
        end
    end
    FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, #FriendslistCtrl.friendInfo)
    Event.Brocast("SmallPop","Deleted",60)
end

--function FriendslistCtrl:c_OnReceivePlayerInfo(friendsData)
--    if friendsData.info[1] then
--        FriendslistCtrl.friendInfo = friendsData.info
--        FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, #FriendslistCtrl.friendInfo)
--    else
--        FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, 0)
--    end
--end

function FriendslistCtrl:c_DeleteBlacklist(friendsId)
    DataManager.SetMyBlacklist({ id = friendsId.id })
    if friendsId.id then
        self:_showBlacklistNum()
        FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, #FriendslistCtrl.friendInfo)
        Event.Brocast("SmallPop","Successful removal from blacklist.",60)
    end
end

function FriendslistCtrl:c_OnReceiveAddFriendReq(requestFriend)
    if self.m_data.type == 5 then
        FriendslistCtrl.friendInfo = DataManager.GetMyFriendsApply()
        FriendslistPanel.friendsView:ActiveLoopScroll(self.friendsSource, #FriendslistCtrl.friendInfo)
    end
end