---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/3/1/001 11:30
---

PlayerInfoManger={}

local  cache,playerIDs,num,temparrs
local count=1
function PlayerInfoManger.Awake()
    temparrs,  cache,playerIDs={},{},{}
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryPlayerInfo","gs.RoleInfos",PlayerInfoManger.n_OnReceivePlayerInfo)
end

local _func,_class


---==========================================================================================外部===================================================================================================

function PlayerInfoManger.GetInfoAndExcute(playerIds,func,class)
    num=1

    _func=func
    _class=class

    local tempIds=playerIds
    for i, ids in ipairs(tempIds) do
        local info=cache[tempIds[1]]

        if info then--又缓存
            func(class,info)
            table.remove(tempIds,1)
        else--无缓存
            for i, ids in ipairs(tempIds) do
                table.insert(playerIDs,ids)
            end
            Event.Brocast("m_QueryPlayerInfoChat",playerIDs)
            return
        end
    end


end

function PlayerInfoManger.GetInfos(playerIds,func,class)
    num=2

    _func=func
    _class=class

    local tempIds=playerIds
    for i, ids in ipairs(tempIds) do

        local info=cache[tempIds[i]]

        if info then--有缓存
            count=i
            table.insert(temparrs,info)

        else--无缓存
            for i = count, #tempIds do
                table.insert(playerIDs,tempIds[i])
            end
            Event.Brocast("m_QueryPlayerInfoChat",playerIDs)
            return

        end
    end

    _func(_class,temparrs)
    temparrs={}
end


function PlayerInfoManger.ClearCache()
    for id, info in pairs(cache) do
        id=nil
        info=nil
    end
    cache={}
end


---==========================================================================================回调===================================================================================================

--查询玩家信息返回
function DataManager.n_OnReceivePlayerInfo(stream)
    if not _class and not _func  and #playerIDs<=0  then    return   end

    if num==1 then---第一种

        for i, info in ipairs(stream.info) do
            --写入缓存
            cache[playerIDs[i]]=info
            --调用函数
            _func(_class,info)
        end

    else---第二种

        for i, info in ipairs(stream.info) do
            --写入缓存
            cache[playerIDs[i]]=info
            table.insert(temparrs,info)
        end

        _func(_class,temparrs)
    end
    _func=nil
    _class=nil
    temparrs={}
    playerIDs={}
end
