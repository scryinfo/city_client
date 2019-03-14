---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/3/1/001 11:30
---

PlayerInfoMangerEx={}

local  cache,playerIDs,num,tempInfos
local count,curr=1,1
local recardNums=0
local _func,_class,_classes

function PlayerInfoMangerEx.Awake()
    _classes={}
    tempInfos,  cache,playerIDs={},{},{}
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryPlayerInfo","gs.RoleInfos",PlayerInfoMangerEx.n_OnReceivePlayerInfo)
end



---==========================================================================================外部===================================================================================================

function PlayerInfoMangerEx.GetInfosOneByOne(playerIds,func,class)
    num=1
    recardNums=recardNums+1
    _func=func

    local tempIds=playerIds

    local info=cache[tempIds[1]]

    if info then--有缓存
        func(class,info)
        recardNums=recardNums-1
    else--无缓存
        table.insert(_classes,class)

        table.insert(playerIDs,tempIds[1])
        Event.Brocast("m_QueryPlayerInfoChat",{tempIds[1]})

    end


end

function PlayerInfoMangerEx.GetInfos(playerIds,func,class)
    num=2

    _func=func
    _class=class

    local tempIds=playerIds
    for i, ids in ipairs(tempIds) do

        local info=cache[tempIds[i]]

        if info then--有缓存
            count=i
            table.insert(tempInfos,info)

        else--无缓存

            for i, v in ipairs(playerIds) do
                table.insert(playerIDs,v)
            end
            Event.Brocast("m_QueryPlayerInfoChat",playerIds)

            count=1
            tempInfos={}
            return
        end
    end
    if #tempInfos>0 then
        _func(_class,tempInfos)
    end
    count=1
    tempInfos={}
end


function PlayerInfoMangerEx.ClearCache()
    for id, info in pairs(cache) do
        id=nil
        info=nil
    end
    cache={}
end


---==========================================================================================回调===================================================================================================

--查询玩家信息返回
function PlayerInfoMangerEx.n_OnReceivePlayerInfo(stream)
    if not _func and  #playerIDs<=0  then    return   end

    if num==1 then---第一种

        for i, info in ipairs(stream.info) do
            --写入缓存
            cache[playerIDs[curr]]=info
            --调用函数
            _func(_classes[curr],info)
        end
        curr=curr+1
        recardNums=recardNums-1
        if recardNums==0 then
            _func=nil
            _class=nil
            tempInfos={}
            playerIDs={}
            curr=1
            _classes={}
        end

    else---第二种

        for i, info in ipairs(stream.info) do
            --写入缓存
            cache[playerIDs[i]]=info
            table.insert(tempInfos,info)
        end

        _func(_class,tempInfos)

        _func=nil
        _class=nil
        tempInfos={}
        playerIDs={}

    end

end