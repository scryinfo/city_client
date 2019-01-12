---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/12/14 10:05
---

ChatCtrl = class('ChatCtrl', UIPage)
UIPage:ResgisterOpen(ChatCtrl)

function ChatCtrl:initialize()
    ct.log("tina_w9_friends", "ChatCtrl:initialize")
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function ChatCtrl:bundleName()
    ct.log("tina_w9_friends", "ChatCtrl:bundleName")
    return "Assets/CityGame/Resources/View/ChatPanel.prefab"
end

function ChatCtrl:OnCreate(go)
    ct.log("tina_w9_friends", "ChatCtrl:OnCreate")
    --调用基类方法处理实例的数据
    UIPage.OnCreate(self, go)
end


function ChatCtrl:Awake(go)
    ct.log("tina_w9_friends", "ChatCtrl:Awake")

    --初始化管理器
    ChatCtrl.static.chatMgr = ChatMgr:new()
    ChatCtrl.WORLD_SHOW_NUM = 50 -- 世界聊天显示条数
    ChatCtrl.FRIENDS_SHOW_NUM = 5 -- 好友聊天显示条数
    ChatCtrl.CHAT_RECORDS_SHOW_NUM = 20 -- 聊天记录显示条数

    --添加UI事件点击监听
    ChatCtrl.static.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.backBtn, function ()
        ChatCtrl.static.chatMgr:DestroyContentChildren(0)
        ChatCtrl.static.chatMgr:DestroyContentChildren(1)
        ChatCtrl.static.chatMgr:DestroyContentChildren(2)
        ChatCtrl.static.chatMgr:DestroyContentChildren(4)
        ChatCtrl.static.chatMgr:SetToggle()
        UIPage.ClosePage()
    end)

    --ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.backChatBtn, self.OnBackChat, self)
    ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.expressionBtn, self.OnShowExpression, self)
    ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.backExpressionBtn, self.OnBackExpression, self)
    ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.sendBtn, self.OnSend, self)
    ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.addFriendsBtn, self.OnAddFriends, self)
    ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.chatBtn, self.OnChat, self)
    ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.shieldBtn, self.OnShield, self)
    ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.chatRecordsBtn, self.OnChatRecords, self)
    ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.showPersonalInfoBtn, self.OnShowPersonalInfo, self)
    ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.deleteChatRecordsBtn, self.OnDeleteChatRecords, self)
    ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.prevBtn, self.OnPrev, self)
    ChatCtrl.static.luaBehaviour:AddClick(ChatPanel.nextBtn, self.OnNext, self)

    ChatPanel.worldToggle.onValueChanged:AddListener(function (isOn)
        self:_worldToggleValueChange(isOn)
    end)

    ChatPanel.friendsToggle.onValueChanged:AddListener(function (isOn)
        self:_friendsToggleValueChange(isOn)
    end)

    ChatPanel.strangersToggle.onValueChanged:AddListener(function (isOn)
        self:_strangersToggleValueChange(isOn)
    end)

    --滑动部分
        -- 显示表情Item
    ChatCtrl.static.chatMgr:CreateExpression()
end

-- 刷新
function ChatCtrl:Refresh()
    ct.log("tina_w9_friends", "ChatCtrl:Refresh")
    self:initInsData()
    self:_addListener()
end

function ChatCtrl:initInsData()
    DataManager.OpenDetailModel(ChatModel, OpenModelInsID.ChatCtrl)
end

function ChatCtrl:Close()

end

--function ChatCtrl:AddListenerScrollView(index, isListener)
--    if index == 2 then
--        if isListener then
--            ChatPanel.friendsScrollView.onValueChanged:AddListener(function (v2)
--                --ct.log("tina_w11_friends", v2.x)
--                ct.log("tina_w11_friends", ChatPanel.friendsVerticalScrollbar.value)
--                if ChatPanel.friendsVerticalScrollbar.value == 1 then
--                    if ChatCtrl.static.chatMgr.isShowChatInfo then
--                        ChatCtrl.static.chatMgr.isShowChatInfo = false
--                        ChatCtrl.static.chatMgr:ShowOtherChatInfo(2)
--                    end
--                end
--            end)
--        else
--            ChatPanel.friendsScrollView.onValueChanged:RemoveAllListeners()
--        end
--    elseif index == 3 then
--        if isListener then
--            ChatPanel.strangersScrollView.onValueChanged:AddListener(function (v2)
--                --ct.log("tina_w11_friends", v2.x)
--                --ct.log("tina_w11_friends", v2.y)
--            end)
--        else
--            ChatPanel.strangersScrollView.onValueChanged:RemoveAllListeners()
--        end
--    end
--end

function ChatCtrl:_addListener()
    -- 监听Model层网络回调
    Event.AddListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self)
    Event.AddListener("c_OnReceiveRoleCommunication", self.c_OnReceiveRoleCommunication, self)
    Event.AddListener("c_OnReceiveAddBlacklist", self.c_OnReceiveAddBlacklist, self)
    Event.AddListener("c_OnReceiveAddFriendSucess", self.c_OnReceiveAddFriendSucess, self)
    Event.AddListener("c_OnReceiveRoleStatusChange", self.c_OnReceiveRoleStatusChange, self)

    self:_refreshData()
end

function ChatCtrl:Hide()
    self:_removeListener()
    UIPage.Hide(self)
end

function ChatCtrl:_removeListener()
    Event.RemoveListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self)
    Event.RemoveListener("c_OnReceiveRoleCommunication", self.c_OnReceiveRoleCommunication, self)
    Event.RemoveListener("c_OnReceiveAddBlacklist", self.c_OnReceiveAddBlacklist, self)
    Event.RemoveListener("c_OnReceiveAddFriendSucess", self.c_OnReceiveAddFriendSucess, self)
    Event.RemoveListener("c_OnReceiveRoleStatusChange", self.c_OnReceiveRoleStatusChange, self)
end

-- 获取界面数据
function ChatCtrl:_refreshData()
    self:_refreshState()
end

-- 刷新界面的状态
function ChatCtrl:_refreshState()
    self:_closePlayerInfo()
    --self:_showChatNoticeItem()
    ChatPanel.expressionRoot:SetActive(false)
    if self.isShowPersonalInfo then
        self.isShowPersonalInfo = false
        return
    end
    if self.m_data.toggleId == 1 then  -- 打开世界分页
        ChatPanel.worldToggle.isOn = true
        --self:_worldToggleValueChange(true)
        self.channel = 0 -- 聊天频道
        self:_showChatNoticeItem()
        self:_showWorldInfo()
    elseif self.m_data.toggleId == 2 then  -- 打开好友分页
        --self:_friendsToggleValueChange(true)
        self.channel = 1 -- 聊天频道
        ChatCtrl.static.isShowClickFriends = true
        if ChatPanel.friendsToggle.interactable then
            self:_showChatNoticeItem()
            ChatPanel.friendsToggle.isOn = true
        else
            self:_showChatNoticeItem()
            ChatPanel.chatRecordsRoot:SetActive(false)
            self:_queryFriendInfo()
        end
        ChatCtrl.static.chatMgr:SetActivePlayerId(self.m_data.id)
    elseif self.m_data.toggleId == 3 then  -- 打开陌生人分页
        ChatPanel.strangersToggle.isOn = true
        --self:_strangersToggleValueChange(true)
        self.channel = 3 -- 聊天频道
        ChatCtrl.static.isShowClickStrangers = true
        ChatCtrl.static.chatMgr:SetActivePlayerId(self.m_data.id)
        self:_showChatNoticeItem()
        self:_showStrangersInfo()
    end
end

function ChatCtrl:_closePlayerInfo()
    --ChatPanel.backChatBtn:SetActive(false)
    ChatPanel.playerInfoRoot:SetActive(false)
end

-- 红点提示
function ChatCtrl._showChatNoticeItem()
    ChatPanel.friendsNoticeImage:SetActive(false)
    ChatPanel.strangersNoticeImage:SetActive(false)
    local chatFriendsInfo = DataManager.GetMyChatInfo(2)
    local chatStrangersInfo = DataManager.GetMyChatInfo(3)
    local saveUnread = DataManager.GetUnread()
    if ChatPanel.friendsToggle.interactable then
        for _, v in pairs(chatFriendsInfo) do
            if v.unreadNum and v.unreadNum > 0 then
                ChatPanel.friendsNoticeImage:SetActive(true)
                break
            end
        end

    end
    if ChatPanel.strangersToggle.interactable then
        for _, m in pairs(chatStrangersInfo) do
            if m.unreadNum and m.unreadNum > 0 then
                ChatPanel.strangersNoticeImage:SetActive(true)
                break
            end
        end
    end
    if saveUnread then
        for _, n in pairs(saveUnread) do
            if n and n[1] then
                ChatPanel.friendsNoticeImage:SetActive(true)
                return
            end
        end
    end
end

-- 世界分页
function ChatCtrl:_worldToggleValueChange(isOn)
    if isOn then
        ChatPanel.worldRoot:SetActive(isOn)
        ChatPanel.worldOpen:SetActive(isOn)
        ChatPanel.worldClose:SetActive(not isOn)
        ChatPanel.friendsRoot:SetActive(not  isOn)
        ChatPanel.friendsOpen:SetActive(not isOn)
        ChatPanel.friendsClose:SetActive(isOn)
        ChatPanel.strangersRoot:SetActive(not isOn)
        ChatPanel.strangersOpen:SetActive(not isOn)
        ChatPanel.strangersClose:SetActive(isOn)
        ChatPanel.worldToggle.interactable = false
        ChatPanel.friendsToggle.interactable = true
        ChatPanel.strangersToggle.interactable = true

        self.channel = 0 -- 世界频道
        ChatCtrl.static.chatMgr:DestroyContentChildren(1)
        ChatCtrl.static.chatMgr:DestroyContentChildren(2)
        ChatCtrl.static.chatMgr:DestroyContentChildren(4)
        ChatCtrl.static.chatMgr:SetRootScrollbar(1)
        ChatCtrl.static.chatMgr:SetToggle()
        ChatCtrl.static.chatMgr:SetActivePlayerData({})
        ChatPanel.playerInfoRoot:SetActive(false)
    end
end

-- 显示世界消息
function ChatCtrl:_showWorldInfo()
    local data = DataManager.GetMyChatInfo(1)
    ChatCtrl.worldInfo = {}
    local worldInfoAllNum = #data
    if worldInfoAllNum <= ChatCtrl.WORLD_SHOW_NUM then
        for _, v in ipairs(data) do
            table.insert(ChatCtrl.worldInfo, v)
            ChatCtrl.static.chatMgr:CreateChatItem(v)
        end
        ChatCtrl.static.chatMgr:StartScrollBottom()
    else
        for i = worldInfoAllNum - ChatCtrl.WORLD_SHOW_NUM , worldInfoAllNum do
            table.insert(ChatCtrl.worldInfo, data[i])
            ChatCtrl.static.chatMgr:CreateChatItem(data[i])
        end
        ChatCtrl.static.chatMgr:StartScrollBottom()
    end
end

-- 查询好友信息
function ChatCtrl:_queryFriendInfo()
    local friendsBasicData = DataManager.GetMyFriends()
    local idTemp = {}
    for id, v in pairs(friendsBasicData) do
        table.insert(idTemp, id)
    end
    if idTemp[1] then
        Event.Brocast("m_QueryPlayerInfoChat", idTemp)
    else
        ChatPanel.friendsNum.text = "0"
    end
end

-- 好友分页
function ChatCtrl:_friendsToggleValueChange(isOn)
    if isOn then
        ChatPanel.worldRoot:SetActive(not isOn)
        ChatPanel.worldOpen:SetActive(not isOn)
        ChatPanel.worldClose:SetActive(isOn)
        ChatPanel.friendsRoot:SetActive(isOn)
        ChatPanel.friendsOpen:SetActive(isOn)
        ChatPanel.friendsClose:SetActive(not isOn)
        ChatPanel.strangersRoot:SetActive(not isOn)
        ChatPanel.strangersOpen:SetActive(not isOn)
        ChatPanel.strangersClose:SetActive(isOn)
        ChatPanel.worldToggle.interactable = true
        ChatPanel.friendsToggle.interactable = false
        ChatPanel.strangersToggle.interactable = true

        self.channel = 1 -- 聊天频道
        ChatCtrl.static.chatMgr:DestroyContentChildren(4)
        ChatCtrl.static.chatMgr:SetRootScrollbar(2)
        ChatCtrl.static.chatMgr:SetToggle()
        ChatPanel.friendsNoticeImage:SetActive(false)
        ChatCtrl.static.chatMgr:SetActivePlayerData({})
        ChatPanel.playerInfoRoot:SetActive(false)
        ChatPanel.chatRecordsBtn:SetActive(false)
        ChatPanel.chatRecordsRoot:SetActive(false)

        self:_queryFriendInfo()
    end
end

-- 显示陌生人信息
function ChatCtrl:_showStrangersInfo()
    local chatStrangersInfo = DataManager.GetMyChatInfo(3)
    local strangersPlayerItem = ChatCtrl.static.chatMgr:GetStrangersPlayer().item
    local friendsBasicData = DataManager.GetMyFriends()
    for m, n in pairs(strangersPlayerItem) do
        if friendsBasicData[m] ~= nil then
            ChatCtrl.static.chatMgr:DestroyItem(2, m)
        end
    end

    local strangersId = {}
    local isExitStrangers = true
    for k, v in pairs(chatStrangersInfo) do
        if strangersPlayerItem[k] then
            strangersPlayerItem[k]:SetNoticeText(v.unreadNum)
            if ChatCtrl.static.isShowClickStrangers and k == self.m_data.id then
                strangersPlayerItem[k].toggle.isOn = true
                ChatCtrl.static.isShowClickStrangers = false
                ChatPanel.strangersPlayerContent.anchoredPosition = Vector2.New(0, tonumber(127 * strangersPlayerItem[k].prefab.transform:GetSiblingIndex()))
            end
        else
            if k ~= DataManager.GetMyOwnerID() then
                table.insert(strangersId, k)
            end
        end
        if ChatCtrl.static.isShowClickStrangers and k == self.m_data.id then
            isExitStrangers = false
        end
    end
    local strangersPlayerId = ChatCtrl.static.chatMgr:GetStrangersPlayer().id
    for _, j in ipairs(strangersPlayerId) do
        if ChatCtrl.static.isShowClickStrangers and j == self.m_data.id then
            isExitStrangers = false
        end
    end
    if ChatCtrl.static.isShowClickStrangers then
        if  isExitStrangers then
            table.insert(strangersId, self.m_data.id)
        else
            ChatCtrl.static.isShowClickStrangers = false
            local strangersPlayerItem = ChatCtrl.static.chatMgr:GetActivePlayerItem()
            strangersPlayerItem.toggle.isOn = true
            ChatPanel.strangersPlayerContent.anchoredPosition = Vector2.New(0, tonumber(127 * strangersPlayerItem.prefab.transform:GetSiblingIndex()))
        end
    end
    if strangersId[1] then
        Event.Brocast("m_QueryPlayerInfoChat", strangersId)
    end
    ChatPanel.strangersPlayerNum.text = tostring(#ChatCtrl.static.chatMgr:GetStrangersPlayer().id)
end

-- 陌生人分页
function ChatCtrl:_strangersToggleValueChange(isOn)
    if isOn then
        ChatPanel.worldRoot:SetActive(not isOn)
        ChatPanel.worldOpen:SetActive(not isOn)
        ChatPanel.worldClose:SetActive(isOn)
        ChatPanel.friendsRoot:SetActive(not isOn)
        ChatPanel.friendsOpen:SetActive(not isOn)
        ChatPanel.friendsClose:SetActive(isOn)
        ChatPanel.strangersRoot:SetActive(isOn)
        ChatPanel.strangersOpen:SetActive(isOn)
        ChatPanel.strangersClose:SetActive(not isOn)
        ChatPanel.worldToggle.interactable = true
        ChatPanel.friendsToggle.interactable = true
        ChatPanel.strangersToggle.interactable = false

        self.channel = 3 -- 陌生人频道
        ChatCtrl.static.chatMgr:DestroyContentChildren(1)
        ChatCtrl.static.chatMgr:DestroyContentChildren(2)
        ChatCtrl.static.chatMgr:SetRootScrollbar(3)
        ChatCtrl.static.chatMgr:SetToggle()
        ChatPanel.strangersNoticeImage:SetActive(false)
        ChatCtrl.static.chatMgr:SetActivePlayerData({})
        ChatPanel.strangersPlayerNum.text = tostring(#ChatCtrl.static.chatMgr:GetStrangersPlayer().id)
        ChatPanel.playerInfoRoot:SetActive(false)
        self:_showStrangersInfo()
    end
end

-- 关闭玩家信息显示
--function ChatCtrl:OnBackChat(go)
--    go:_closePlayerInfo()
--end

-- 点击表情按钮
function ChatCtrl:OnShowExpression()
    ChatPanel.expressionRoot:SetActive(not ChatPanel.expressionRoot.activeSelf)
end

-- 关闭表情列表
function ChatCtrl:OnBackExpression()
    ChatPanel.expressionRoot:SetActive(false)
end

-- 发送聊天消息
function ChatCtrl:OnSend(go)
    local text = ChatPanel.chatInputField.text
    local chatStr = string.gsub(text, "^%s*(.-)%s*$", "%1")
    if string.len(chatStr) == 0 or chatStr == "" then
        Event.Brocast("SmallPop","Please enter the content.",80)
        return
    elseif string.len(chatStr) > 90 then
        Event.Brocast("SmallPop","More than 90 characters.",80)
        return
    end

    local data
    if go.channel == 0 then
        data = {msg = chatStr, channel = go.channel}
    else
        if not ChatCtrl.static.chatMgr:GetActivePlayerId() then
            Event.Brocast("SmallPop","Choose someone to chat with.",80)
            return
        end
        data = {channelId = ChatCtrl.static.chatMgr:GetActivePlayerId(), msg = chatStr, channel = go.channel}
    end

    ChatPanel.chatInputField.text = ""
    Event.Brocast("m_RoleCommunication", data)
end

-- 陌生人加好友
function ChatCtrl:OnAddFriends(go)
    local data = {}
    data.titleInfo = "REMINDER"
    data.tipInfo = "Please input verification information!"
    data.btnCallBack = function(text)
        ct.log("tina_w8_friends", "向服务器发送加好友信息")
        Event.Brocast("m_ChatAddFriends", { id = ChatCtrl.static.chatMgr:GetActivePlayerId(), desc = text })
        Event.Brocast("SmallPop","Your request has been sent.",80)
        go:_closePlayerInfo()
    end
    ct.OpenCtrl("CommonDialogCtrl", data)
end

-- 陌生人私聊
function ChatCtrl:OnChat()
    local activePlayerData = ChatCtrl.static.chatMgr:GetActivePlayerData()
    local strangersPlayerItem = ChatCtrl.static.chatMgr:GetStrangersPlayer().item
    ChatPanel.strangersToggle.isOn = true
    if strangersPlayerItem[activePlayerData.id] then
        strangersPlayerItem[activePlayerData.id].toggle.isOn = true
    else
        ChatCtrl.static.chatMgr:CreatePlayerItem(2, activePlayerData)

        local strangersPlayerItem = ChatCtrl.static.chatMgr:GetStrangersPlayer().item[activePlayerData.id]
        strangersPlayerItem.toggle.isOn = true
        ChatPanel.strangersPlayerNum.text = tostring(#ChatCtrl.static.chatMgr:GetStrangersPlayer().id)
    end
end

-- 查看聊天记录
function ChatCtrl:OnChatRecords(go)
    if ChatPanel.chatRecordsRoot.activeSelf then
        ChatPanel.chatRecordsRoot:SetActive(false)
        ChatPanel.playerInfoRoot:SetActive(true)
    else
        ChatPanel.chatRecordsRoot:SetActive(true)
        ChatPanel.playerInfoRoot:SetActive(false)
        ChatCtrl.static.chatMgr:ShowChatRecords()
    end
end

-- 显示个人信息界面
function ChatCtrl:OnShowPersonalInfo(go)
    if ChatCtrl.static.chatMgr.activePlayerData then
        go.isShowPersonalInfo = true
        ct.OpenCtrl("PersonalHomeDialogPageCtrl", ChatCtrl.static.chatMgr.activePlayerData)
    end
end

-- 删除聊天记录
function ChatCtrl:OnDeleteChatRecords(go)
    --ChatCtrl.static.chatMgr:ShowPageInfo()
    --打开弹框
    local data = {}
    data.titleInfo = "WARNING"
    data.contentInfo = "Are you sure to empty the chat records?"
    data.tipInfo = "(The production schedule will be empty!)"
    data.btnCallBack = function()
        ChatCtrl.static.chatMgr:DeleteChatRecords()
    end
    ct.OpenCtrl("BtnDialogPageCtrl", data)
end

-- 显示前一页
function ChatCtrl:OnPrev(go)
    ChatCtrl.static.chatMgr:ShowPageInfo(ChatCtrl.static.chatMgr:GetCurrentPage() - 1)
end

-- 显示后一页
function ChatCtrl:OnNext(go)
    ChatCtrl.static.chatMgr:ShowPageInfo(ChatCtrl.static.chatMgr:GetCurrentPage() + 1)
end

-- 屏蔽玩家
function ChatCtrl:OnShield(go)
    --打开弹框
    local data = {}
    data.titleInfo = "WARNING"
    data.contentInfo = "Delete the production line?"
    data.tipInfo = "(The production schedule will be empty!)"
    data.btnCallBack = function()
        ct.log("tina_w7_friends", "向服务器发送屏蔽请求")
        local activePlayerId = ChatCtrl.static.chatMgr:GetActivePlayerId()
        if activePlayerId then
            Event.Brocast("m_ChatAddBlacklist", { id = activePlayerId})
        end
        go:_closePlayerInfo()
    end
    ct.OpenCtrl("BtnDialogPageCtrl", data)
end

-- 按照是否离线排序
function ChatCtrl:_getSortDatas(data)
    local tempData = data
    table.sort(tempData, function (m, n)
        if m.b == n.b then
            return false
        else
            if m.b then
                return true
            else
                return false
            end
        end
    end)
    return tempData
end

-- 网络回调
-- 查询玩家信息
function ChatCtrl:c_OnReceivePlayerInfo(playerData)
    if ChatPanel.worldToggle.isOn then
        playerData.info[1].company = "Scry"
        ChatCtrl.static.chatMgr:ShowPlayerInfo(1, playerData.info[1])
    elseif ChatPanel.friendsToggle.isOn then
        ChatCtrl.friendInfo = {}
        if playerData.info then
            local data = {}
            local friends = DataManager.GetMyFriends()
            for _, v in ipairs(playerData.info) do
                v.b = friends[v.id]
                table.insert(data, v)
            end

            ChatCtrl.friendInfo = self:_getSortDatas(data)
            for _, n in ipairs(ChatCtrl.friendInfo) do
                ChatCtrl.static.chatMgr:CreatePlayerItem(1, n)
            end

            local chatFriendsInfo = DataManager.GetMyChatInfo(2)
            local friendsPlayerItem = ChatCtrl.static.chatMgr:GetFriendsPlayer().item
            local saveUnread = DataManager.GetUnread()
            for _, m in ipairs(playerData.info) do
                if m.id ~= ChatCtrl.static.chatMgr:GetActivePlayerId() then
                    local noticeNum = 0
                    if saveUnread and saveUnread[m.id] then
                        noticeNum = #saveUnread[m.id]
                    end
                    if chatFriendsInfo[m.id] then
                        noticeNum = noticeNum + chatFriendsInfo[m.id].unreadNum
                    end
                    friendsPlayerItem[m.id]:SetNoticeText(noticeNum)
                end
            end
        end
        ChatPanel.friendsNum.text = tostring(#ChatCtrl.friendInfo)
        if ChatCtrl.static.isShowClickFriends then
            local friendsPlayerItem = ChatCtrl.static.chatMgr:GetActivePlayerItem()
            friendsPlayerItem.toggle.isOn = true
            ChatCtrl.static.isShowClickFriends = false
            ChatPanel.friendsPlayerContent.anchoredPosition = Vector2.New(0,tonumber(127 * friendsPlayerItem.prefab.transform:GetSiblingIndex()))
        end
    elseif ChatPanel.strangersToggle.isOn then
        ChatCtrl.strangersInfo = {}
        if playerData.info then
            for _, v in ipairs(playerData.info) do
                table.insert(ChatCtrl.strangersInfo, v)
                ChatCtrl.static.chatMgr:CreatePlayerItem(2, v)
            end

            local chatStrangersInfo = DataManager.GetMyChatInfo(3)
            local strangersPlayerItem = ChatCtrl.static.chatMgr:GetStrangersPlayer().item
            for _, m in ipairs(playerData.info) do
                if m.id ~= ChatCtrl.static.chatMgr:GetActivePlayerId() then
                    strangersPlayerItem[m.id]:SetNoticeText(chatStrangersInfo[m.id].unreadNum)
                end
            end
        end
        ChatPanel.strangersPlayerNum.text = tostring(#ChatCtrl.strangersInfo)
        if ChatCtrl.static.isShowClickStrangers then
            ChatCtrl.static.isShowClickStrangers = false
            local strangersPlayerItem = ChatCtrl.static.chatMgr:GetActivePlayerItem()
            strangersPlayerItem.toggle.isOn = true
            ChatPanel.strangersPlayerNum.text = tostring(#ChatCtrl.static.chatMgr:GetStrangersPlayer().id)
            ChatPanel.strangersPlayerContent.anchoredPosition = Vector2.New(0, tonumber(127 * strangersPlayerItem.prefab.transform:GetSiblingIndex()))
        end
    end
end

-- 聊天
function ChatCtrl:c_OnReceiveRoleCommunication(chatData)
    if chatData.channel == "WORLD" then
        ChatCtrl.static.chatMgr:CreateChatItem(chatData)
        if ChatPanel.worldToggle.isOn then
            ChatCtrl.static.chatMgr:StartScrollBottom()
        end
    elseif chatData.channel == "FRIEND"then
        if ChatPanel.friendsToggle.isOn then
            if chatData.id == ChatCtrl.static.chatMgr:GetActivePlayerId() or chatData.id == DataManager.GetMyOwnerID() then
                ChatCtrl.static.chatMgr:CreateChatItem(chatData)
                ChatCtrl.static.chatMgr:StartScrollBottom()
            else
                local chatFriendsInfo = DataManager.GetMyChatInfo(2)
                local friendsPlayerItem = ChatCtrl.static.chatMgr:GetFriendsPlayer().item
                if friendsPlayerItem[chatData.id] then
                    local saveUnread = DataManager.GetUnread()
                    local noticeNum = chatFriendsInfo[chatData.id].unreadNum
                    if saveUnread and saveUnread[chatData.id] then
                        noticeNum = noticeNum + #saveUnread[chatData.id]
                    end
                    friendsPlayerItem[chatData.id]:SetNoticeText(noticeNum)
                end
            end
        else
            ChatPanel.friendsNoticeImage:SetActive(true)
        end
    elseif chatData.channel == "UNKNOWN" then
        if ChatPanel.strangersToggle.isOn then
            if chatData.id == ChatCtrl.static.chatMgr:GetActivePlayerId() or chatData.id == DataManager.GetMyOwnerID() then
                ChatCtrl.static.chatMgr:CreateChatItem(chatData)
                ChatCtrl.static.chatMgr:StartScrollBottom()
            else
                local chatStrangersInfo = DataManager.GetMyChatInfo(3)
                local strangersPlayerItem = ChatCtrl.static.chatMgr:GetStrangersPlayer().item
                if strangersPlayerItem[chatData.id] then
                    strangersPlayerItem[chatData.id]:SetNoticeText(chatStrangersInfo[chatData.id].unreadNum)
                end
            end
        else
            ChatPanel.strangersNoticeImage:SetActive(true)
        end
    end
    --self:_showWorldInfo()
end

-- 加入黑名单
function ChatCtrl:c_OnReceiveAddBlacklist(roleInfo)
    DataManager.SetMyBlacklist(roleInfo)
    DataManager.SetMyFriends({id = roleInfo.id})
    Event.Brocast("SmallPop","Shield success.",60)
    local activePlayerId = ChatCtrl.static.chatMgr:GetActivePlayerId()
    local strangersPlayerItem = ChatCtrl.static.chatMgr:GetStrangersPlayer().item
    local friendsPlayerItem = ChatCtrl.static.chatMgr:GetFriendsPlayer().item
    if friendsPlayerItem[roleInfo.id] then
        ChatCtrl.static.chatMgr:DestroyItem(1, roleInfo.id)
        if activePlayerId == roleInfo.id then
            ChatCtrl.static.chatMgr:SetToggle()
            ChatCtrl.static.chatMgr:DestroyContentChildren(2)
            ChatCtrl.static.chatMgr:SetActivePlayerData({})
            ChatPanel.friendsNum.text = tostring(#ChatCtrl.static.chatMgr:GetFriendsPlayer().id)
        end
    elseif strangersPlayerItem[roleInfo.id] then
        ChatCtrl.static.chatMgr:DestroyItem(2, roleInfo.id)
        DataManager.SetStrangersInfo(roleInfo.id)
        if activePlayerId == roleInfo.id then
            ChatCtrl.static.chatMgr:SetToggle()
            ChatCtrl.static.chatMgr:DestroyContentChildren(4)
            ChatCtrl.static.chatMgr:SetActivePlayerData({})
            ChatPanel.strangersPlayerNum.text = tostring(#ChatCtrl.static.chatMgr:GetStrangersPlayer().id)
        end
    end
end

-- 添加好友成功
function ChatCtrl:c_OnReceiveAddFriendSucess(roleInfo)
    if ChatPanel.friendsToggle.isOn then
        if not ChatCtrl.friendInfo then
            ChatCtrl.friendInfo = {}
        end
        table.insert(ChatCtrl.friendInfo, roleInfo)
        ChatCtrl.static.chatMgr:CreatePlayerItem(1, roleInfo, true)
        ChatPanel.friendsNum.text = tostring(#ChatCtrl.friendInfo)
    elseif ChatPanel.strangersToggle.isOn then
        local activePlayerId = ChatCtrl.static.chatMgr:GetActivePlayerId()
        if activePlayerId == roleInfo.id then
            ChatCtrl.static.chatMgr:SetToggle()
            ChatCtrl.static.chatMgr:DestroyContentChildren(4)
            ChatCtrl.static.chatMgr:SetActivePlayerData({})
        end
        ChatCtrl.static.chatMgr:DestroyItem(2, roleInfo.id)
        DataManager.SetStrangersInfo(roleInfo.id)
        ChatPanel.strangersPlayerNum.text = tostring(#ChatCtrl.static.chatMgr:GetStrangersPlayer().id)
    end
end

-- 好友上下线
function ChatCtrl:c_OnReceiveRoleStatusChange(roleData)
    if ChatPanel.friendsToggle.isOn then
        local friendsItem = ChatCtrl.static.chatMgr:GetFriendsPlayer().item[roleData.id]
        if roleData.b then
            friendsItem:SetHeadColor(true)
            friendsItem.prefab.transform:SetSiblingIndex(0)
        else
            friendsItem:SetHeadColor(false)
            friendsItem.prefab.transform:SetSiblingIndex(ChatPanel.friendsPlayerContent.childCount - 1)

        end
    end
end