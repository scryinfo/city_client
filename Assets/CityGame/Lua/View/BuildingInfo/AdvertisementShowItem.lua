---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/20 11:00
---
local class = require 'Framework/class'

AdvertisementShowItem = class('AdvertisementShowItem')
AdvertisementShowItem.static.TOTAL_H = 781 --整个Item的高度
AdvertisementShowItem.static.CONTENT_H = 700  --显示内容的高度
AdvertisementShowItem.static.TOP_H = 100  --top条的高度


function AdvertisementShowItem:initialize(itemlData, clickOpenFunc, itemRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = itemRect
    self.rentalData = itemlData
    self.toggleData = toggleData  --位于toggle的第几个，左边还是右边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --打开状态
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");  --关闭状态
    self.openBtns = self.viewRect.transform:Find("topRoot/close/openBtns");  --打开按钮
    self.toDoBtn = self.viewRect.transform:Find("topRoot/open/doSthBtn");  --打开之后的执行按钮

    mainPanelLuaBehaviour:AddClick(self.openBtns.gameObject, function()
        clickOpenFunc(mgrTable, self.toggleData)
    end);
    mainPanelLuaBehaviour:AddClick(self.toDoBtn.gameObject,self.OntodoBtn)

    Event.AddListener("c_AdvertisementShowValueChange", self.updateInfo, self);
end

--获取是第几个点击了
function AdvertisementShowItem:getToggleIndex()
    return self.toggleData.index
end

--打开
function AdvertisementShowItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open;

    self.openStateTran.localScale = Vector3.one;
    self.closeStateTran.localScale = Vector3.zero;

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, AdvertisementShowItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - AdvertisementShowItem.static.TOTAL_H);
end

--关闭
function AdvertisementShowItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close;

    self.openStateTran.localScale = Vector3.zero;
    self.closeStateTran.localScale = Vector3.one;

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - AdvertisementShowItem.static.TOP_H);
end

--刷新数据
function AdvertisementShowItem:updateInfo(data)

end

function AdvertisementShowItem:OntodoBtn(ins)
   ---测试
    local data={}
    data.Buildingowner=Buildingowner.other
    ct.OpenCtrl('AdvertisementPosCtrl',Buildingowner.other)
end
