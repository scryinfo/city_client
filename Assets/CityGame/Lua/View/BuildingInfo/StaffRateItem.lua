---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/05 11:00
---
StaffRateItem = class('StaffRateItem')
StaffRateItem.static.TOTAL_NotAll_H = 418  --整个Item的高度，员工有未找到住所的
StaffRateItem.static.TOTAL_ALLRIGHT_H = 418  --整个Item的高度，员工都有住所
StaffRateItem.static.CONTENT_NotAll_H = 350  --显示内容的高度，员工有未找到住所的
StaffRateItem.static.CONTENT_ALLRIGHT_H = 350  --显示内容的高度，员工都有住所
StaffRateItem.static.TOP_H = 100  --top条的高度

StaffRateItem.static.ROOTRECT_H = 66  --员工未找到住所的UI的高度

--初始化方法  --数据需要接受服务器发送的数据
function StaffRateItem:initialize(staffData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect
    self.staffData = staffData
    self.toggleData = toggleData  --位于toggle的第二个   左边
    self.clickOpenFunc = clickOpenFunc

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform")  --内容Rect
    self.working = self.viewRect.transform:Find("contentRoot/workState/working")
    self.workingTimeText = self.viewRect.transform:Find("contentRoot/workState/working/workingText"):GetComponent("Text")
    self.resting = self.viewRect.transform:Find("contentRoot/workState/resting")
    self.restingTimeText = self.viewRect.transform:Find("contentRoot/workState/resting/restingText"):GetComponent("Text")
    self.perCapitaWageText = self.viewRect.transform:Find("contentRoot/perCapitaWageText"):GetComponent("Text")
    self.totalWageText = self.viewRect.transform:Find("contentRoot/totalWageText"):GetComponent("Text")

    self.openStateTran = self.viewRect.transform:Find("topRoot/open")
    self.totalStaffCountText = self.viewRect.transform:Find("topRoot/open/countText"):GetComponent("Text")
    self.openToDoBtn = self.viewRect.transform:Find("topRoot/open/toDoBtn")
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close")
    self.closeOpenBtn = self.viewRect.transform:Find("topRoot/close/openBtn")

    self.openToDoBtn.localScale = Vector3.zero  --暂时不显示打开按钮
    mainPanelLuaBehaviour:AddClick(self.closeOpenBtn.gameObject, function()
        clickOpenFunc(mgrTable, self.toggleData)
    end, self)
    self:_initData()
end

--初始化界面
function StaffRateItem:_initData()
    --self.statisfactionText.text = (self.staffData.satisfaction * 100).."%"
    --self.statisfactionSlider.value = self.staffData.satisfaction
    self.perCapitaWageText.text = self.staffData.dayWage
    --self.perCapitaWageText.text = os.date("%Y%m%d%H%M%S", os.time())
    self.totalWageText.text = self.staffData.dayWage * self.staffData.totalStaffCount
    self.totalStaffCountText.text = " ("..self.staffData.totalStaffCount..") "

    self.currentTotalH = StaffRateItem.static.TOTAL_ALLRIGHT_H
    self.currentContentH = StaffRateItem.static.CONTENT_ALLRIGHT_H
    self:_checkWorkTime()
end

function StaffRateItem:_checkWorkTime()
    self.workingTimeText.transform.localScale = Vector3.zero
    self.restingTimeText.transform.localScale = Vector3.zero

    if self.staffData.buildingTypeId~=1 then





    local timeTable = getFormatUnixTime(os.time())
    local time = timeTable.year..timeTable.month..timeTable.day
    if HolidayConfig[tonumber(time)] == 0 then  --判断是否是工作日
        self.working.localScale = Vector3.one
        self.resting.localScale = Vector3.zero
        local workTime = PlayerBuildingBaseData[self.staffData.buildingTypeId].workTime
        if #workTime == 0 then
            return
        end
        if #workTime == 1 then
            self.workingTimeText.transform.localScale = Vector3.one
            self.workingTimeText.text = string.format("%s:00-%s:00", self:_getTimeFormat(workTime[1][1]), self:_getTimeFormat(workTime[1][2]))
        else
            self.workingTimeText.transform.localScale = Vector3.one
            --
            for i, timeData in pairs(workTime) do
                local temp = timeData[1] + timeData[2]
                if tonumber(timeTable.hour) >= timeData[1] and tonumber(timeTable.hour) < temp then  --在工作时间内
                    self.workingTimeText.text = string.format("%s:00-%s:00", self:_getTimeFormat(timeData[1]), self:_getTimeFormat(temp))
                    return
                end
            end
            self.working.localScale = Vector3.zero
            self.resting.localScale = Vector3.one
            self.restingTimeText.transform.localScale = Vector3.zero
        end
    else
        self.working.localScale = Vector3.zero
        self.resting.localScale = Vector3.one
        self.restingTimeText.transform.localScale = Vector3.zero
    end

    end
end

function StaffRateItem:_getTimeFormat(value)
    if value < 10 then
        return "0"..value
    end
    return value
end

--获取是第几个点击了
function StaffRateItem:getToggleIndex()
    return self.toggleData.index
end

--点击打开按钮
function StaffRateItem:_clickOpenBtn()
    if self.clickOpenFunc then
        self.clickOpenFunc()
    end
end

--点击DoSth按钮
function StaffRateItem:_clickToDoBtn(ins)
    --打开工资调整界面
    --local value = {dayWage = self.staffData.dayWage, workerNum = self.m_data.totalStaffCount, callBackFunc = function ()
    --    --xxx
    --end}
    --ct.OpenCtrl("WagesAdjustBoxCtrl", value)
end

--打开
function StaffRateItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open
    self.openStateTran.localScale = Vector3.one
    self.closeStateTran.localScale = Vector3.zero
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, self.currentContentH), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    return Vector2.New(targetMovePos.x, targetMovePos.y - self.currentTotalH)
end

--关闭
function StaffRateItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close
    self.openStateTran.localScale = Vector3.zero
    self.closeStateTran.localScale = Vector3.one
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    return Vector2.New(targetMovePos.x,targetMovePos.y - StaffRateItem.static.TOP_H)
end

--刷新数据
function StaffRateItem:updateInfo(data)
    if self.staffData.buildingId ~= data.id then
        return
    end

    self.staffData.dayWage = data.num
    if not self.viewRect.gameObject.activeSelf then
        return
    end

    self.perCapitaWageText.text = self.staffData.dayWage
    self.totalWageText.text = self.staffData.dayWage * self.staffData.totalStaffCount
end

function StaffRateItem:destory()
    destroy(self.viewRect.gameObject)
end