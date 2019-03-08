WarehouseRateItem = class('WarehouseRateItem');
--WarehouseRateItem.static.TOTAL_H = 475  --整个Item的高度
--WarehouseRateItem.static.CONTENT_H = 410  --显示内容的高度
--WarehouseRateItem.static.TOP_H = 100  --top条的高度
WarehouseRateItem.static.TOTAL_H = 200  --整个Item的高度
WarehouseRateItem.static.CONTENT_H = 136  --显示内容的高度
WarehouseRateItem.static.TOP_H = 100  --top条的高度

--初始化方法   数据需要接受服务器发送的数据
function WarehouseRateItem:initialize(warehouseData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect;
    self.warehouseData = warehouseData;
    self.toggleData = toggleData  --位于toggle的第三个  左边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --打开状态
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");  --关闭状态
    self.openBtns = self.viewRect.transform:Find("topRoot/close/openBtns");  --打开按钮
    self.toDoBtns = self.viewRect.transform:Find("topRoot/open/toDoBtns");  --跳转页面
    self.sizeSlider = self.viewRect.transform:Find("contentRoot/sizeSlider"):GetComponent("Slider");  -- slider
    self.numberText = self.viewRect.transform:Find("contentRoot/number"):GetComponent("Text");
    self.openName = self.viewRect.transform:Find("topRoot/open/nameText"):GetComponent("Text");
    self.closeName = self.viewRect.transform:Find("topRoot/close/nameText"):GetComponent("Text");

    mainPanelLuaBehaviour:AddClick(self.openBtns.gameObject, function()
        PlayMusEff(1002)
        clickOpenFunc(mgrTable, self.toggleData)
    end);
    mainPanelLuaBehaviour:AddClick(self.toDoBtns.gameObject,function()
        if not self.viewRect.gameObject.activeSelf then
            return
        end
        PlayMusEff(1002)
        if self.warehouseData.info.state == "OPERATE" then
            if self.warehouseData.buildingType == BuildingType.MaterialFactory then
                ct.OpenCtrl("WarehouseCtrl",self.warehouseData)
            elseif self.warehouseData.buildingType == BuildingType.ProcessingFactory then
                ct.OpenCtrl("ProcessWarehouseCtrl",self.warehouseData)
            elseif self.warehouseData.buildingType == BuildingType.RetailShop then
                ct.OpenCtrl("RetailWarehouseCtrl",self.warehouseData)
            end
        else
            Event.Brocast("SmallPop",GetLanguage(35040013),300)
            return
        end
    end);
    self:initData()

    --self.sizeSlider.maxValue = PlayerBuildingBaseData[self.warehouseData.info.mId].storeCapacity;
    --self.sizeSlider.value = self:getWarehouseCapacity(self.warehouseData.store);
    --self.numberText.text = getColorString(self.sizeSlider.value,self.sizeSlider.maxValue,"black","black");
    --Event.AddListener("c_onOccupancyValueChange", function (data)  --响应数据改变
    --    --    mgrTable:houseOccDataUpdate(data)
    --    --end);
    Event.AddListener("c_onOccupancyValueChange",self.updateInfo,self)
    --Event.AddListener("updateWarehouseNum",self.updateWarehouseNum,self)
end
--初始化数据
function WarehouseRateItem:initData()
    self.sizeSlider.maxValue = PlayerBuildingBaseData[self.warehouseData.info.mId].storeCapacity
    self.sizeSlider.value = self:getWarehouseCapacity(self.warehouseData.store)
    local lockedNum = self:getLockedNum(self.warehouseData.store);
    local numTab = {}
    numTab["num1"] = self.sizeSlider.value
    numTab["num2"] = lockedNum
    numTab["num3"] = self.sizeSlider.maxValue
    numTab["col1"] = "Cyan"
    numTab["col2"] = "Teal"
    numTab["col3"] = "Black"
    self.numberText.text = getColorString(numTab);
    self.openName.text = GetLanguage(25020003)
    self.closeName.text = GetLanguage(25020003)
    WarehouseRateItem.warehouseCapacity = self.sizeSlider.maxValue - self.sizeSlider.value
end
--获取仓库容量
function WarehouseRateItem:getWarehouseCapacity(table)
    local warehouseCapacity = 0
    local locked = 0
    if not table.inHand then
        warehouseCapacity = warehouseCapacity + locked
        return warehouseCapacity;
    else
        for k,v in pairs(table.inHand) do
            warehouseCapacity = warehouseCapacity + v.n
        end
        if not table.locked then
            locked = 0
        else
            for i,t in pairs(table.locked) do
                locked = locked + t.n
            end
        end
        --warehouseCapacity = warehouseCapacity + locked
        return warehouseCapacity
    end
end
--获取锁着的数量
function WarehouseRateItem:getLockedNum(table)
    local lockedNum = 0
    if not table.inHand then
        return lockedNum
    end
    if not table.locked then
        return lockedNum
    end
    for i,v in pairs(table.locked) do
        lockedNum = lockedNum + v.n
    end
    return lockedNum
end
--获取是第几个点击了
function WarehouseRateItem:getToggleIndex()
    return self.toggleData.index;
end

--打开
function WarehouseRateItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open;

    self.openStateTran.localScale = Vector3.one;
    self.closeStateTran.localScale = Vector3.zero;

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, WarehouseRateItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - WarehouseRateItem.static.TOTAL_H - 5);
end

--关闭
function WarehouseRateItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close;

    self.openStateTran.localScale = Vector3.zero;
    self.closeStateTran.localScale = Vector3.one;

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - WarehouseRateItem.static.TOP_H - 5);
end

--刷新数据
function WarehouseRateItem:updateInfo(data)
    self.warehouseData = data
    self.warehouseData.store = data.store
    self:initData();
end
----刷新建筑页面数量
--function WarehouseRateItem:updateWarehouseNum()
--    self.sizeSlider.maxValue = PlayerBuildingBaseData[self.warehouseData.info.mId].storeCapacity
--    self.nowValue
--    self.sizeSlider.value = self:getWarehouseCapacity(self.warehouseData.store)
--    local lockedNum = self:getLockedNum(self.warehouseData.store);
--    local numTab = {}
--    numTab["num1"] = self.sizeSlider.value
--    numTab["num2"] = lockedNum
--    numTab["num3"] = self.sizeSlider.maxValue
--    numTab["col1"] = "Cyan"
--    numTab["col2"] = "Teal"
--    numTab["col3"] = "Black"
--    self.numberText.text = getColorString(numTab);
--    --WarehouseRateItem.warehouseCapacity = self.sizeSlider.maxValue - self.sizeSlider.value
--end