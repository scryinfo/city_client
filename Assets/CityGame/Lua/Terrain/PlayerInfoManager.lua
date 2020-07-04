PlayerInfoManager={}
--parameter
local PlayerInfoDatas                       --local playerinfo data
local PlayerInfoWriteDatas                  --Apply playerinfo to the server for the data form

-------------------------------------------------external Unable to call information----------------------------------------------
-- Query friend information from the server
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

--Get some PlayerInfo data
function PlayerInfoManager.GetPalayerInfo(playerId,func,class)
    if playerId ~= nil or  PlayerInfoWriteDatas == {} then
        return
    end
    if PlayerInfoDatas[playerId] ~= nil then    --Check whether localPlayerInfo data is cached
        --Return data directly
        class.func(class,PlayerInfoDatas[playerId])
    else
        local tempTabel ={}
        tempTabel.id = playerId
        tempTabel.func = func
        tempTabel.class = class

        local isFirst = false
        if PlayerInfoWriteDatas[playerId] == nil then
            --Register for an application
            PlayerInfoWriteDatas[playerId] = {}
            isFirst = true
        end

        --Join callback method group
        table.insert(PlayerInfoWriteDatas[playerId],tempTabel)

        ----Determine whether the instance class has requested the same data--TODO：//Consider whether to delete the judgment
        --for i, item in ipairs(PlayerInfoWriteDatas[playerId]) do
        --    if  item.id == playerId then
        --        return
        --    end
        --end

        --Only request the server for the first time
        if isFirst == true then
            m_QueryPlayerInfoMessage(playerId)
        end
    end
end