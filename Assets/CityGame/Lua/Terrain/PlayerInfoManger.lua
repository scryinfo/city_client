---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/3/1/001 11:30
---

PlayerInfoManger={}
local   methodNum
local  cache,playerIDs,tempInfos
local _classes,_funcs

function PlayerInfoManger.Awake()
    _classes={}    _funcs={}     tempInfos={}

    cache={}       playerIDs={}
    --DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryPlayerInfo","gs.RoleInfos",PlayerInfoManger.n_OnReceivePlayerInfo)
end



---==========================================================================================外部===================================================================================================

function PlayerInfoManger.ClearCache()
    for id, info in pairs(cache) do
        id=nil
        info=nil
    end
    cache={}
end


local recardNums=0
local curr=1

function PlayerInfoManger.GetInfosOneByOne(playerIds,func,class)
        methodNum=1

        local info=cache[playerIds[1]]

        if info then--有缓存
            func(class,info)
        else--无缓存
            recardNums=recardNums+1
            table.insert(_classes,class)
            table.insert(_funcs,func)
            table.insert(playerIDs,playerIds[1])
            Event.Brocast("m_QueryPlayerInfoChat",{playerIds[1]})
            prints("查询好友"..recardNums)
        end

end


function PlayerInfoManger.GetInfos(playerIds,func,class)
    methodNum=2


    for i, id in ipairs(playerIds) do

        local info=cache[id]

        if info then--有缓存
            table.insert(tempInfos,info)
        else--无缓存
            recardNums=recardNums+1

            playerIDs[recardNums]=playerIds
            _funcs[recardNums]=func
            _classes[recardNums]=class
            Event.Brocast("m_QueryPlayerInfoChat",playerIds)
            prints("查询好友"..recardNums)
            tempInfos={}
            return
        end

    end

    --有缓存  直接调用
    func(class,tempInfos)
    tempInfos={}
end



---==========================================================================================回调===================================================================================================

--查询玩家信息返回
function PlayerInfoManger.n_OnReceivePlayerInfo(stream)
    prints("收到查询好友"..curr)

    if  #playerIDs<=0  then    return   end
    prints("收到查询好友"..curr.."进入")


    if methodNum==1 then---第一种

        for i, info in ipairs(stream.info) do
            --写入缓存
            cache[playerIDs[curr]]=info
            --调用函数
            _funcs[curr](_classes[curr],info)
        end
        curr=curr+1
        recardNums=recardNums-1

        if recardNums==0 then
            playerIDs={}
            _classes={}
            _funcs={}
            curr=1
        end

    else---第二种

        for i, info in ipairs(stream.info) do
            --写入缓存
            cache[playerIDs[curr][i]]=info
            table.insert(tempInfos,info)
        end

        _funcs[curr](_classes[curr],tempInfos)

        curr=curr+1
        recardNums=recardNums-1

        if recardNums == 0 then
            playerIDs={}
            _classes={}
            _funcs={}
            curr=1
        end
        tempInfos={}

    end

end
