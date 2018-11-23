---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/21 16:11
---
UIBubbleCtrl = class('UIBubbleCtrl',UIPage)
UIPage:ResgisterOpen(UIBubbleCtrl)

UIBubbleCtrl.static.GroundAucSoonObjPath = "View/Items/BuildingBubbleItems/UIBubbleGroundAucSoonItem"  --即将拍卖
UIBubbleCtrl.static.GroundAucNowObjPath = "View/Items/BuildingBubbleItems/UIBubbleGroundAucNowItem"  --正在拍卖
UIBubbleCtrl.static.NpcFlowObjPath = "View/Items/BuildingBubbleItems/UIBubbleNpcFlowItem"  --人流量

function UIBubbleCtrl:initialize()
    UIPage.initialize(self, UIType.Fixed, UIMode.HideOther, UICollider.None)
end

function UIBubbleCtrl:bundleName()
    return "UIBubblePanel"
end

function UIBubbleCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function UIBubbleCtrl:Awake(go)
    self.gameObject = go
    self:_addListener()
end

function UIBubbleCtrl:Refresh()
    self:_initGroundAucBubbles()  --temp
end
function UIBubbleCtrl:_addListener()
    Event.AddListener("c_RefreshItems", self._refreshItems, self)
end
function UIBubbleCtrl:_removeListener()
    Event.RemoveListener("c_RefreshItems", self._refreshItems, self)
end

function UIBubbleCtrl.static.RefreshLateUpdate()
    Event.Brocast("c_RefreshLateUpdate")
end

--生成拍卖气泡
function UIBubbleCtrl:_initGroundAucBubbles()
    if not self.m_data then
        return
    end

    if not self.groundAucLuaItems then
        self.groundAucLuaItems = {}
    end
    local auction = self.m_data
    for i, data in pairs(auction) do
        if data then
            self:_creatGroundAucBubbleItem(data)
        else
            ct.log("cycle_w6_GroundAuc", "-----------")
        end
    end
end

function UIBubbleCtrl:_creatGroundAucBubbleItem(bubbleData)
    if bubbleData.isStartAuc then
        --已经开始拍卖
        if not self.groundAucNowObj then
            self.groundAucNowObj = UnityEngine.Resources.Load(UIBubbleCtrl.static.GroundAucNowObjPath)
        end
        local go = UnityEngine.GameObject.Instantiate(self.groundAucNowObj)
        go.transform:SetParent(self.gameObject.transform)
        go.transform.localScale = Vector3.one
        local data = bubbleData
        data.bubbleRect = go:GetComponent("RectTransform")  --将obj引用到lua中
        local groundAucNowItem = UIBubbleGroundAucNowItem:new(data)
        self.groundAucLuaItems[bubbleData.id] = groundAucNowItem
    else
        --即将拍卖
        if not self.groundAucSoonObj then
            self.groundAucSoonObj = UnityEngine.Resources.Load(UIBubbleCtrl.static.GroundAucSoonObjPath)
        end
        local go = UnityEngine.GameObject.Instantiate(self.groundAucSoonObj)
        go.transform:SetParent(self.gameObject.transform)
        go.transform.localScale = Vector3.one
        local data = bubbleData
        data.bubbleRect = go:GetComponent("RectTransform")
        local groundAucSoonItem = UIBubbleGroundAucSoonItem:new(data)
        self.groundAucLuaItems[bubbleData.id] = groundAucSoonItem
    end
end

--更新数据
function UIBubbleCtrl:_refreshItems(datas)
    for key, item in pairs(self.groundAucLuaItems) do
        item:Close()
        --destroy(item.groundObj.gameObject)  --删除场景中的预制
        destroy(item.bubbleRect.gameObject)  --删除之前的item
        self.groundAucLuaItems[key] = nil
    end

    self.groundAucLuaItems = {}
    local auction = datas
    for i, data in ipairs(auction) do
        if data then
            self:_creatGroundAucBubbleItem(data)
        else
            ct.log("cycle_w6_GroundAuc", "-----------")
        end
    end
end