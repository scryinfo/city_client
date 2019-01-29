MyGround = {}

local myGroundObj
local usedGroundObj
local MyGroundsTrans
local myGroundPrefab

function MyGround.Init()
    MyGroundsTrans = find("MyGrounds")
    if MyGroundsTrans  == nil then
        ct.log("system","没有找到我的地块集合父物体")
        return
    else
        MyGroundsTrans = MyGroundsTrans.transform
    end
    myGroundPrefab = MyGroundsTrans:Find("my_Ground").gameObject
    if myGroundPrefab  == nil then
        ct.log("system","没有找到我的地块预制")
        return
    end
    myGroundObj = {}
    usedGroundObj = {}
end

--创建我的地块
function MyGround.CreateMyGrounds()
    local myPersonData = DataManager.GetMyPersonData()
    if myPersonData.m_groundInfos then
        for key, value in pairs(myPersonData.m_groundInfos) do
            if  DataManager.IsOwnerGround({x = value.x, z = value.y}) then
                MyGround.AddMyGround(Vector3.New(value.x,0,value.y))
            end
        end
    else
        myPersonData.m_groundInfos = {}
    end
    if  myPersonData.m_rentGroundInfos then
        for key, value in pairs(myPersonData.m_rentGroundInfos) do
            if  DataManager.IsOwnerGround({x = value.x, z = value.y}) then
                MyGround.AddMyGround(Vector3.New(value.x,0,value.y))
            end
        end
    else
        myPersonData.m_rentGroundInfos = {}
    end
end


function MyGround.AddMyGround(tempPos)
    local tempBlockID = TerrainManager.PositionTurnBlockID(tempPos)
    --判断是否有了这个Obj了
    if myGroundObj ~= nil and myGroundObj[tempBlockID] ~= nil then
        return
    end
    local tempObj = nil
    if usedGroundObj ~= nil and #usedGroundObj > 0 then
        tempObj = usedGroundObj[#usedGroundObj]
        table.remove(usedGroundObj,#usedGroundObj)
    else
        tempObj = UnityEngine.GameObject.Instantiate(myGroundPrefab,MyGroundsTrans)
    end
    tempObj.transform.position = tempPos
    tempObj.transform.localScale = Vector3.one
    tempObj.name = "My_OwnGround"
    myGroundObj[tempBlockID] = tempObj
end

--移除我的地块
function MyGround.RemoveMyGround(tempPos)
    local tempBlockID = TerrainManager.PositionTurnBlockID(tempPos)
    if myGroundObj[tempBlockID] ~= nil then
        myGroundObj[tempBlockID].transform.localScale = Vector3.zero
        table.insert(usedGroundObj,myGroundObj[tempBlockID])
    end
    myGroundObj[tempBlockID] = nil
end

--删除我的地块
function MyGround.ClearMyGrounds()
    if myGroundObj ~= nil then
        for key, value in pairs(myGroundObj) do
            destroy(value)
        end
    end
    if usedGroundObj ~= nil then
        for key, value in pairs(usedGroundObj) do
            destroy(value)
        end
    end
    myGroundObj = {}
    usedGroundObj = {}
end