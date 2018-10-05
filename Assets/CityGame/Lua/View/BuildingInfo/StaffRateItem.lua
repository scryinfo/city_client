---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/05 11:00
---

local class = require 'Framework/class'

StaffRateItem = class('StaffRateItem')
StaffRateItem.static.TOTAL_NotAll_H = 407  --整个Item的高度，员工有未找到住所的
StaffRateItem.static.TOTAL_ALLRIGHT_H = 347  --整个Item的高度，员工都有住所
StaffRateItem.static.CONTENT_NotAll_H = 338  --显示内容的高度，员工有未找到住所的
StaffRateItem.static.CONTENT_ALLRIGHT_H = 278  --显示内容的高度，员工都有住所
StaffRateItem.static.TOP_H = 100  --top条的高度

StaffRateItem.static.ROOTRECT_H = 66  --员工未找到住所的UI的高度

--初始化方法  --数据需要接受服务器发送的数据
function StaffRateItem:initialize(staffData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect;
    self.staffData = staffData;
    self.toggleData = toggleData;  --位于toggle的第二个   左边
    self.clickOpenFunc = clickOpenFunc;

    local viewTrans = self.viewRect.transform;
    self.contentRoot = viewTrans:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.rootRect = viewTrans:Find("contentRoot/rootRect"):GetComponent("RectTransform");  --内容Rect
    self.perCapitaWageText = viewTrans:Find("contentRoot/rootRect/root2/comonRoot/perCapitaWageText"):GetComponent("Text");
    self.totalWageText = viewTrans:Find("contentRoot/rootRect/root2/comonRoot/totalWageText"):GetComponent("Text");  --总工资
    self.statisfactionSlider = viewTrans:Find("contentRoot/rootRect/root2/comonRoot/statisfactionSlider"):GetComponent("Slider");   -- 员工满意度slider
    self.sliderFillImg = viewTrans:Find("contentRoot/rootRect/root2/comonRoot/statisfactionSlider/Background/Fill"):GetComponent("Image");   -- slider填充的颜色
    self.statisfactionText = viewTrans:Find("contentRoot/rootRect/root2/comonRoot/statisfactionSlider/Background/Fill/Text"):GetComponent("Text");   -- 员工满意度text
    self.noDomicileRoot = viewTrans:Find("contentRoot/rootRect/root2/noDomicileRoot");   -- 员工没有找到住所才显示
    self.noDomicileText = viewTrans:Find("contentRoot/rootRect/root2/noDomicileRoot/noDomicileText"):GetComponent("Text");   --

    self.openStateTran = viewTrans:Find("topRoot/open");  --打开状态
    self.closeStateTran = viewTrans:Find("topRoot/close");  --关闭状态
    self.totalStaffCountText = viewTrans:Find("topRoot/open/countText"):GetComponent("Text");  --住宅员工人数
    self.toDoBtn = viewTrans:Find("topRoot/open/toDoBtn");
    self.openBtn = viewTrans:Find("topRoot/close/openBtn");  --打开按钮
    self.errorTipTrans = viewTrans:Find("topRoot/close/errorTipImg");  --当自己查看界面且有员工未找到住所时显示

    mainPanelLuaBehaviour:AddClick(self.openBtn.gameObject, function()
        clickOpenFunc(mgrTable, self.toggleData)
    end, self);

    --mainPanelLuaBehaviour:AddClick(self.openBtn.gameObject, self._clickOpenBtn, self);  --这个写法有问题
    mainPanelLuaBehaviour:AddClick(self.toDoBtn.gameObject, self._clickToDoBtn, self);

    Event.AddListener("c_onStaffValueChange", self.updateInfo, self);

    self:_initData()
end

--初始化界面
function StaffRateItem:_initData()
    self.statisfactionText.text = (self.staffData.EmployeeSatisfaction * 100).."%"
    self.statisfactionSlider.value = self.staffData.EmployeeSatisfaction
    self.perCapitaWageText.text = self.staffData.EmployeeDaywages
    self.totalWageText.text = self.staffData.EmployeeDaywages * self.staffData.totalStaffCount

    --如果有未找到房子的员工，则显示
    if self.staffData.noDomicileCount >= 1 then
        self.isAllRight = false
        self.rootRect.sizeDelta = Vector2.New(self.rootRect.sizeDelta, StaffRateItem.static.ROOTRECT_H)
        self.noDomicileRoot.localScale = Vector3.one
        self.noDomicileText.text = string.format("<color=%s>%d</color>/%d", "#D3301A", self.staffData.noDomicileCount, self.staffData.totalStaffCount)
        self.currentTotalH = StaffRateItem.static.TOTAL_NotAll_H
        self.currentContentH = StaffRateItem.static.CONTENT_NotAll_H
    else
        self.isAllRight = true
        self.rootRect.sizeDelta = Vector2.New(self.rootRect.sizeDelta, 0)
        self.noDomicileRoot.localScale = Vector3.zero
        self.currentTotalH = StaffRateItem.static.TOTAL_ALLRIGHT_H
        self.currentContentH = StaffRateItem.static.CONTENT_ALLRIGHT_H
    end

    if self.staffData.EmployeeSatisfaction <= 0.3 then  --员工满意度低于30，则显示红色
        self.sliderFillImg.color = getColorByInt(177, 38, 15)
    else
        self.sliderFillImg.color = getColorByInt(32, 182, 127)
    end
end

--获取是第几个点击了
function StaffRateItem:getToggleIndex()
    return self.toggleData.index;
end

--点击打开按钮
function StaffRateItem:_clickOpenBtn()
    if self.clickOpenFunc then
        self.clickOpenFunc()
        log("cycle_w6_houseAndGround", "----------------------------------")
    end
end

--点击DoSth按钮
function StaffRateItem:_clickToDoBtn()
    --打开工资调整界面
    log("cycle_w6_houseAndGround", "啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊阿啊啊啊啊啊啊")
end

--打开
function StaffRateItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open;

    self.openStateTran.localScale = Vector3.one;
    self.closeStateTran.localScale = Vector3.zero;

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, self.currentContentH), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x, targetMovePos.y - self.currentTotalH);
end

--关闭
function StaffRateItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close;

    self.openStateTran.localScale = Vector3.zero;
    self.closeStateTran.localScale = Vector3.one;

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    if not self.isAllRight then
        self.errorTipTrans.localScale = Vector3.one
    else
        self.errorTipTrans.localScale = Vector3.zero
    end

    return Vector2.New(targetMovePos.x,targetMovePos.y - StaffRateItem.static.TOP_H);
end

--刷新数据
function StaffRateItem:updateInfo(data)

end