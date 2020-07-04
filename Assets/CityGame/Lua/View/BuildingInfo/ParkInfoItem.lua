---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/25/025 9:58
---

local class=require'Framework/class'

ParkInfoItem=class('ParkInfoItem')
ParkInfoItem.static.TOTAL_H =561  --The height of the entire Item
ParkInfoItem.static.CONTENT_H = 380 --Display height
ParkInfoItem.static.TOP_H = 100  --the height of the top bar

function ParkInfoItem:initialize(itemData, clickOpenFunc, itemRect, LuaBehaviour, toggleData, mgrTable)
    self.itemData=itemData
    self.itemRect=itemRect
    self.toggleData=toggleData
    self.mgrTable=mgrTable
    self.contentRoot = self.itemRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --Content Rect
    self.openStateTran = self.itemRect.transform:Find("topRoot/open");  --Open state
    self.toDoBtn = self.itemRect.transform:Find("topRoot/open/doSthBtn");  --Execute button after opening

    self.brandText=itemRect:Find("topRoot/iconImg/numText"):GetComponent("Text");
    self.qtyText=itemRect:Find("topRoot/iconImg1/numText"):GetComponent("Text");


    LuaBehaviour:AddClick(self.toDoBtn.gameObject,function()
        itemData.func(mgrTable,toggleData)
    end)

    Event.AddListener("c_onParkInfoValueChange", self.updateBrandQty, self);


end

function ParkInfoItem:getToggleIndex()
    return self.toggleData.index
end


---turn on
function ParkInfoItem:openToggleItem()
    self.buildingInfoToggleState = BuildingInfoToggleState.Open


    --self.itemRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, ParkInfoItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    --return Vector2.New(targetMovePos.x, targetMovePos.y - ParkInfoItem.static.TOTAL_H)
end

---shut down
function ParkInfoItem:closeToggleItem()
    self.buildingInfoToggleState = BuildingInfoToggleState.Close

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, 0), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    --self.itemRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    --return Vector2.New(targetMovePos.x, targetMovePos.y - ParkInfoItem.static.TOP_H)
end

---
function ParkInfoItem:OntoDOBtn()



end


---Refresh the number of brands and score
function ParkInfoItem:updateBrandQty( Brand,qty )

    self.brandText.text=Brand
    self.qtyText.text=qty

end





















