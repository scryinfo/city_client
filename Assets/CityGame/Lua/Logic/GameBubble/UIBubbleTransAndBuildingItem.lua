---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/1/16 10:03
---
UIBubbleTransAndBuildingItem = class('UIBubbleTransAndBuildingItem')
function UIBubbleTransAndBuildingItem:initialize(data, obj)
    self.data = data
    self.gameObject = obj
    self.rect = obj.transform:GetComponent("RectTransform")

    self.groundSell = obj.transform:Find("groundSell")
    self.groundRent = obj.transform:Find("groundRent")
    self.selfBuilding = obj.transform:Find("selfBuilding")

    self.sellBtn = obj.transform:Find("groundSell/sellBtn"):GetComponent("Button")
    self.rentBtn = obj.transform:Find("groundRent/rentBtn"):GetComponent("Button")

    self.sellBtn.onClick:RemoveAllListeners()
    self.rentBtn.onClick:RemoveAllListeners()
    self.sellBtn.onClick:AddListener(function ()
        self:_openBubbleFunc()
    end)
    self.rentBtn.onClick:AddListener(function ()
        self:_openBubbleFunc()
    end)

    self:_initFunc(data)
    Event.AddListener("c_RefreshLateUpdate", self.LateUpdate, self)
end

function UIBubbleTransAndBuildingItem:_initFunc(data)
    --如果是交易气泡
    if data.bubbleType == UIBubbleType.GroundTrans then
        self:_setBubbleState(data.groundState)
    elseif data.bubbleType == UIBubbleType.BuildingSelf then
        self:_setBubbleState(data.bubbleType)
    end
    self.pos = TerrainManager.BlockIDTurnPosition(data.blockId)
end

function UIBubbleTransAndBuildingItem:_setBubbleState(state)
    if state == GroundTransState.Sell then
        self.groundSell.localScale = Vector3.one
        self.groundRent.localScale = Vector3.zero
        self.selfBuilding.localScale = Vector3.zero
    elseif state == GroundTransState.Rent then
        self.groundRent.localScale = Vector3.one
        self.groundSell.localScale = Vector3.zero
        self.selfBuilding.localScale = Vector3.zero
    elseif state == UIBubbleType.BuildingSelf then
        self.selfBuilding.localScale = Vector3.one
        self.groundRent.localScale = Vector3.zero
        self.groundSell.localScale = Vector3.zero
    end
end

--点击气泡
function UIBubbleTransAndBuildingItem:_openBubbleFunc()
    ct.OpenCtrl("GroundTransDetailCtrl", self.data.blockId)
end

function UIBubbleTransAndBuildingItem:Close()
    Event.RemoveListener("c_RefreshLateUpdate", self.LateUpdate, self)
    --将obj放入对象池
    if self.gameObject ~= nil then
        destroyImmediate(self.gameObject)
    end
end

function UIBubbleTransAndBuildingItem:LateUpdate()
    if self.pos ~= nil then
        self.rect.anchoredPosition = UnityEngine.Camera.main:WorldToScreenPoint(self.pos + Vector3.New(0.5, 0.5, 0.05))
    end
end