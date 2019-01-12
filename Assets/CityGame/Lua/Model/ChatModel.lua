---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/12/14 10:06
---

ChatModel = class("ChatModel",ModelBase)

function ChatModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function ChatModel:OnCreate()
    -- 注册事件
    Event.AddListener("m_QueryPlayerInfoChat", self.m_QueryPlayerInfoChat)
    Event.AddListener("m_RoleCommunication", self.m_RoleCommunication)
    Event.AddListener("m_ChatAddFriends", self.m_ChatAddFriends)
    Event.AddListener("m_ChatAddBlacklist", self.m_ChatAddBlacklist)

    -- 网络回调注册
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","addBlacklist","gs.RoleInfo", self.n_OnReceiveAddBlacklist, self)
end

function ChatModel.Close()
    -- 清空事件
end

-- 向服务器查询好友信息
function ChatModel.m_QueryPlayerInfoChat(friendsIds)
    DataManager.ModelSendNetMes("gscode.OpCode", "queryPlayerInfo","gs.Bytes",{ ids = friendsIds })
end

-- 向服务器发送聊天消息
function ChatModel.m_RoleCommunication(chatData)
    DataManager.ModelSendNetMes("gscode.OpCode", "roleCommunication","gs.CommunicationReq",chatData)
end

-- 向服务器发送加好友
function ChatModel.m_ChatAddFriends(chatAddFriendsData)
    DataManager.ModelSendNetMes("gscode.OpCode", "addFriend","gs.ByteStr",chatAddFriendsData)
end

-- 向服务器发送加黑名单
function ChatModel.m_ChatAddBlacklist(friendsId)
    DataManager.ModelSendNetMes("gscode.OpCode", "addBlacklist","gs.Id",friendsId)
end

-- 加黑名单成功服务器返回
function ChatModel:n_OnReceiveAddBlacklist(roleInfo)
    Event.Brocast("c_OnReceiveAddBlacklist", roleInfo)
end