---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/1/16 17:47
---UIBubbleManager

UIBubbleManager= {}
local this = UIBubbleManager
local pbl = pbl

UIBubbleManager.GroundAucSoonObjPath = "View/Items/BuildingBubbleItems/UIBubbleGroundAucSoonItem"  --即将拍卖
UIBubbleManager.GroundAucNowObjPath = "View/Items/BuildingBubbleItems/UIBubbleGroundAucNowItem"  --正在拍卖
UIBubbleManager.BubbleParentObjPath = "View/Items/BuildingBubbleItems/UIBubblePanel"  --父物体
UIBubbleManager.SellRentObjPath = "View/Items/BuildingBubbleItems/UIBubbleTransAndBuildingItem"  --土地交易气泡
UIBubbleManager.GroundAucObjPath = "View/Items/BuildingBubbleItems/UIBubbleGroundAucItem"  --拍卖气泡

--构建函数--
function UIBubbleManager.New()
    return this
end

function UIBubbleManager.Awake()
    this:OnCreate()
    this._preLoadGroundAucObj()
    this.startFlowCam = false
end

--启动事件--
function UIBubbleManager.OnCreate()
    --网络回调注册
    this._addListener()
end

function UIBubbleManager._preLoadGroundAucObj()
    local prefab = UnityEngine.Resources.Load(UIBubbleManager.BubbleParentObjPath)
    this.BubbleParent = UnityEngine.GameObject.Instantiate(prefab)
end

function UIBubbleManager._addListener()
    Event.AddListener("c_HideGroundBubble", this._hideAllItems, self)
    Event.AddListener("c_ShowGroundBubble", this._showAllItems, self)
end
function UIBubbleManager._removeListener()
    Event.RemoveListener("c_HideGroundBubble", this._hideAllItems, self)
    Event.RemoveListener("c_ShowGroundBubble", this._showAllItems, self)
end

--气泡类型
UIBubbleType =
{
    GroundAuc = 1,
    GroundTrans = 2,
    BuildingSelf = 3,
}

function UIBubbleManager._cameraLateUpdate()
    if this.startFlowCam == nil or this.startFlowCam == false then
        return
    end
    --Event.Brocast("c_RefreshLateUpdate")
end

--设置打开气泡模式
function UIBubbleManager.startBubble()
    if this.startFlowCam == false then
        this.startFlowCam = true
        this.BubbleParent.transform:SetParent(UIRoot.getBubbleRoot().transform)
        this.BubbleParent.transform.localScale = Vector3.one
        this.BubbleParent.transform:GetComponent("RectTransform").anchoredPosition = Vector2.zero
    end
end

--生成拍卖气泡
--function UIBubbleManager.createAucBubble(aucData)
--    if this.startFlowCam == false then
--        ct.log("", "尚未打开气泡模式")
--        return
--    end
--    if aucData == nil then
--        return
--    end
--    this._creatGroundAucBubbleItem(aucData)
--end

--拍卖刷新信息
function UIBubbleManager.updateAucData(data)
    if this.nowItem == nil then
        return
    end
    this.nowItem:_bidInfoUpdate(data)
end

--创建一个拍卖item
function UIBubbleManager._creatGroundAucBubbleItem(bubbleData)
    if this.aucItemsTable == nil then
        this.aucItemsTable = {}
    end
    if this.groundAucNowObj == nil then
        this.groundAucNowObj = UnityEngine.Resources.Load(this.GroundAucObjPath)
    end

    local go = UnityEngine.GameObject.Instantiate(this.groundAucNowObj)
    go.transform:SetParent(this.BubbleParent.transform)
    if this.hide then
        go.transform.localScale = Vector3.zero
    else
        go.transform.localScale = Vector3.one
    end
    local data = bubbleData
    data.bubbleObj = go  --将obj引用到lua中
    local groundAucNowItem = UIBubbleGroundAucItem:new(data)
    this.aucItemsTable[bubbleData.aucInfo.id] = groundAucNowItem
end

--判断是否点击到拍卖的地块
function UIBubbleManager.getIsClickAucGround(blockId)
    if this.aucItemsTable == nil then
        return false
    end
    for i, item in pairs(this.aucItemsTable) do
        if item ~= nil then
            local tempBool = item:_checkIsClickGround(blockId)
            if tempBool == true then
                return true
            end
        end
    end
    return false
end

--隐藏所有气泡
function UIBubbleManager._hideAllItems()
    UIBubbleManager.hide = true
    Event.Brocast("c_BubbleAllHide")
end
--显示所有气泡
function UIBubbleManager._showAllItems()
    UIBubbleManager.hide = false
    Event.Brocast("c_BubbleAllShow")
end

--点了主页的按钮
function UIBubbleManager._getNowAndSoonState()
    if this.aucItemsTable == nil then
        return nil
    end
    local soonData = {}
    for i, item in pairs(this.aucItemsTable) do
        if item ~= nil then
            if item:_getAucState() == true then
                local beginTime, durationSec = item:_getTimeDownInfo()
                local data = {groundState = 1, beginTime = beginTime, durationSec = durationSec}
                return data
            else
                local beginTime, durationSec = item:_getTimeDownInfo()
                soonData = {groundState = 0, beginTime = beginTime, durationSec = durationSec}
            end
        end
    end
    return soonData
end

----
--打开拍卖界面
function UIBubbleManager._openGroundAucCtrl(index)
    if index == 1 then
        if UIBubbleManager.nowItem ~= nil then
            UIBubbleManager.nowItem:_openGroundAucFunc()
        end
        return
    end
    if index == 0 then
        if UIBubbleManager.soonItem ~= nil then
            UIBubbleManager.soonItem:_openGroundAucFunc()
        end
        return
    end
end
--通过类型获取一个气泡
function UIBubbleManager.getBubbleByType(bubbleType, groundState, serverPos, uiCenterPos)
    if bubbleType == UIBubbleType.GroundTrans or bubbleType == UIBubbleType.BuildingSelf then
        local data = {bubbleType = bubbleType, groundState = groundState, uiCenterPos = uiCenterPos}
        local obj = UIBubbleManager.getBubbleObj(bubbleType)
        if serverPos ~= nil then
            data.blockId = TerrainManager.GridIndexTurnBlockID(serverPos)
            obj.name = "bubble "..serverPos.x..serverPos.y
        end
        local bubbleItem = UIBubbleTransAndBuildingItem:new(data, obj)
        return bubbleItem
    end
end
function UIBubbleManager.getBubbleObj(type)
    local go
    if type == UIBubbleType.GroundTrans or type == UIBubbleType.BuildingSelf then
        if UIBubbleManager.sellRentPrefab == nil then
            UIBubbleManager.sellRentPrefab = UnityEngine.Resources.Load(UIBubbleManager.SellRentObjPath)
        end
        go = UnityEngine.GameObject.Instantiate(UIBubbleManager.sellRentPrefab)
        go.transform:SetParent(this.BubbleParent.transform)
        go.transform.localScale = Vector3.one
        return go
    else
        --拍卖类型的预制
    end
end

--回收item
function UIBubbleManager.closeItem(item, id)
    item:Close()
    if id ~= nil then
        if this.aucItemsTable[id] ~= nil then
            this.aucItemsTable[id] = nil
        end
    end
end