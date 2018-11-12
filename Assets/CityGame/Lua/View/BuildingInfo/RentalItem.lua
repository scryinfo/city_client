---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/20 11:00
---
RentalItem = class('RentalItem')
RentalItem.static.TOTAL_H = 209  --整个Item的高度
RentalItem.static.CONTENT_H = 125  --显示内容的高度
RentalItem.static.TOP_H = 100  --top条的高度

--初始化方法 --数据需要当前租金 & 生效日期（当前天 + 配置表读出来的时间：08:00:00）
function RentalItem:initialize(rentalData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect
    self.rentalData = rentalData
    self.toggleData = toggleData  --位于toggle的第几个，左边还是右边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform")  --内容Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open")  --打开状态
    self.toDoBtn = self.viewRect.transform:Find("topRoot/open/doSthBtn")  --打开之后的执行按钮
    self.rentalValueText = self.viewRect.transform:Find("contentRoot/rentalValueText"):GetComponent("Text")  -- 租金显示的值

    --具体字体大小是否从数据库读取？
    self.rentalValueText.text = getPriceString(rentalData.rent, 30, 24).."/D"

    mainPanelLuaBehaviour:AddClick(self.toDoBtn.gameObject, function()
        if not self.viewRect.gameObject.activeSelf then
            return
        end
        ct.OpenCtrl("HouseChangeRentCtrl", self.rentalData)
    end, self)

    Event.AddListener("c_onReceiveHouseRentChange", self.updateInfo, self)
end

--获取是第几个点击了
function RentalItem:getToggleIndex()
    return self.toggleData.index
end

--打开
function RentalItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open

    self.rentalValueText.text = getPriceString(self.rentalData.rent, 30, 24).."/D"

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, RentalItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    return Vector2.New(targetMovePos.x, targetMovePos.y - RentalItem.static.TOTAL_H)
end

--关闭
function RentalItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, 0), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    return Vector2.New(targetMovePos.x, targetMovePos.y - RentalItem.static.TOP_H)
end

--刷新数据
function RentalItem:updateInfo(data)
    if self.rentalData.buildingId ~= data.id then
        return
    end

    self.rentalData.rent = data.num
    if not self.viewRect.gameObject.activeSelf then
        return
    end
    self.rentalValueText.text = getPriceString(self.rentalData.rent, 30, 24).."/D"
end

function RentalItem:destory()
    destroy(self.viewRect.gameObject)
end
