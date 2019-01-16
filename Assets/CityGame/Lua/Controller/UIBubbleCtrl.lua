---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/21 16:11
---
UIBubbleCtrl = class('UIBubbleCtrl',UIPage)
UIPage:ResgisterOpen(UIBubbleCtrl)

UIBubbleCtrl.static.SellRentObjPath = "View/Items/BuildingBubbleItems/UIBubbleTransAndBuildingItem"  --土地交易气泡

function UIBubbleCtrl:initialize()
    UIPage.initialize(self, UIType.Fixed, UIMode.HideOther, UICollider.None)
end

function UIBubbleCtrl:bundleName()
    return "Assets/CityGame/Resources/View/UIBubblePanel.prefab"
end

function UIBubbleCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function UIBubbleCtrl:Awake(go)
    self:_addListener()
end

function UIBubbleCtrl:Refresh()
    self:_initFunc()
end
function UIBubbleCtrl:_addListener()
    Event.AddListener("c_RefreshItems", self._refreshItems, self)
    Event.AddListener("c_HideGroundBubble", self._hideAllItems, self)
    Event.AddListener("c_ShowGroundBubble", self._showAllItems, self)
end
function UIBubbleCtrl:_removeListener()
    Event.RemoveListener("c_RefreshItems", self._refreshItems, self)
    Event.RemoveListener("c_HideGroundBubble", self._hideAllItems, self)
    Event.RemoveListener("c_ShowGroundBubble", self._showAllItems, self)
end

function UIBubbleCtrl._cameraLateUpdate()
    if UIBubbleMgr.startFlowCam == nil or UIBubbleMgr.startFlowCam == false then
        return
    end
    Event.Brocast("c_RefreshLateUpdate")
end

function UIBubbleCtrl:_initFunc()
    if self.m_data == nil then
        return
    end

    self:createGroundAucData(self.m_data)
end

function UIBubbleCtrl:createGroundAucData(data)
    if data == nil then
        return
    end
    if self.bubbleMgr == nil then
        self.bubbleMgr = UIBubbleMgr:new(UIBubblePanel.root.transform)
        UIBubbleCtrl.bubbleMgr = self.bubbleMgr
    end

    if data.bubbleType == UIBubbleType.GroundAuc then
        self.bubbleMgr:initGroundAucBubbles(data)
    end
end

--拍卖气泡
--function UIBubbleCtrl.createGroundAucData(data)
--    if data == nil then
--        return
--    end
--    if UIBubbleCtrl.bubbleMgr == nil then
--        UIBubbleCtrl.bubbleMgr = UIBubbleMgr:new(UIBubblePanel.root.transform)
--    end
--
--    if data.bubbleType == UIBubbleType.GroundAuc then
--        UIBubbleCtrl.bubbleMgr:initGroundAucBubbles(data)
--    end
--end

--更新数据
function UIBubbleCtrl:_refreshItems(datas)
    self.bubbleMgr:_refreshItems(datas)
end

--隐藏所有气泡
function UIBubbleCtrl:_hideAllItems()
    self.bubbleMgr:_hideAllItems()
end
--显示所有气泡
function UIBubbleCtrl:_showAllItems()
    self.bubbleMgr:_showAllItems()
end

----
--打开拍卖界面
function UIBubbleCtrl._openGroundAucCtrl(index)
    if index == 1 then
        if UIBubbleCtrl.bubbleMgr:getNowItem() ~= nil then
            UIBubbleCtrl.bubbleMgr:getNowItem():_openGroundAucFunc()
        end
        return
    end
    if index == 0 then
        if UIBubbleCtrl.bubbleMgr:getSoonItem() ~= nil then
            UIBubbleCtrl.bubbleMgr:getSoonItem():_openGroundAucFunc()
        end
        return
    end
end
--通过类型获取一个气泡
function UIBubbleCtrl.getBubbleByType(bubbleType, groundState, serverPos)
    if bubbleType == UIBubbleType.GroundTrans or bubbleType == UIBubbleType.BuildingSelf then
        local data = {bubbleType = bubbleType, groundState = groundState}
        local obj = UIBubbleCtrl.getBubbleObj(bubbleType)
        if serverPos ~= nil then
            data.blockId = TerrainManager.GridIndexTurnBlockID(serverPos)
            obj.name = "bubble "..serverPos.x..serverPos.y
        end
        local bubbleItem = UIBubbleTransAndBuildingItem:new(data, obj)
        return bubbleItem
    end
end
function UIBubbleCtrl.getBubbleObj(type)
    local go
    if type == UIBubbleType.GroundTrans or type == UIBubbleType.BuildingSelf then
        if UIBubbleCtrl.static.sellRentPrefab == nil then
            UIBubbleCtrl.static.sellRentPrefab = UnityEngine.Resources.Load(UIBubbleCtrl.static.SellRentObjPath)
        end
        go = UnityEngine.GameObject.Instantiate(UIBubbleCtrl.static.sellRentPrefab)
    else
        --拍卖类型的预制
    end
    go.transform:SetParent(UIBubblePanel.root.transform)
    go.transform.localScale = Vector3.one
    return go
end