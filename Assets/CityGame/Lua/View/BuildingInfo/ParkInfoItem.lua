---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/25/025 9:58
---

local class=require'Framework/class'

ParkInfoItem=class('ParkInfoItem')
ParkInfoItem.static.TOTAL_H =561  --整个Item的高度
ParkInfoItem.static.CONTENT_H = 380 --显示内容的高度
ParkInfoItem.static.TOP_H = 100  --top条的高度

function ParkInfoItem:initialize(itemData, clickOpenFunc, itemRect, LuaBehaviour, toggleData, mgrTable)
    self.itemData=itemData
    self.itemRect=itemRect
    self.toggleData=toggleData
    self.mgrTable=mgrTable
    self.contentRoot = self.itemRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.openStateTran = self.itemRect.transform:Find("topRoot/open");  --打开状态
    self.toDoBtn = self.itemRect.transform:Find("topRoot/open/doSthBtn");  --打开之后的执行按钮

    LuaBehaviour:AddClick(self.toDoBtn.gameObject,function()
        itemData.func(mgrTable,toggleData)
    end)

    Event.AddListener("c_onParkInfoValueChange", self.updateInfo, self);

end

function ParkInfoItem:getToggleIndex()
    return self.toggleData.index
end


---打开
function ParkInfoItem:openToggleItem()
    self.buildingInfoToggleState = BuildingInfoToggleState.Open


    --self.itemRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, ParkInfoItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    --return Vector2.New(targetMovePos.x, targetMovePos.y - ParkInfoItem.static.TOTAL_H)
end

---关闭
function ParkInfoItem:closeToggleItem()
    self.buildingInfoToggleState = BuildingInfoToggleState.Close

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, 0), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    --self.itemRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    --return Vector2.New(targetMovePos.x, targetMovePos.y - ParkInfoItem.static.TOP_H)
end

---
function ParkInfoItem:OntoDOBtn()



end
---刷新数据
function ParkInfoItem:updateInfo()



end





















