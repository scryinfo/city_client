---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/19 17:03
---
OccupancyRateItem = class('OccupancyRateItem')
OccupancyRateItem.static.TOTAL_H = 345  --整个Item的高度
OccupancyRateItem.static.CONTENT_H = 276  --显示内容的高度
OccupancyRateItem.static.TOP_H = 100  --top条的高度
OccupancyRateItem.static.OccupancyTextColor = "#FFFFFF"

--初始化方法
function OccupancyRateItem:initialize(occupancyData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect
    self.occupancyData = occupancyData
    self.toggleData = toggleData  --位于toggle的第几个，左边还是右边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform")  --内容Rect
    self.rentalValueText = self.viewRect.transform:Find("contentRoot/rentalValueText"):GetComponent("Text")
    self.occupancySlider = self.viewRect.transform:Find("contentRoot/occupancySlider"):GetComponent("Slider")  -- slider
    self.occupancyText = self.viewRect.transform:Find("contentRoot/occupancyText"):GetComponent("Text")

    self.rentalValueText.text = getPriceString(occupancyData.rent, 30, 24).."/D"
    self.occupancySlider.maxValue = occupancyData.totalCount
    self.occupancySlider.value = occupancyData.renter
    self.occupancyText.text = string.format("%d<color=%s>/%d</color>", occupancyData.renter, OccupancyRateItem.static.OccupancyTextColor, occupancyData.totalCount)
    --language
    self.titleText01 = self.viewRect.transform:Find("topRoot/nameText"):GetComponent("Text")
    self.occRateText02 = self.viewRect.transform:Find("contentRoot/Text01"):GetComponent("Text")
    self.oneRoomText03 = self.viewRect.transform:Find("contentRoot/Text"):GetComponent("Text")

    self.openToDoBtn = self.viewRect.transform:Find("topRoot/open/doSthBtn")
    if occupancyData.isOther then
        self.openToDoBtn.localScale = Vector3.zero
    else
        self.openToDoBtn.localScale = Vector3.one
        mainPanelLuaBehaviour:AddClick(self.openToDoBtn.gameObject, self._clickToDoBtn, self)
    end

    Event.AddListener("c_onReceiveHouseRentChange", self._rentPriceChange, self)
    self:_lanuage()
end

function OccupancyRateItem:_lanuage()
    self.titleText01.text = GetLanguage(37040010)
    self.occRateText02.text = GetLanguage(37040012)
    self.oneRoomText03.text = GetLanguage(37040011)
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
    if not self.viewRect.gameObject.activeSelf then
        return
    end
    self.occupancyData = data
    self.occupancySlider.value = self.occupancyData.renter
    self.occupancyText.text = string.format("%d<color=%s>/%d</color>", self.occupancyData.renter, OccupancyRateItem.static.OccupancyTextColor, self.occupancyData.totalCount)
    self.rentalValueText.text = getPriceString(self.occupancyData.rent, 30, 24).."/D"
    self:_lanuage()
end
--房租改变
function OccupancyRateItem:_rentPriceChange(data)
    if self.occupancyData.buildingId ~= data.buildingId then
        return
    end

    self.occupancyData.rent = data.rent
    if not self.viewRect.gameObject.activeSelf then
        return
    end
    self.rentalValueText.text = getPriceString(self.occupancyData.rent, 30, 24).."/D"
end

function OccupancyRateItem:_clickToDoBtn(ins)
    PlayMusEff(1002)
    ct.OpenCtrl("HouseSetRentalDialogPageCtrl", ins.occupancyData)
end

function OccupancyRateItem:destory()
    destroy(self.viewRect.gameObject)
end