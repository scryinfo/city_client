---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/12/14 11:50
---

ChatMgr = class('ChatMgr')
ChatMgr.static.ExpressionBtnPATH = "View/Chat/ExpressionBtnItem"
ChatMgr.static.ChatRightItemPath = "View/Chat/ChatRightItem"
ChatMgr.static.ChatLeftItemPath = "View/Chat/ChatLeftItem"
ChatMgr.static.ChatTimeItemPath = "View/Chat/ChatTimeItem"
ChatMgr.static.ChatFriendsItemPath = "View/Chat/ChatFriendsItem"
ChatMgr.static.ChatRecordsItemPath = "View/Chat/ChatRecordsItem"
ChatMgr.static.ChatRecordsTimeItemPath = "View/Chat/ChatRecordsTimeItem"

function ChatMgr:initialize()
    ct.log("tina_w9_friends", "ChatMgr:initialize")
    self:initData()
end

function ChatMgr:initData()
    self.ownerId = DataManager.GetMyOwnerID()
    self.worldItem = {} -- 世界聊天Item
    self.friendsItem = {} -- 好友聊天Item
    self.friendsTimeItem = {} -- 好友聊天时间显示Item
    self.activePlayerData = {} -- 当前操作的玩家ID
    self.friendsToggle = nil
    self.strangersItem = {} -- 陌生人聊天Item
    self.playerChoice = -- 好友、陌生人玩家信息Item、id
    {
        { item = {}, id = {} },
        { item = {}, id = {} },
        { item = {}, id = {} }
    }
    --self.nowShowChatInfoNum = 0 -- 当前显示的index索引
    --self.isShowChatInfo = false
    self.chatRecordsItemTab = {} -- 保存聊天记录的Item们
    self.chatRecordsTimeItemTab = {} -- 保存聊天记录的时间Item们
    self.guildItem = {} -- 公会聊天Item
end

-- 设置活动滑动条
function ChatMgr:SetRootScrollbar(scrollbar)
    if scrollbar == 1 then
        self.rootScrollbar = ChatPanel.worldVerticalScrollbar
    elseif scrollbar == 2 then
        self.rootScrollbar = ChatPanel.friendsVerticalScrollbar
    elseif scrollbar == 3 then
        self.rootScrollbar = ChatPanel.strangersVerticalScrollbar
    elseif scrollbar == 4 then
        self.rootScrollbar = ChatPanel.guildVerticalScrollbar
    end
end

-- 设置活动的Item
function ChatMgr:SetToggle(friendsToggle)
    if self.friendsToggle then
        self.friendsToggle.isOn = false
        self.friendsToggle.interactable = true
    end
    if friendsToggle then
        self.friendsToggle = friendsToggle
    else
        self.friendsToggle = nil
    end
end

-- 设置活动玩家的ID
function ChatMgr:SetActivePlayerId(friendsId)
    self.activePlayerData.id = friendsId
end

-- 获得活动玩家的ID
function ChatMgr:GetActivePlayerId()
    return self.activePlayerData.id
end

-- 设置活动玩家数据
function ChatMgr:SetActivePlayerData(data)
    self.activePlayerData = data
end

-- 获得玩家数据
function ChatMgr:GetActivePlayerData()
    return self.activePlayerData
end

-- 获得好友列表Item
function ChatMgr:GetFriendsPlayer()
    return self.playerChoice[1]
end

-- 获得陌生人列表Item
function ChatMgr:GetStrangersPlayer()
    return self.playerChoice[2]
end

-- 获得陌生人列表Item
function ChatMgr:GetCurrentPage()
    return self.currentPage
end

-- 获得玩家的头像ID
function ChatMgr:GetPlayerFaceId(id)
    for _, v in ipairs(self.playerChoice) do
        if v.item[id] then
            return v.item[id].data.faceId
        end
    end
end

-- 删除单个Item
function ChatMgr:DestroyItem(index, id)
    if self.playerChoice[index].item[id] then
        UnityEngine.GameObject.Destroy(self.playerChoice[index].item[id].prefab)
    end
    self.playerChoice[index].item[id] = nil
    if not self.playerChoice[index].id then
        return
    end
    for i, v in ipairs(self.playerChoice[index].id) do
        if v == id then
            table.remove(self.playerChoice[index].id, i)
        end
    end
end

-- 清空列表
function ChatMgr:DestroyContentChildren(index)
    if index == 0 then -- 删除世界列表Item
        for _, v in pairs(self.worldItem) do
            UnityEngine.GameObject.Destroy(v.prefab)
        end
        self.worldItem = {}
    elseif index == 1 then -- 删除好友列表Item
        if not self.playerChoice[1].item then
            return
        end
        for _, v in pairs(self.playerChoice[1].item) do
            UnityEngine.GameObject.Destroy(v.prefab)
        end
        self.playerChoice[1].item = {}
        self.playerChoice[1].id = {}
    elseif index == 2 then -- 删除好友聊天Item
        for _, v in ipairs(self.friendsItem) do
            UnityEngine.GameObject.Destroy(v.prefab)
        end
        for _, v in ipairs(self.friendsTimeItem) do
            UnityEngine.GameObject.Destroy(v.prefab)
        end
        self.friendsItem = {}
        self.friendsTimeItem = {}
        --self.nowShowChatInfoNum = 0
        --self.isShowChatInfo = false
        --ChatCtrl:AddListenerScrollView(2, false)
    elseif index == 3 then -- 删除陌生人列表Item
        if not self.playerChoice[2].item then
            return
        end
        for _, v in pairs(self.playerChoice[2].item) do
            UnityEngine.GameObject.Destroy(v.prefab)
        end
        self.playerChoice[2].item = {}
        self.playerChoice[2].id = {}
    elseif index == 4 then -- 删除陌生人聊天Item
        for _, v in ipairs(self.strangersItem) do
            UnityEngine.GameObject.Destroy(v.prefab)
        end
        for _, v in ipairs(self.friendsTimeItem) do
            UnityEngine.GameObject.Destroy(v.prefab)
        end
        self.strangersItem = {}
        self.friendsTimeItem = {}
    elseif index == 5 then -- 删除公会列表Item
        if not self.playerChoice[3].item then
            return
        end
        for _, v in pairs(self.playerChoice[3].item) do
            UnityEngine.GameObject.Destroy(v.prefab)
        end
        self.playerChoice[3].item = {}
        self.playerChoice[3].id = {}
    elseif index == 6 then -- 删除公会聊天Item
        for _, v in ipairs(self.guildItem) do
            UnityEngine.GameObject.Destroy(v.prefab)
        end
        self.guildItem = {}
    end
end

-- 获得活动玩家的列表item
function ChatMgr:GetActivePlayerItem()
    for _, v in ipairs(self.playerChoice) do
        if v.item[self.activePlayerData.id] then
            return v.item[self.activePlayerData.id]
        end
    end
end

--创建表情
function ChatMgr:CreateExpression()
    for i = 1, 80 do -- 生成80个表情
        local prefab = self:_createNoticePab(ChatMgr.static.ExpressionBtnPATH, ChatPanel.expressionContent)
        local ExpressionBtnItem = ExpressionBtnItem:new(i,prefab)
    end
end

--创建聊天Item
function ChatMgr:CreateChatItem(chatData, isOthers)
    if self.ownerId == chatData.id then
        if chatData.channel == "WORLD" then -- 代表世界频道
            local prefab = self:_createNoticePab(ChatMgr.static.ChatRightItemPath, ChatPanel.worldContent)
            local chatRightItem = ChatRightItem:new(#self.worldItem + 1, prefab, chatData)
            table.insert(self.worldItem, chatRightItem)
            if #self.worldItem > ChatCtrl.WORLD_SHOW_NUM then
                UnityEngine.GameObject.Destroy(self.worldItem[1].prefab)
                table.remove(self.worldItem, 1)
            end
        elseif chatData.channel == "FRIEND" and chatData.channelId == self.activePlayerData.id then -- 代表好友频道
            --local isHaveTime = false
            if self.friendsItem[#self.friendsItem] and chatData.time - self.friendsItem[#self.friendsItem].data.time > 60000 then
                local prefab = self:_createNoticePab(ChatMgr.static.ChatTimeItemPath, ChatPanel.friendsContent)
                local chatTimeItem = ChatTimeItem:new(prefab, chatData.time)
                table.insert(self.friendsTimeItem, chatTimeItem)
                --if isOthers then
                --    isHaveTime = true
                --    prefab.transform:SetSiblingIndex(0)
                --end
            end
            local prefab = self:_createNoticePab(ChatMgr.static.ChatRightItemPath, ChatPanel.friendsContent)
            local chatRightItem = ChatRightItem:new(#self.friendsItem + 1, prefab, chatData)
            table.insert(self.friendsItem, chatRightItem)
            --if isOthers then
            --    if isHaveTime then
            --        prefab.transform:SetSiblingIndex(1)
            --    else
            --        prefab.transform:SetSiblingIndex(0)
            --    end
            --end
            DataManager.SetMyReadChatInfo(2, chatData.channelId)
        elseif chatData.channel == "UNKNOWN" and chatData.channelId == self.activePlayerData.id then -- 代表陌生人频道
            if self.strangersItem[#self.strangersItem] and chatData.time - self.strangersItem[#self.strangersItem].data.time > 60000 then
                local prefab = self:_createNoticePab(ChatMgr.static.ChatTimeItemPath, ChatPanel.strangersContent)
                local chatTimeItem = ChatTimeItem:new(prefab, chatData.time)
                table.insert(self.friendsTimeItem, chatTimeItem)
            end
            local prefab = self:_createNoticePab(ChatMgr.static.ChatRightItemPath, ChatPanel.strangersContent)
            local chatRightItem = ChatRightItem:new(#self.strangersItem + 1, prefab, chatData)
            table.insert(self.strangersItem, chatRightItem)
            DataManager.SetMyReadChatInfo(3, chatData.channelId)
        elseif chatData.channel == "GROUP" then -- 代表世界频道
            local prefab = self:_createNoticePab(ChatMgr.static.ChatRightItemPath, ChatPanel.guildContent)
            local chatRightItem = ChatRightItem:new(#self.guildItem + 1, prefab, chatData)
            table.insert(self.guildItem, chatRightItem)
            if #self.guildItem > ChatCtrl.WORLD_SHOW_NUM then
                UnityEngine.GameObject.Destroy(self.guildItem[1].prefab)
                table.remove(self.guildItem, 1)
            end
        end
    else
        if chatData.channel == "WORLD" then -- 代表世界频道
            local prefab = self:_createNoticePab(ChatMgr.static.ChatLeftItemPath, ChatPanel.worldContent)
            local chatLeftItem = ChatLeftItem:new(#self.worldItem + 1, prefab, chatData)
            table.insert(self.worldItem, chatLeftItem)
            if #self.worldItem > ChatCtrl.WORLD_SHOW_NUM then
                UnityEngine.GameObject.Destroy(self.worldItem[1].prefab)
                table.remove(self.worldItem, 1)
            end
        elseif chatData.channel == "FRIEND" and chatData.id == self.activePlayerData.id then -- 代表好友频道
            --local isHaveTime = false
            if self.friendsItem[#self.friendsItem] and chatData.time - self.friendsItem[#self.friendsItem].data.time > 60000 then
                local prefab = self:_createNoticePab(ChatMgr.static.ChatTimeItemPath, ChatPanel.friendsContent)
                local chatTimeItem = ChatTimeItem:new(prefab, chatData.time)
                table.insert(self.friendsTimeItem, chatTimeItem)
                --if isOthers then
                --    isHaveTime = true
                --    prefab.transform:SetSiblingIndex(0)
                --end
            end
            local prefab = self:_createNoticePab(ChatMgr.static.ChatLeftItemPath, ChatPanel.friendsContent)
            local chatLeftItem = ChatLeftItem:new(#self.friendsItem + 1, prefab, chatData)
            table.insert(self.friendsItem, chatLeftItem)
            --if isOthers then
            --    if isHaveTime then
            --        prefab.transform:SetSiblingIndex(1)
            --    else
            --        prefab.transform:SetSiblingIndex(0)
            --    end
            --end
            DataManager.SetMyReadChatInfo(2, chatData.id)
        elseif chatData.channel == "UNKNOWN" and chatData.id == self.activePlayerData.id then -- 代表陌生人频道
            if self.strangersItem[#self.strangersItem] and chatData.time - self.strangersItem[#self.strangersItem].data.time > 60000 then
                local prefab = self:_createNoticePab(ChatMgr.static.ChatTimeItemPath, ChatPanel.strangersContent)
                local chatTimeItem = ChatTimeItem:new(prefab, chatData.time)
                table.insert(self.friendsTimeItem, chatTimeItem)
            end
            local prefab = self:_createNoticePab(ChatMgr.static.ChatLeftItemPath, ChatPanel.strangersContent)
            local chatLeftItem = ChatLeftItem:new(#self.strangersItem + 1, prefab, chatData)
            table.insert(self.strangersItem, chatLeftItem)
            DataManager.SetMyReadChatInfo(3, chatData.id)
        elseif chatData.channel == "GROUP" then -- 代表世界频道
            local prefab = self:_createNoticePab(ChatMgr.static.ChatLeftItemPath, ChatPanel.guildContent)
            local chatLeftItem = ChatLeftItem:new(#self.guildItem + 1, prefab, chatData)
            table.insert(self.guildItem, chatLeftItem)
            if #self.guildItem > ChatCtrl.WORLD_SHOW_NUM then
                UnityEngine.GameObject.Destroy(self.guildItem[1].prefab)
                table.remove(self.guildItem, 1)
            end
        end
    end
end

-- 创建人员显示列表
function ChatMgr:CreatePlayerItem(index, playerData, isFrist)
    if index == 1 then
        table.insert(self.playerChoice[1].id, playerData.id)
        local prefab = self:_createNoticePab(ChatMgr.static.ChatFriendsItemPath, ChatPanel.friendsPlayerContent)
        local chatFriendsItem = ChatFriendsItem:new(#self.playerChoice[1].id, 1, prefab, isFrist, playerData)
        self.playerChoice[1].item[playerData.id] = chatFriendsItem
    elseif index == 2 then
        table.insert(self.playerChoice[2].id, playerData.id)
        local prefab = self:_createNoticePab(ChatMgr.static.ChatFriendsItemPath, ChatPanel.strangersPlayerContent)
        local chatFriendsItem = ChatFriendsItem:new(#self.playerChoice[2].id, 2, prefab, isFrist, playerData)
        self.playerChoice[2].item[playerData.id] = chatFriendsItem
    elseif index == 3 then
        table.insert(self.playerChoice[3].id, playerData.id)
        local prefab = self:_createNoticePab(ChatMgr.static.ChatFriendsItemPath, ChatPanel.guildMemberContent)
        local chatFriendsItem = ChatFriendsItem:new(#self.playerChoice[3].id, 3, prefab, isFrist, playerData)
        self.playerChoice[3].item[playerData.id] = chatFriendsItem
    end
end

-- 显示玩家的信息面板
function ChatMgr:ShowPlayerInfo(index, data)
    ChatPanel.playerInfoRoot:SetActive(true)
    ChatPanel.nameText.text = data.name
    ChatPanel.companyText.text = data.companyName
    self:SetActivePlayerData(data)
    --LoadSprite(PlayerHead[data.faceId].HalfBodyPath, ChatPanel.headImage, true)
    if self.avatarData then
        AvatarManger.CollectAvatar(self.avatarData)
    end
    self.avatarData = AvatarManger.GetSmallAvatar(data.faceId, ChatPanel.headImage,0.5)
    if index == 1 then -- 世界界面陌生人信息显示
        ChatPanel.shieldBtn:SetActive(true)
        ChatPanel.addFriendsBtn:SetActive(true)
        ChatPanel.chatBtn:SetActive(true)
        ChatPanel.shieldBtn:GetComponent("RectTransform").anchoredPosition = Vector2.New(0, -292)
        ChatPanel.addFriendsBtn:GetComponent("RectTransform").anchoredPosition = Vector2.New(-125, -292)
    elseif index == 2 then -- 好友界面好友信息显示
        --ChatPanel.backChatBtn:SetActive(true)
        ChatPanel.shieldBtn:SetActive(true)
        ChatPanel.addFriendsBtn:SetActive(false)
        ChatPanel.chatBtn:SetActive(false)
        ChatPanel.shieldBtn:GetComponent("RectTransform").anchoredPosition = Vector2.New(0, -292)
    elseif index == 3 then -- 陌生人界面陌生人信息显示
        --ChatPanel.backChatBtn:SetActive(true)
        ChatPanel.shieldBtn:SetActive(true)
        ChatPanel.addFriendsBtn:SetActive(true)
        ChatPanel.chatBtn:SetActive(false)
        ChatPanel.shieldBtn:GetComponent("RectTransform").anchoredPosition = Vector2.New(125, -292)
        ChatPanel.addFriendsBtn:GetComponent("RectTransform").anchoredPosition = Vector2.New(-125, -292)
    elseif index == 4 then -- 公会界面玩家信息显示
        -- 判断是否是自己的好友
        local friendsBasicData = DataManager.GetMyFriends()
        if friendsBasicData[data.id] == nil then
            ChatPanel.shieldBtn:SetActive(false)
            ChatPanel.addFriendsBtn:SetActive(true)
            ChatPanel.chatBtn:SetActive(false)
            ChatPanel.addFriendsBtn:GetComponent("RectTransform").anchoredPosition = Vector2.New(0, -292)
        else
            ChatPanel.shieldBtn:SetActive(false)
            ChatPanel.addFriendsBtn:SetActive(false)
            ChatPanel.chatBtn:SetActive(false)
        end
    end
end

--生成预制
function ChatMgr:_createNoticePab(path,parent)
    local prefab = UnityEngine.Resources.Load(path)
    local go = UnityEngine.GameObject.Instantiate(prefab)
    local rect = go.transform:GetComponent("RectTransform")
    go.transform:SetParent(parent.transform)
    rect.transform.localScale = Vector3.one
    return go
end

-- 显示已有的聊天记录
function ChatMgr:ShowAllChatInfo(index, id)
    local chatInfo = {}
    local saveUnread = DataManager.GetUnread()
    if index == 2 then
        if saveUnread and saveUnread[id] then
            for _, a in pairs(saveUnread[id]) do
                table.insert(chatInfo, a)
            end
        end
    end
    if DataManager.GetMyChatInfo(index)[id] then
        local onlineChatInfo = DataManager.GetMyChatInfo(index)[id].chatInfo
        for _, b in pairs(onlineChatInfo) do
            table.insert(chatInfo, b)
        end
    end

    for _, v in ipairs(chatInfo) do
        self:CreateChatItem(v)
    end

    --local firendsInfoAllNum = #chatInfo
    --if firendsInfoAllNum <= 0 then
    --    return
    --end
    --if firendsInfoAllNum <= ChatCtrl.FRIENDS_SHOW_NUM then
    --    for _, v in ipairs(chatInfo) do
    --        self:CreateChatItem(v)
    --    end
    --else
    --    for i = firendsInfoAllNum - ChatCtrl.FRIENDS_SHOW_NUM + 1, firendsInfoAllNum do
    --        self:CreateChatItem(chatInfo[i])
    --    end
    --    self.nowShowChatInfoNum = firendsInfoAllNum - ChatCtrl.FRIENDS_SHOW_NUM
    --    self.isShowChatInfo = true
    --end
    --ChatCtrl:AddListenerScrollView(index, true)
    --self:StartScrollBottom()
end

-- 显示已有的聊天记录
--function ChatMgr:ShowOtherChatInfo(index)
--    if not DataManager.GetMyChatInfo(index)[self.activePlayerData.id] then
--        return
--    end
--
--    if self.nowShowChatInfoNum <= 0 then
--        return
--    end
--
--    local chatInfo = DataManager.GetMyChatInfo(index)[self.activePlayerData.id].chatInfo
--    if self.nowShowChatInfoNum - ChatCtrl.FRIENDS_SHOW_NUM > 0 then
--        for i = self.nowShowChatInfoNum, self.nowShowChatInfoNum - ChatCtrl.FRIENDS_SHOW_NUM + 1, -1 do
--            self:CreateChatItem(chatInfo[i], true)
--        end
--        self.nowShowChatInfoNum = self.nowShowChatInfoNum - ChatCtrl.FRIENDS_SHOW_NUM
--        self.isShowChatInfo = true
--    else
--        for j = self.nowShowChatInfoNum, 1, -1 do
--            self:CreateChatItem(chatInfo[j], true)
--        end
--        self.nowShowChatInfoNum = 0
--        self.isShowChatInfo = false
--    end
--end

-- 查看聊天记录、获得好友聊天记录的数据
function ChatMgr:ShowChatRecords()
    self.chatRecordsId = self.activePlayerData.id -- 当前显示的那位玩家的聊天记录
    self.chatRecordsInfo = {} -- 某个好友的聊天数据
    self.chatRecordsIndex = {} -- 某个好友的聊天数据ID
    self.chatRecordsTime = nil

    local allFriendsInfo = DataManager.GetChatRecords()
    if allFriendsInfo then
        for i, v in ipairs(allFriendsInfo) do
            if self.chatRecordsId == v.id then
                table.insert(self.chatRecordsInfo, v)
                table.insert(self.chatRecordsIndex, i)
            elseif self.chatRecordsId == v.channelId then
                table.insert(self.chatRecordsInfo, v)
                table.insert(self.chatRecordsIndex, i)
            end
        end
        self.totalPage =  math.ceil(#self.chatRecordsInfo/ChatCtrl.CHAT_RECORDS_SHOW_NUM)
        self:ShowPageInfo(self.totalPage)
    end
end

-- 清空聊天记录的Item
function ChatMgr:DestroyChatRecordsItem()
    for _, a in ipairs(self.chatRecordsItemTab) do
        UnityEngine.GameObject.Destroy(a.prefab)
    end
    self.chatRecordsItemTab = {}

    for _, b in ipairs(self.chatRecordsTimeItemTab) do
        UnityEngine.GameObject.Destroy(b.prefab)
    end
    self.chatRecordsTimeItemTab = {}
    ChatPanel.pageText.text = ""
end

-- 显示某一页的数据
function ChatMgr:ShowPageInfo(page)
    self:DestroyChatRecordsItem()

    if page == 0 then
        ChatPanel.prevButton.interactable = false
        ChatPanel.prevClose:SetActive(true)
        ChatPanel.prevOpen:SetActive(false)
        ChatPanel.nextButton.interactable = false
        ChatPanel.nextClose:SetActive(true)
        ChatPanel.nextOpen:SetActive(false)
    elseif page == 1 then
        ChatPanel.prevButton.interactable = false
        ChatPanel.prevClose:SetActive(true)
        ChatPanel.prevOpen:SetActive(false)
        if self.totalPage == 1 then
            ChatPanel.nextButton.interactable = false
            ChatPanel.nextClose:SetActive(true)
            ChatPanel.nextOpen:SetActive(false)
        else
            ChatPanel.nextButton.interactable = true
            ChatPanel.nextClose:SetActive(false)
            ChatPanel.nextOpen:SetActive(true)
        end
    elseif  page == self.totalPage then
        ChatPanel.prevButton.interactable = true
        ChatPanel.prevClose:SetActive(false)
        ChatPanel.prevOpen:SetActive(true)
        ChatPanel.nextButton.interactable = false
        ChatPanel.nextClose:SetActive(true)
        ChatPanel.nextOpen:SetActive(false)
    else
        ChatPanel.prevButton.interactable = true
        ChatPanel.prevClose:SetActive(false)
        ChatPanel.prevOpen:SetActive(true)
        ChatPanel.nextButton.interactable = true
        ChatPanel.nextClose:SetActive(false)
        ChatPanel.nextOpen:SetActive(true)
    end

    self.currentPage = page
    ChatPanel.pageText.text = string.format("%s/%s", self.currentPage, self.totalPage)
    for i = #self.chatRecordsInfo - (self.totalPage - self.currentPage + 1) * ChatCtrl.CHAT_RECORDS_SHOW_NUM + 1, #self.chatRecordsInfo - (self.totalPage - self.currentPage) * ChatCtrl.CHAT_RECORDS_SHOW_NUM do
        if self.chatRecordsInfo[i] then
            self:CreateChatRecordsItem(self.chatRecordsInfo[i])
        end
    end
end

-- 创建聊天记录的聊天
function ChatMgr:CreateChatRecordsItem(chatData)
    if self.chatRecordsTime and chatData.time - self.chatRecordsTime > 60000 then
        local prefab = self:_createNoticePab(ChatMgr.static.ChatRecordsTimeItemPath, ChatPanel.chatRecordsContent)
        local chatRecordsTimeItem = ChatRecordsTimeItem:new(prefab, chatData.time)
        table.insert(self.chatRecordsTimeItemTab, chatRecordsTimeItem)
    end
    local isSelf = false
    if self.ownerId == chatData.id then
        isSelf = true
    end
    local prefab = self:_createNoticePab(ChatMgr.static.ChatRecordsItemPath, ChatPanel.chatRecordsContent)
    self.chatRecordsTime = chatData.time
    local chatRecordsItem = ChatRecordsItem:new(isSelf, prefab, chatData)
    table.insert(self.chatRecordsItemTab, chatRecordsItem)
end

-- 删除聊天记录
function ChatMgr:DeleteChatRecords()
    for i = #self.chatRecordsIndex, 1, -1 do
        DataManager.SetChatRecords(self.chatRecordsIndex[i])
    end
    DataManager.SaveFriendsChat()
    self:DestroyChatRecordsItem()
end

-- 删除公会聊天记录
function ChatMgr:DeleteGuildChatRecords()
    self:DestroyContentChildren(6)
    DataManager.SetGuildChatInfo()
end

--滑动到底部
function ChatMgr:_scrollBottom()
    if not self.rootScrollbar then
        return
    end

    if  UnityEngine.Time.time> self.timeNow then
        self.rootScrollbar.value = 0
        UpdateBeat:Remove(self._scrollBottom, self)
    end
end

function ChatMgr:StartScrollBottom()
    self.timeNow = UnityEngine.Time.time + 0.1
    UpdateBeat:Add(self._scrollBottom, self)
end