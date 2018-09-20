---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/20 11:00
---
local class = require 'Framework/class'

RentalItem = class('RentalItem')
RentalItem.static.TOTAL_H = 90  --整个Item的高度
RentalItem.static.CONTENT_H = 47  --显示内容的高度
RentalItem.static.TOP_H = 43  --top条的高度

--初始化方法 --数据需要当前租金 & 生效日期（当前天 + 配置表读出来的时间：08:00:00）
function RentalItem:initialize(rentalData, clickOpenFunc, viewRect, mainPanelLuaBehaviour)
    self.viewRect = viewRect
    self.rentalData = rentalData

    self.contentRoot = self.view.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.openStateTran = self.view.transform:Find("topRoot/open");  --打开状态
    self.closeStateTran = self.view.transform:Find("topRoot/close");  --关闭状态
    self.openBtn = self.view.transform:Find("topRoot/close/openBtn");  --打开按钮
    self.toDoBtn = self.view.transform:Find("topRoot/open/doSthBtn");  --打开之后的执行按钮
    self.rentalValueText = self.view.transform:Find("contentRoot/rentalValueText"):GetComponent("Text");  -- 租金显示的值

    --具体字体大小是否从数据库读取？
    self.rentalValueText.text = self:getPriceString(rentalData.rent, 14, 10)

    mainPanelLuaBehaviour:AddClick(self.openBtn.gameObject, clickOpenFunc);  --这个方法是mgr传来的，每次点击都会调一次
    mainPanelLuaBehaviour:AddClick(self.toDoBtn.gameObject, RentalItem.changeRentPrice);  --打开更改租金界面
end

--打开
function RentalItem:openToggleItem(targetMovePos)
    self.BuildingInfoToggleState = BuildingInfoToggleState.Open

    self.rentalValueText = self:getPriceString(self.rentalData.rent, 14, 10)
    self.openStateTran.localScale = Vector3.one
    self.closeStateTran.localScale = Vector3.zero

    self.contentRoot.sizeDelta = Vector2.New(self.contentRoot.sizeDelta.x, RentalItem.static.CONTENT_H) --打开显示内容
    self.viewRect.anchoredPosition = targetMovePos  --移动到目标位置
end

--关闭
function RentalItem:closeToggleItem(targetMovePos)
    self.BuildingInfoToggleState = BuildingInfoToggleState.Close

    self.openStateTran.localScale = Vector3.zero
    self.closeStateTran.localScale = Vector3.one

    self.contentRoot.sizeDelta = Vector2.New(self.contentRoot.sizeDelta.x, 0) --关闭显示内容
    self.viewRect.anchoredPosition = targetMovePos  --移动到目标位置
end

--刷新数据
function RentalItem:updateInfo(rent)
    self.rentalData.rent = rent

    if not self.viewRect.gameObject.activeSelf then
        return
    end

    self.rentalValueText = self:getPriceString(self.rentalData.rent, 14, 10)
end

--打开更改租金界面
function RentalItem:changeRentPrice()
    if not self.viewRect.gameObject.activeSelf then
        return
    end


end

--获取价格显示文本 --整数和小数部分大小不同
function RentalItem:getPriceString(str, intSize, floatSize)
    local index = string.find(str, ".")
    local intString = string.sub(str, 1, index)
    local floatString = string.sub(str, index + 1)
    local finalStr = string.format("<size=%d>%s</size><size=%d>%s</size>", intSize, intString, floatSize, floatString)

    return finalStr
end

