SmallProductionLineItem = class('SmallProductionLineItem')

--初始化方法
function SmallProductionLineItem:initialize(goodsDataInfo,prefab,inluabehaviour,i,manager)
    self.prefab = prefab;
    self.manager = manager;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour;
    self.companyNameText = self.prefab.transform:Find("Top/companyNameText"):GetComponent("Text");  --品牌名字
    self.modificationBtn = self.prefab.transform:Find("Top/modificationBtn");  --修改名字
    self.minText = self.prefab.transform:Find("Top/minText"):GetComponent("Text");  --没分钟多少个
    self.nameText = self.prefab.transform:Find("Top/nameText"):GetComponent("Text");  --原料名字
    self.timeText = self.prefab.transform:Find("Top/timeIcon/timeText"):GetComponent("Text");  --时间
    self.time_Slider = self.prefab.transform:Find("Top/time_Slider"):GetComponent("Slider");
    self.XBtn = self.prefab.transform:Find("Top/XBtn");
    self.goodsIcon = self.prefab.transform:Find("goodsIcon");
    self.bgBtn = self.prefab.transform:Find("bgBtn");

    self.tipsText = self.prefab.transform:Find("Productionbg/tipsText"):GetComponent("RectTransform");
    self.inputNumber = self.prefab.transform:Find("Productionbg/inputNumber"):GetComponent("InputField");
    self.pNumberScrollbar = self.prefab.transform:Find("Productionbg/numberScrollbar"):GetComponent("Slider");
    self.productionNumber = self.prefab.transform:Find("Productionbg/houseIcon/numberText"):GetComponent("Text");
    self.staffNumberText = self.prefab.transform:Find("Staffbg/numberbg/numberText"):GetComponent("Text");
    self.sNumberScrollbar = self.prefab.transform:Find("Staffbg/numberScrollbar"):GetComponent("Slider");

    if not i then
        self.itemId = goodsDataInfo.itemId
        self.nameText.text = goodsDataInfo.name
        self.inputNumber.text = 0;
        self.pNumberScrollbar.maxValue = 5000; --先设置5000，每条生产线的最大生产数量是根据仓库容量算的
        self.staffNumberText.text = 0;
        self.timeText.text = "00:00:00"
        self.time_Slider.value = 0;
        self.sNumberScrollbar.maxValue = AdjustProductionLineCtrl.idleWorkerNums;
    else
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
    --self._luabehaviour:AddClick(self.bgBtn.gameObject,self.OnClick_bgBtn,self)


    Event.AddListener("refreshTimeText",self.refreshTimeText,self)
end
--初始化UI信息
function SmallProductionLineItem:RefreshUiInfo(infoTab,i)
    local materialKey,goodsKey = 21,22
    self.id = i
    self.itemId = infoTab.itemId
    if math.floor(self.itemId / 100000) == materialKey then
        self.nameText.text = Material[self.itemId].name
    elseif math.floor(self.itemId / 100000) == goodsKey then
        self.nameText.text = Good[self.itemId].name
    end
    self.lineId = infoTab.id
    self.time_Slider.maxValue = 100;
    self.time_Slider.value = 0;
    self.time_Slider.maxValue = infoTab.targetCount;
    self.time_Slider.value = infoTab.nowCount;
    self.inputNumber.text = infoTab.targetCount;
    self.pNumberScrollbar.value = infoTab.targetCount;
    self.productionNumber.text = 0;     --右上角小房子
    self.staffNumberText.text = infoTab.workerNum;  --最小不能设置5
    self.sNumberScrollbar.maxValue = infoTab.workerNum + AdjustProductionLineCtrl.idleWorkerNums;
    self.sNumberScrollbar.value = infoTab.workerNum;
end
--点击删除
function SmallProductionLineItem:OnClicl_XBtn(go)
    if not go.lineId then
        go.manager:_deleteLine(go)
    else
        Event.Brocast("m_ReqDeleteLine",go.buildingId,go.lineId)
    end
end
--刷新滑动条
function SmallProductionLineItem:pNumberScrollbarInfo()
    self.inputNumber.text = self.pNumberScrollbar.value;
end
function SmallProductionLineItem:sNumberScrollbarInfo()
    self.staffNumberText.text = self.sNumberScrollbar.value;
end
--刷新输入框
function SmallProductionLineItem:inputInfo()
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
--打开组件
function SmallProductionLineItem:OnClick_bgBtn(go)
    go.inputNumber.interactable = true
    go.pNumberScrollbar.interactable = true
    go.sNumberScrollbar.interactable = true
    SmallProductionLineItem.lineid = go.lineId;
    SmallProductionLineItem.number = go.inputNumber.text
    SmallProductionLineItem.staffNum = go.sNumberScrollbar.value
end
--生产线变化推送
function SmallProductionLineItem:refreshTimeText(msg)
    if not msg then
        return;
    end
    for i,n in pairs(msg) do
        for k,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
            local remainingNum = tonumber(v.time_Slider.maxValue) - msg.nowCount
            local time = 1 / Material[v.itemId].numOneSec / tonumber(v.staffNumberText.text) * remainingNum
            local timeTab = getTimeString(time)

            if v.lineId == msg.id then
                v.timeText.text = timeTab
            end
            if remainingNum > 0 then
                v.timeText.text = timeTab
            elseif remainingNum < 0 or remainingNum == 0 then
                v.timeText.text = "00:00:00"
            end
        end
    end
end

