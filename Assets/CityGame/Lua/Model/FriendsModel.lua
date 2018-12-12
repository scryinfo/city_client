---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/12/6 10:52
---

local pbl = pbl

FriendsModel = {}
local this = FriendsModel

function FriendsModel.New()
    return this
end

function FriendsModel.Awake()
    this:OnCreate()
end

function FriendsModel.OnCreate()
    -- 注册事件
    Event.AddListener("m_QueryPlayerInfo", this.m_QueryPlayerInfo)
    Event.AddListener("m_SearchPlayer", this.m_SearchPlayer)
    Event.AddListener("m_AddFriends", this.m_AddFriends)
    Event.AddListener("m_AddFriendsReq", this.m_AddFriendsReq)
    Event.AddListener("m_DeleteFriend", this.m_DeleteFriend)
    --Event.AddListener("m_QueryBlacklistPlayerInfo", this.m_QueryBlacklistPlayerInfo)
    Event.AddListener("m_DeleteBlacklist", this.m_DeleteBlacklist)

    -- 网络回调注册
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","addFriendSucess"),FriendsModel.n_OnReceiveAddFriendSucess)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","searchPlayer"),FriendsModel.n_OnReceiveSearchPlayerInfo)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","deleteFriend"),FriendsModel.n_OnReceiveDeleteFriend)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","deleteBlacklist"),FriendsModel.n_DeleteBlacklist)
end

function FriendsModel.Close()
    -- 清空事件
    Event.RemoveListener("m_QueryPlayerInfo", this.m_QueryPlayerInfo)
    Event.RemoveListener("m_SearchPlayer", this.m_SearchPlayer)
    Event.RemoveListener("m_AddFriends", this.m_AddFriends)
    Event.RemoveListener("m_AddFriendsReq", this.m_AddFriendsReq)
    Event.RemoveListener("m_DeleteFriend", this.m_DeleteFriend)
    Event.RemoveListener("m_DeleteBlacklist", this.m_DeleteBlacklist)
end

-- 向服务器查询好友信息
function FriendsModel.m_QueryPlayerInfo(friendsIds)
    local msgId = pbl.enum("gscode.OpCode","queryPlayerInfo")
    local lMsg = { ids = friendsIds }
    local  pMsg = assert(pbl.encode("gs.Bytes", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end

-- 接收好友申请
--function FriendsModel.n_OnReceiveAddFriendSucess(stream)
--    local friend = assert(pbl.decode("gs.ByteBool", stream), "DataManager.n_OnReceiveAddFriendReq: stream == nil")
--    if not friend or not friend.id then
--        return
--    end
--    Event.Brocast("c_OnReceiveAddFriendSucess", friend)
--end


-- 搜索用户（用户名）e
function FriendsModel.m_SearchPlayer(nameStr)
    local msgId = pbl.enum("gscode.OpCode","searchPlayer")
    local lMsg = { str = nameStr }
    local  pMsg = assert(pbl.encode("gs.Str", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end

-- 收到好友信息
function FriendsModel.n_OnReceiveSearchPlayerInfo(stream)
    local friendsData = assert(pbl.decode("gs.RoleInfos", stream), "FriendsModel.n_OnReceiveSearchPlayerInfo: stream == nil")
    Event.Brocast("c_OnReceiveSearchPlayerInfo", friendsData)
end

-- 加好友（玩家Id）
function FriendsModel.m_AddFriends(friendId, descStr)
    local msgId = pbl.enum("gscode.OpCode","addFriend")
    local lMsg = { id = friendId, desc = descStr }
    local  pMsg = assert(pbl.encode("gs.ByteStr", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end

-- 处理好友申请
function FriendsModel.m_AddFriendsReq(friendId, b)
    local msgId = pbl.enum("gscode.OpCode","addFriendReq")
    local lMsg = { id = friendId, b = b }
    local  pMsg = assert(pbl.encode("gs.ByteBool", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end

-- 删除好友申请
function FriendsModel.m_DeleteFriend(friendId)
    local msgId = pbl.enum("gscode.OpCode","deleteFriend")
    local lMsg = { id = friendId }
    local  pMsg = assert(pbl.encode("gs.Id", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end

-- 收到删除好友信息
function FriendsModel.n_OnReceiveDeleteFriend(stream)
    local friendsId = assert(pbl.decode("gs.Id", stream), "FriendsModel.n_OnReceiveDeleteFriend: stream == nil")
    Event.Brocast("c_OnReceiveDeleteFriend", friendsId)
end

-- 向服务器查询黑名单玩家信息
--function FriendsModel.m_QueryBlacklistPlayerInfo(friendsIds)
--    local msgId = pbl.enum("gscode.OpCode","queryPlayerInfo")
--    local lMsg = { ids = friendsIds }
--    local  pMsg = assert(pbl.encode("gs.Bytes", lMsg))
--    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
--end

-- 解除屏蔽
function FriendsModel.m_DeleteBlacklist(friendsId)
    local msgId = pbl.enum("gscode.OpCode","deleteBlacklist")
    local lMsg = { id = friendsId }
    local  pMsg = assert(pbl.encode("gs.Id", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end

-- 解除屏蔽返回
function FriendsModel.n_DeleteBlacklist(stream)
    local friendsId = assert(pbl.decode("gs.Id", stream), "FriendsModel.n_DeleteBlacklist: stream == nil")
    Event.Brocast("c_DeleteBlacklist", friendsId)
end