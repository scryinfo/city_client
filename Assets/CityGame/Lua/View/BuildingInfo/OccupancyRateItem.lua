---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/19 17:03
---
local class = require 'Framework/class'

OccupancyRateItem = class('OccupancyRateItem')
OccupancyRateItem.static.TOTAL_H = 345  --整个Item的高度
OccupancyRateItem.static.CONTENT_H = 276  --显示内容的高度
OccupancyRateItem.static.TOP_H = 100  --top条的高度

--初始化方法 --数据需要住宅容量（读配置表）以及当前入住人数
function OccupancyRateItem:initialize(occupancyData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect
    self.occupancyData = occupancyData
    self.toggleData = toggleData  --位于toggle的第几个，左边还是右边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.brandText = self.viewRect.transform:Find("contentRoot/brandText"):GetComponent("Text");  -- 品牌值
    self.qualityText = self.viewRect.transform:Find("contentRoot/qualityText"):GetComponent("Text");  -- 品质
    self.occupancySlider = self.viewRect.transform:Find("contentRoot/occupancySlider"):GetComponent("Slider");  -- slider
    self.occupancyText = self.viewRect.transform:Find("contentRoot/occupancySlider/Text"):GetComponent("Text");  -- slider显示的值

    self.occupancySlider.maxValue = occupancyData.totalCount  --暂时不知道这个字段叫什么，从配置表中读取
    self.occupancySlider.value = occupancyData.renter
    self.occupancyText.text = occupancyData.renter.."/"..occupancyData.totalCount

    --log("cycle_w5","------- Occ实例化"..self.openBtn.gameObject:GetInstanceID())

    --mainPanelLuaBehaviour:AddClick(self.openBtn.gameObject, function()
    --    clickOpenFunc(mgrTable, self.toggleData)
    --end);                                                              --这个方法是mgr传来的，每次点击都会调一次

    --Event.AddListener("c_onOccupancyValueChange", function (data)  --响应数据改变
    --    --    mgrTable:houseOccDataUpdate(data)
    --    --end);

    Event.AddListener("c_onOccupancyValueChange", self.updateInfo, self);
end

--获取是第几个点击了
function OccupancyRateItem:getToggleIndex()
    return self.toggleData.index
end

--打开
function OccupancyRateItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open

    self.occupancySlider.value = self.occupancyData.renter
    self.occupancyText.text = self.occupancyData.renter.."/"..self.occupancyData.totalCount

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, OccupancyRateItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    --self.contentRoot.sizeDelta = Vector2.New(self.contentRoot.sizeDelta.x, OccupancyRateItem.static.CONTENT_H) --打开显示内容
    --self.viewRect.anchoredPosition = targetMovePos  --移动到目标位置

    return Vector2.New(targetMovePos.x, targetMovePos.y - OccupancyRateItem.static.TOTAL_H)
end

--关闭
function OccupancyRateItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, 0), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    return Vector2.New(targetMovePos.x, targetMovePos.y - OccupancyRateItem.static.TOP_H)
end

--刷新数据
function OccupancyRateItem:updateInfo(data)
    self.occupancyData = data

    if not self.viewRect.gameObject.activeSelf then
        return
    end

    self.occupancySlider.value = self.occupancyData.renter
    self.occupancyText.text = self.occupancyData.renter.."/"..self.occupancyData.totalCount
end