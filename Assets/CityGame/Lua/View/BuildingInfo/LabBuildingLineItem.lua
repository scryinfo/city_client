---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/28 16:55
---
LabBuildingLineItem = class('LabBuildingLineItem')
LabBuildingLineItem.static.TOTAL_H = 815  --整个Item的高度
LabBuildingLineItem.static.CONTENT_H = 740  --显示内容的高度
LabBuildingLineItem.static.TOP_H = 100  --top条的高度

LabBuildingLineItem.static.LabBuildingInventionItemPath = "Items/LaboratoryItems/LabBuildingInventionItem"  --发明
LabBuildingLineItem.static.LabBuildingResearchItemPath = "Items/LaboratoryItems/LabBuildingResearchItem"  --研究

function LabBuildingLineItem:initialize(data, viewRect, mainPanelLuaBehaviour, toggleData)
    self.viewRect = viewRect
    self.mainPanelLuaBehaviour = mainPanelLuaBehaviour
    self.data = data
    self.toggleData = toggleData  --位于toggle的第几个，左边还是右边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform")  --内容Rect
    self.loopScroll = self.viewRect.transform:Find("contentRoot/scroll"):GetComponent("ActiveLoopScrollRect")  --滑动复用组件
    self.openStateTran = self.viewRect.transform:Find("topRoot/open")
    self.openBtn = self.viewRect.transform:Find("topRoot/open/openBtn"):GetComponent("Button")
    self.doSthImg = self.viewRect.transform:Find("topRoot/open/openBtn/doSthImg")
    self.otherOpenImg = self.viewRect.transform:Find("topRoot/open/openBtn/otherOpenImg")

    --滑动复用部分
    self.itemSource = UnityEngine.UI.LoopScrollDataSource.New()  --研究
    self.itemSource.mProvideData = LabBuildingLineItem.static.provideData
    self.itemSource.mClearData = LabBuildingLineItem.static.clearData

    --Event.AddListener("c_onReceiveHouseRentChange", self.updateInfo, self)

    self:_initData()
end
--初始化数据
function LabBuildingLineItem:_initData()
    LabBuildingLineItem.static.items = {}
    if not self.line then
        self.line = {}
    else
        table.sort(self.line, function (m, n) return m.createTs > n.createTs end)
    end
    local prefabList = {}
    for i, dataItem in pairs(self.line) do
        if dataItem.type == 0 then
            prefabList[#prefabList + 1] = LabBuildingLineItem.static.LabBuildingResearchItemPath
        elseif dataItem.type == 1 then
            prefabList[#prefabList + 1] = LabBuildingLineItem.static.LabBuildingInventionItemPath
        end
    end
    LabBuildingLineItem.static.lineInfoData = self.line
    self.loopScroll:ActiveDiffItemLoop(self.itemSource, prefabList)  --滑动部分

    if self.data.isOther then
        self.doSthImg.localScale = Vector3.zero
        self.otherOpenImg.localScale = Vector3.one
    else
        self.doSthImg.localScale = Vector3.one
        self.otherOpenImg.localScale = Vector3.zero
    end
    self.mainPanelLuaBehaviour:AddClick(self.openBtn.gameObject, function()
        ct.OpenCtrl("LabScientificLineCtrl", self.data)  --按照时间排好的顺序表
    end, self)

end

---静态方法
LabBuildingLineItem.static.provideData = function(transform, idx)
    idx = idx + 1
    local data = LabBuildingLineItem.static.lineInfoData[idx]
    if data.type == 0 then
        LabBuildingLineItem.static.items[#LabBuildingLineItem.static.items + 1] = LabBuildingResearchItem:new(LabBuildingLineItem.static.lineInfoData[idx], transform)
    elseif data.type == 1 then
        LabBuildingLineItem.static.items[#LabBuildingLineItem.static.items + 1] = LabBuildingInventionItem:new(LabBuildingLineItem.static.lineInfoData[idx], transform)
    end
end
LabBuildingLineItem.static.researchClearData = function(transform)
end
---

--获取是第几个点击了
function LabBuildingLineItem:getToggleIndex()
    return self.toggleData.index
end

--打开
function LabBuildingLineItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, LabBuildingLineItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    return Vector2.New(targetMovePos.x, targetMovePos.y - LabBuildingLineItem.static.TOTAL_H)
end

--关闭
function LabBuildingLineItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, 0), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    return Vector2.New(targetMovePos.x, targetMovePos.y - LabBuildingLineItem.static.TOP_H)
end

--刷新数据
function LabBuildingLineItem:updateInfo(data)
    if self.data.buildingId ~= data.id then
        return
    end

end

function LabBuildingLineItem:destory()
    destroy(self.viewRect.gameObject)
end