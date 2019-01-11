SmallProductionLineItem = class('SmallProductionLineItem')

--初始化方法
function SmallProductionLineItem:initialize(goodsDataInfo,prefab,inluabehaviour,i,manager)
    self.prefab = prefab;
    self.manager = manager;
    self.goodsDataInfo = goodsDataInfo;
    self.buildingId = goodsDataInfo.buildingId
    self._luabehaviour = inluabehaviour;
    self.companyNameText = self.prefab.transform:Find("Top/companyNameText"):GetComponent("Text");  --品牌名字
    self.modificationBtn = self.prefab.transform:Find("Top/modificationBtn");  --修改名字
    self.minText = self.prefab.transform:Find("Top/minText"):GetComponent("Text");  --没分钟多少个
    self.nameText = self.prefab.transform:Find("Top/nameText"):GetComponent("Text");  --原料名字
    self.timeText = self.prefab.transform:Find("Top/timeIcon/timeText"):GetComponent("Text");  --时间
    self.time_Slider = self.prefab.transform:Find("Top/time_Slider"):GetComponent("Slider");
    self.XBtn = self.prefab.transform:Find("Top/XBtn");
    self.goodsIcon = self.prefab.transform:Find("goodsbg/goodsIcon"):GetComponent("Image");

    self.tipsText = self.prefab.transform:Find("Productionbg/tipsText"):GetComponent("RectTransform");
    self.inputNumber = self.prefab.transform:Find("Productionbg/inputNumber"):GetComponent("InputField");
    self.pNumberScrollbar = self.prefab.transform:Find("Productionbg/numberScrollbar"):GetComponent("Slider");
    self.productionNumber = self.prefab.transform:Find("Productionbg/houseIcon/numberText"):GetComponent("Text");
    self.staffNumberText = self.prefab.transform:Find("Staffbg/numberbg/numberText"):GetComponent("Text");
    self.sNumberScrollbar = self.prefab.transform:Find("Staffbg/numberScrollbar"):GetComponent("Slider");

    --修改确认
    self.adjustmentTop = self.prefab.transform:Find("adjustmentTop");
    self.addBtn = self.prefab.transform:Find("adjustmentTop/button/addBtn");  --添加线
    self.amendBtn = self.prefab.transform:Find("adjustmentTop/button/amendBtn");  --修改线
    self.notConfirmBtn = self.prefab.transform:Find("adjustmentTop/button/notConfirmBtn");  --不能点击
    self.closeBtn = self.prefab.transform:Find("adjustmentTop/button/closeBtn");  --关闭修改添加父物体

    --新添加的线
    if not i then
        self:initUiInfo(self.goodsDataInfo)
    else
        --读到的线
        self:RefreshUiInfo(self.goodsDataInfo,i)
    end
    self.pNumberScrollbar.onValueChanged:AddListener(function()
        self:pNumberScrollbarInfo();
    end)
    self.sNumberScrollbar.onValueChanged:AddListener(function()
        self:sNumberScrollbarInfo();
    end)
    self.inputNumber.onValueChanged:AddListener(function()
        self:inputInfo();
    end)
    self._luabehaviour:AddClick(self.XBtn.gameObject, self.OnClicl_XBtn, self);
    self._luabehaviour:AddClick(self.closeBtn.gameObject,self.OnClicl_closeBtn,self);
    self._luabehaviour:AddClick(self.addBtn.gameObject,self.OnClicl_addBtn,self);
end
--新加线
function SmallProductionLineItem:initUiInfo(infoData)
    self.adjustmentTop.localScale = Vector3.one
    self:initButtonState()
    self.itemId = infoData.itemId
    self.inputNumber.text = 0;
    self.pNumberScrollbar.maxValue = AdjustProductionLineCtrl.residualCapacity;
    self.timeText.text = "00:00:00"
    self.time_Slider.value = 0;
    self.staffNumberText.text = "0";
    self.sNumberScrollbar.maxValue = AdjustProductionLineCtrl.idleWorkerNums / 5;
    self.sNumberScrollbar.value = 0
    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(self.itemId / 100000) == materialKey then
        self.nameText.text = Material[self.itemId].name
        panelMgr:LoadPrefab_A(Material[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.goodsIcon.sprite = texture
            end
        end)
    elseif math.floor(self.itemId / 100000) == goodsKey then
        self.nameText.text = Good[self.itemId].name
        panelMgr:LoadPrefab_A(Good[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.goodsIcon.sprite = texture
            end
        end)
    end
end
--读到线
function SmallProductionLineItem:RefreshUiInfo(infoTab,i)
    self.adjustmentTop.localScale = Vector3.zero
    self.id = i
    self.lineId = infoTab.id
    self.itemId = infoTab.itemId
    self.buildingId = infoTab.buildingId
    self.time_Slider.maxValue = 100;
    self.time_Slider.value = 0;
    self.time_Slider.maxValue = infoTab.targetCount;
    self.time_Slider.value = infoTab.nowCount
    self.inputNumber.text = infoTab.targetCount
    self.pNumberScrollbar.maxValue = AdjustProductionLineCtrl.residualCapacity
    self.pNumberScrollbar.value = infoTab.targetCount
    self.productionNumber.text = 0;     --右上角小房子
    self.staffNumberText.text = tostring(infoTab.workerNum)
    self.sNumberScrollbar.maxValue = (AdjustProductionLineCtrl.idleWorkerNums + infoTab.workerNum) / 5
    self.sNumberScrollbar.value = infoTab.workerNum / 5;

    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(self.itemId / 100000) == materialKey then
        self.nameText.text = Material[self.itemId].name
        panelMgr:LoadPrefab_A(Material[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.goodsIcon.sprite = texture
            end
        end)
    elseif math.floor(self.itemId / 100000) == goodsKey then
        self.nameText.text = Good[self.itemId].name
        panelMgr:LoadPrefab_A(Good[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.goodsIcon.sprite = texture
            end
        end)
    end
    self.timeText.text = self:getTimeNumber(self.goodsDataInfo)
end
--点击发送添加线
function SmallProductionLineItem:OnClicl_addBtn(go)
    Event.Brocast("m_ReqAddLine",go.buildingId,go.inputNumber.text,go.staffNumberText.text,go.itemId)
    go.adjustmentTop.localScale = Vector3.zero
end
--点击删除
function SmallProductionLineItem:OnClicl_XBtn(go)
    if not go.lineId then
        go.manager:_deleteLine(go)
    else
        Event.Brocast("m_ReqDeleteLine",go.buildingId,go.lineId)
    end
end
--关闭添加修改的Top
function SmallProductionLineItem:OnClicl_closeBtn(go)
    go.adjustmentTop.localScale = Vector3.zero
end
--初始化按钮
--初始化状态
function SmallProductionLineItem:initButtonState()
    self.addBtn.localScale = Vector3.zero
    self.amendBtn.localScale = Vector3.zero
    self.notConfirmBtn.localScale = Vector3.one
end
--添加状态
function SmallProductionLineItem:initButtonAddState()
    self.addBtn.localScale = Vector3.one
    self.amendBtn.localScale = Vector3.zero
    self.notConfirmBtn.localScale = Vector3.zero
end
--修改状态
function SmallProductionLineItem:initButtonAmendState()
    self.addBtn.localScale = Vector3.zero
    self.amendBtn.localScale = Vector3.one
    self.notConfirmBtn.localScale = Vector3.zero
end
--刷新滑动条
function SmallProductionLineItem:pNumberScrollbarInfo()
    self.adjustmentTop.localScale = Vector3.one
    if not self.lineId then
        self:initButtonAddState()
    else
        self:initButtonAmendState()
    end
    self.inputNumber.text = self.pNumberScrollbar.value;
end
function SmallProductionLineItem:sNumberScrollbarInfo()
    self.adjustmentTop.localScale = Vector3.one
    if not self.lineId then
        self:initButtonAddState()
    else
        self:initButtonAmendState()
    end
    self.staffNumberText.text = self.sNumberScrollbar.value * 5
end
--刷新输入框
function SmallProductionLineItem:inputInfo()
    self.adjustmentTop.localScale = Vector3.one
    if not self.lineId then
        self:initButtonAddState()
    else
        self:initButtonAmendState()
    end
    local number = self.inputNumber.text;
    if number ~= "" then
        self.pNumberScrollbar.value = number;
    else
        self.pNumberScrollbar.value = 0;
    end
end
--删除后刷新ID及刷新显示
function SmallProductionLineItem:RefreshID(id)
    self.id = id
end
--初始化这条线需要的时间
function SmallProductionLineItem:getTimeNumber(infoData)
    if not infoData then
        return;
    end
    --还有多少个没有生产
    local remainingNum = tonumber(infoData.targetCount) - tonumber(infoData.nowCount)
    if remainingNum == 0 then
        return "00:00:00"
    end
    local materialKey,goodsKey = 21,22
    local time = 0
    if math.floor(self.itemId / 100000) == materialKey then
        time = 1 / Material[self.itemId].numOneSec / infoData.workerNum * remainingNum
    elseif math.floor(self.itemId / 100000) == goodsKey then
        time = 1 / Good[self.itemId].numOneSec / infoData.workerNum * remainingNum
    end
    time = time + UnityEngine.Time.unscaledDeltaTime
    local timeTable = getTimeBySec(time)
    local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
    return timeStr
end
--function SmallProductionLineItem:LateUpdate()
    --if true then
    --
    --end
    --if self.time == 0 then
    --    return
    --end
    --self.time = self.time + UnityEngine.Time.unscaledDeltaTime

--end
------生产线变化推送
--function SmallProductionLineItem:refreshTimeText(msg)
--    if not msg then
--        return;
--    end
--    for i,v in pairs(msg) do
--        for i,k in pairs(AdjustProductionLineCtrl.materialProductionLine) do
--            if v.id == k.lineId then
--
--            end
--        end
--    end
--
--
--
--
--    for i,n in pairs(msg) do
--        for k,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
--            local remainingNum = tonumber(v.time_Slider.maxValue) - msg.nowCount
--            local time = 1 / Material[v.itemId].numOneSec / tonumber(v.staffNumberText.text) * remainingNum
--            local timeTab = getTimeString(time)
--
--            if v.lineId == msg.id then
--                v.timeText.text = timeTab
--            end
--            if remainingNum > 0 then
--                v.timeText.text = timeTab
--            elseif remainingNum < 0 or remainingNum == 0 then
--                v.timeText.text = "00:00:00"
--            end
--        end
--    end
--end

