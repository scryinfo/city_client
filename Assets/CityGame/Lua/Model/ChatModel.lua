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

    -- 网络回调注册

end

function ChatModel.Close()
    -- 清空事件
    Event.RemoveListener("m_QueryPlayerInfoChat", this.m_QueryPlayerInfoChat)
    Event.RemoveListener("m_RoleCommunication", this.m_RoleCommunication)
end

-- 向服务器查询好友信息
function ChatModel.m_QueryPlayerInfoChat(friendsIds)
    DataManager.ModelSendNetMes("gscode.OpCode", "queryPlayerInfo","gs.Bytes",{ ids = friendsIds })
end

-- 向服务器发送聊天消息
function ChatModel.m_RoleCommunication(chatData)
    DataManager.ModelSendNetMes("gscode.OpCode", "roleCommunication","gs.CommunicationReq",chatData)
end