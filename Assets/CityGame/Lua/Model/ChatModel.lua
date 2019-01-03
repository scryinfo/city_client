---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/12/14 10:06
---

local pbl = pbl

ChatModel = {}
local this = ChatModel

function ChatModel.New()
    return this
end

function ChatModel.Awake()
    this:OnCreate()
end

function ChatModel.OnCreate()
    -- 注册事件
    Event.AddListener("m_QueryPlayerInfoChat", this.m_QueryPlayerInfoChat)
    Event.AddListener("m_RoleCommunication", this.m_RoleCommunication)
    Event.AddListener("m_ChatAddFriends", this.m_ChatAddFriends)
    Event.AddListener("m_ChatAddBlacklist", this.m_ChatAddBlacklist)

    -- 网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","addBlacklist"),ChatModel.n_OnReceiveAddBlacklist)
end

function ChatModel.Close()
    -- 清空事件
    Event.RemoveListener("m_QueryPlayerInfoChat", this.m_QueryPlayerInfoChat)
    Event.RemoveListener("m_RoleCommunication", this.m_RoleCommunication)
    Event.RemoveListener("m_ChatAddFriends", this.m_ChatAddFriends)
    Event.RemoveListener("m_ChatAddBlacklist", this.m_ChatAddBlacklist)
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
function ChatModel.n_OnReceiveAddBlacklist(stream)
    local roleInfo = assert(pbl.decode("gs.RoleInfo", stream), "ChatModel.n_OnReceiveAddBlacklist: stream == nil")
    Event.Brocast("c_OnReceiveAddBlacklist", roleInfo)
end