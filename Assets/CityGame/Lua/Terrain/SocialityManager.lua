---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/12/14 17:16
---

SocialityManager = class('SocialityManager')

function SocialityManager:initialize()
    self.path = CityLuaUtil.getAssetsPath().."/client.data"
    self.m_friends = {}
    self.m_chatInfo = {}
    self.m_chatByType = {{}, {}, {}, {}}
    self.m_friendsApply = {}
    self.m_blacklist = {}
    self.mySaveRoleCom = { id = DataManager.GetMyOwnerID(), readCommunication = {}, unreadCommunication = {}}
    self.isReadGuildChatInfo = false
    self:ReadFriendsChat()
end

function SocialityManager:SetMyFriends(friendsData)
    if friendsData.id then
        self.m_friends[friendsData.id] = friendsData.b
    end
end

function SocialityManager:GetMyFriends()
    local friendsIdTemp = {}
    for i, v in pairs(self.m_friends) do
        if v ~= nil then
            friendsIdTemp[i] = v
        end
    end
    return friendsIdTemp
end

function SocialityManager:SetMyChatInfo(chatData)
    table.insert(self.m_chatInfo, chatData)
    if chatData.channel == "WORLD" then
        table.insert(self.m_chatByType[1], chatData)
    elseif chatData.channel == "FRIEND" then
        local dataId
        if DataManager.GetMyOwnerID() == chatData.id then
            dataId = chatData.channelId
        else
            dataId = chatData.id
        end
        if not self.m_chatByType[2][dataId] then
            self.m_chatByType[2][dataId] = {}
        end
        if not self.m_chatByType[2][dataId].chatInfo then
            self.m_chatByType[2][dataId].chatInfo = {}
        end
        if DataManager.GetMyOwnerID() ~= chatData.id then
            if self.m_chatByType[2][dataId].unreadNum then
                self.m_chatByType[2][dataId].unreadNum = self.m_chatByType[2][dataId].unreadNum + 1
            else
                self.m_chatByType[2][dataId].unreadNum = 1
            end
        end
        if not self.m_chatByType[2][dataId].unreadChatInfo then
            self.m_chatByType[2][dataId].unreadChatInfo = {}
        end
        table.insert(self.m_chatByType[2][dataId].unreadChatInfo, chatData)
        table.insert(self.m_chatByType[2][dataId].chatInfo, chatData)
        table.insert(self.mySaveRoleCom.readCommunication, chatData)
        self:SaveFriendsChat()
    elseif chatData.channel == "UNKNOWN" then
        local dataId
        if DataManager.GetMyOwnerID() == chatData.id then
            dataId = chatData.channelId
        else
            dataId = chatData.id
        end
        if not self.m_chatByType[3][dataId] then
            self.m_chatByType[3][dataId] = {}
        end
        if not self.m_chatByType[3][dataId].chatInfo then
            self.m_chatByType[3][dataId].chatInfo = {}
        end
        if DataManager.GetMyOwnerID() ~= chatData.id then
            if self.m_chatByType[3][dataId].unreadNum then
                self.m_chatByType[3][dataId].unreadNum = self.m_chatByType[3][dataId].unreadNum + 1
            else
                self.m_chatByType[3][dataId].unreadNum = 1
            end
        end
        table.insert(self.m_chatByType[3][dataId].chatInfo, chatData)
    elseif chatData.channel == "GROUP" then
        table.insert(self.m_chatByType[4], chatData)
        self.isReadGuildChatInfo = true
    end
end

function SocialityManager:SetMyReadChatInfo(index, id)
    if self.m_chatByType[index][id] then
        self.m_chatByType[index][id].unreadNum = 0
        if index == 2 then
            self.m_chatByType[2][id].unreadChatInfo = {}
        end
    end
    if index == 2 then
        if self.unread and self.unread[id] and self.unread[id][1] then
            self.unread[id] = nil
        end
        self:SaveFriendsChat()
    end
end

--1 Get world news 2 Get friend news 3 Get stranger news 4 Get guild news
function SocialityManager:GetMyChatInfo(index)
    return self.m_chatByType[index]
end

--all info 
function SocialityManager:GetMyAllChatInfo()
    return self.m_chatInfo
end

--Get your friend's application information
function SocialityManager:GetMyFriendsApply()
    return self.m_friendsApply
end

--Refresh your friend application information
--Parameter: tempData==> RequestFriend
--If you need to delete your friend application,ByteBool={ id = "XXXXXXXX",name = nil }
function SocialityManager:SetMyFriendsApply(tempData)
    if tempData.id and tempData.name then
        for i, v in ipairs(self.m_friendsApply) do
            if v.id == tempData.id then
                table.remove(self.m_friendsApply, i)
                break
            end
        end
        table.insert(self.m_friendsApply, tempData)
    elseif tempData.itemId and not tempData.id then
        table.remove(self.m_friendsApply, tempData.itemId)
    end
end

--Get yourself blacklist
function SocialityManager:GetMyBlacklist()
    return self.m_blacklist
end

--Refresh yourself blacklist
--Parameter: tempData==> Bytes
--If you need to delete the blacklist,tempData={ id = "XXXXXXXX",name = nil }
function SocialityManager:SetMyBlacklist(tempData)
    if tempData.id and tempData.name then
        table.insert(self.m_blacklist, tempData)
    elseif tempData.id and not tempData.name then
        for i, v in ipairs(self.m_blacklist) do
            if v.id == tempData.id then
                table.remove(self.m_blacklist, i)
                break
            end
        end
    end
end

-- Save chat history
function SocialityManager:SaveFriendsChat()
    local tempUnreadCommunication = {}
    if self.unread then
        for _, a in pairs(self.unread) do
            for _, c in ipairs(a) do
                table.insert(tempUnreadCommunication, c)
            end
        end
    end
    for _, n in pairs(self.m_chatByType[2]) do
        if n.unreadChatInfo then
            for _, b in ipairs(n.unreadChatInfo) do
                table.insert(tempUnreadCommunication, b)
            end
        end
    end
    self.mySaveRoleCom.unreadCommunication = tempUnreadCommunication
    if self.saveRoleCom then
        if self.idIndex then
            self.saveRoleCom.allRoleCom[self.idIndex] = self.mySaveRoleCom
        else
            table.insert(self.saveRoleCom.allRoleCom, self.mySaveRoleCom)
            self.idIndex = #self.saveRoleCom.allRoleCom
        end
    else
        self.saveRoleCom = {allRoleCom = {self.mySaveRoleCom}}
        self.idIndex = 1
    end
    local pMsg = assert(pbl.encode("client.AllRoleCommunication", self.saveRoleCom))
    ct.file_saveString(self.path,pMsg)
end

-- 上线时读取，聊天记录
function SocialityManager:ReadFriendsChat()
    local str = ct.file_readString(self.path)
    if str ~= nil then
        self.saveRoleCom = assert(pbl.decode("client.AllRoleCommunication", str), "pbl.decode decode failed")
        for i, v in ipairs(self.saveRoleCom.allRoleCom) do
            if v.id == DataManager.GetMyOwnerID() then
                self.idIndex = i
                self.mySaveRoleCom = v
                if not self.mySaveRoleCom.readCommunication then
                    self.mySaveRoleCom.readCommunication = {}
                end
                if v.unreadCommunication then
                    for _, m in ipairs(v.unreadCommunication) do
                        local dataId = m.id
                        if not self.unread then
                            self.unread = {}
                        end
                        if not self.unread[dataId] then
                            self.unread[dataId] = {}
                        end
                        table.insert(self.unread[dataId], m)
                    end
                end
                break
            end
        end
    end
    --local cRoleCommunication = msg.allRoleCom[1].cRoleCommunication[1].readCommunication[1].name
end

-- Find the last unread message
function SocialityManager:GetUnread()
    return self.unread
end

-- Clear chat messages from strangers
function SocialityManager:SetStrangersInfo(id)
    self.m_chatByType[3][id] = nil
end

-- Get all chat history of friends
function SocialityManager:GetChatRecords()
    return self.mySaveRoleCom.readCommunication
end

-- Delete chat history
function SocialityManager:SetChatRecords(index)
    table.remove(self.mySaveRoleCom.readCommunication, index)
end

-- Clear guild chat messages
function SocialityManager:SetGuildChatInfo()
    self.m_chatByType[4] = {}
end

-- Get the information about whether to view the affiliate chat
function SocialityManager:GetIsReadGuildChatInfo()
    return  self.isReadGuildChatInfo
end

-- Set whether or not to view information in affiliate chat
function SocialityManager:SetIsReadGuildChatInfo(read)
    self.isReadGuildChatInfo = read
end