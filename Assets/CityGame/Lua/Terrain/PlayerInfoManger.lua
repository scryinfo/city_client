---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/3/1/001 11:30
---

PlayerInfoManger={}
local playerIDs
local _classes,_funcs

function PlayerInfoManger.Awake()
    _classes={}
    _funcs={}
    playerIDs={}
end

-- Query friend information from the server
function PlayerInfoManger.m_QueryPlayerInfoChat(friendsIds)
    DataManager.ModelSendNetMes("gscode.OpCode", "queryPlayerInfo","gs.Bytes",{ ids = friendsIds })
end

---==========================================================================================external===================================================================================================

local recardNums = 0
local curr = 0

function PlayerInfoManger.GetInfos(playerIds,func,class)
    --Record the callback of player information return
    recardNums = recardNums + 1
    playerIDs[recardNums] = playerIds
    _funcs[recardNums] = func
    _classes[recardNums] = class
    --Query the player's information from the server
    PlayerInfoManger.m_QueryPlayerInfoChat(playerIds)
    return
end

---==========================================================================================Callback===================================================================================================

--Query player information
function PlayerInfoManger.n_OnReceivePlayerInfo(stream)
    if #playerIDs <= 0 then
        return
    end
    curr = curr + 1
    _funcs[curr](_classes[curr],stream.info)
    --recardNums=recardNums-1
    if curr == recardNums then
        playerIDs={}
        _classes={}
        _funcs={}
        curr=0
        recardNums = 0
    end
end
