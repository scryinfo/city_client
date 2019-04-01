PlayerInfoManager={}
--参数
local PlayerInfoDatas                       --本地PlayerInfo数据
local PlayerInfoWriteDatas                  --向服务器申请PlayerInfo数据表

-------------------------------------------------外部无法调用信息----------------------------------------------
-- 向服务器查询好友信息
local function m_QueryPlayerInfoMessage(friendsIds)
    DataManager.ModelSendNetMes("gscode.OpCode", "queryPlayerInfo","gs.Bytes",{ ids = friendsIds })
end


local  function n_OnReceivePlayerInfo(stream)
    local id
    for i, data in ipairs(stream.info) do
        id=data.id
        local tempTabels = PlayerInfoWriteDatas[id]
        if tempTabels ~= nil then
            for i, tempTabel in ipairs(tempTabels) do
                tempTabel.func(tempTabel.class,data)
                PlayerInfoDatas[id]=data
            end
        end
    end
    PlayerInfoWriteDatas[id]=nil
end

-----------------------------------------------------------------------------------------------------------


function PlayerInfoManager.Init()
    PlayerInfoDatas = {}
    PlayerInfoWriteDatas = {}
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryPlayerInfo","gs.RoleInfos",n_OnReceivePlayerInfo)
end



function PlayerInfoManager.GetPalayerInfos(playerIds,funcs,classes)
    for i, playerId in ipairs(playerIds) do
        PlayerInfoManager.GetPalayerInfo(playerIds,funcs,classes)
    end
end

--获取某个PlayInfo数据
function PlayerInfoManager.GetPalayerInfo(playerId,func,class)
    if playerId ~= nil or  PlayerInfoWriteDatas == {} then
        return
    end
    if PlayerInfoDatas[playerId] ~= nil then    --检测本地PlayerInfo数据是否缓存
        --直接返回数据
        class.func(class,PlayerInfoDatas[playerId])
    else
        local tempTabel ={}
        tempTabel.id = playerId
        tempTabel.func = func
        tempTabel.class = class

        local isFirst = false
        if PlayerInfoWriteDatas[playerId] == nil then
            --注册某个ID的申请
            PlayerInfoWriteDatas[playerId] = {}
            isFirst = true
        end

        --加入回调方法组
        table.insert(PlayerInfoWriteDatas[playerId],tempTabel)

        ----判断该实例类是否已请求过相同数据--TODO：//考虑是否删除判定
        --for i, item in ipairs(PlayerInfoWriteDatas[playerId]) do
        --    if  item.id == playerId then
        --        return
        --    end
        --end

        --只有第一次才向服务器请求
        if isFirst == true then
            m_QueryPlayerInfoMessage(playerId)
        end
    end
end