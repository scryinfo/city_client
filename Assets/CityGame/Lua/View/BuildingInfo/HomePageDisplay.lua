HomePageDisplay = class('HomePageDisplay')

--初始化
function HomePageDisplay:initialize(type,goodsDataInfo,prefab)
    if type == ct.homePage.shelf then
        self:homePageShelf(goodsDataInfo,prefab)
    elseif type == ct.homePage.productionLine then
        self:homePageProductionLine(goodsDataInfo,prefab)
    end
end

--主页货架
function HomePageDisplay:homePageShelf(homePageShelfInfo,prefab)
    self.prefab = prefab;
    self.itemId = homePageShelfInfo.k.id
    self.iconImg = self.prefab.transform:Find("iconImg"):GetComponent("Image");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.numberText = self.prefab.transform:Find("numberText"):GetComponent("Text");
    self.moneyText = self.prefab.transform:Find("pricetag/MoneyText"):GetComponent("Text");

    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(homePageShelfInfo.k.id / 100000) == materialKey then
        --self.nameText.text = Material[homePageShelfInfo.k.id].name
        self.nameText.text = GetLanguage(homePageShelfInfo.k.id)
        panelMgr:LoadPrefab_A(Material[homePageShelfInfo.k.id].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.iconImg.sprite = texture
            end
        end)
    elseif math.floor(homePageShelfInfo.k.id / 100000) == goodsKey then
        self.nameText.text = GetLanguage(homePageShelfInfo.k.id)
        panelMgr:LoadPrefab_A(Good[homePageShelfInfo.k.id].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.icon.sprite = texture
            end
        end)
    end
    self.numberText.text = homePageShelfInfo.n
    self.moneyText.text = getPriceString("E"..homePageShelfInfo.price..".0000",15,13)
end
--主页生产线
function HomePageDisplay:homePageProductionLine(homePageProductionLineInfo,prefab)
    self.prefab = prefab;
    self.id = homePageProductionLineInfo.id
    self.iconIcon = self.prefab.transform:Find("iconmg/iconIcon"):GetComponent("Image");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.timeText = self.prefab.transform:Find("timeImg/timeText"):GetComponent("Text");
    self.productionText = self.prefab.transform:Find("productionText"):GetComponent("Text");
    self.productionSlider = self.prefab.transform:Find("productionSlider"):GetComponent("Slider");
    self.numberText = self.prefab.transform:Find("numberText"):GetComponent("Text");

    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(homePageProductionLineInfo.itemId / 100000) == materialKey then
        --self.nameText.text = Material[homePageProductionLineInfo.itemId].name
        self.nameText.text = GetLanguage(homePageProductionLineInfo.itemId)
        panelMgr:LoadPrefab_A(Material[homePageProductionLineInfo.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.iconIcon.sprite = texture
            end
        end)
    elseif math.floor(homePageProductionLineInfo.itemId / 100000) == goodsKey then
        self.nameText.text = GetLanguage(homePageProductionLineInfo.itemId)
        panelMgr:LoadPrefab_A(Good[homePageProductionLineInfo.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.iconIcon.sprite = texture
            end
        end)
    end
    --self.nameText.text = Material[homePageProductionLineInfo.itemId].name
    self.timeText.text = self:getTimeNumber(homePageProductionLineInfo)
    self.productionText.text = self:getMinuteNum(homePageProductionLineInfo)
    self.productionSlider.maxValue = homePageProductionLineInfo.targetCount
    self.productionSlider.value = homePageProductionLineInfo.nowCount
    self.maxValue = homePageProductionLineInfo.targetCount
    self.numberText.text = self.productionSlider.value.."/"..self.productionSlider.maxValue

    Event.AddListener("c_refreshNowConte",self.refreshNowConte,self)
end
--计算时间
function HomePageDisplay:getTimeNumber(infoData)
    if not infoData then
        return
    end
    --剩余产量
    local remainingNum = infoData.targetCount - infoData.nowCount
    if remainingNum == 0 then
        return "00:00:00"
    end
    local materialKey,goodsKey = 21,22
    local time = 0
    if math.floor(infoData.itemId / 100000) == materialKey then
        time = 1 / Material[infoData.itemId].numOneSec / infoData.workerNum * remainingNum
    elseif math.floor(infoData.itemId / 100000) == goodsKey then
        time = 1 / Good[infoData.itemId].numOneSec / infoData.workerNum * remainingNum
    end
    self.remainingTime = time
    UpdateBeat:Add(self.Update,self)
    local timeTable = getTimeBySec(time)
    local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
    return timeStr
end
--计算每分钟产量
function HomePageDisplay:getMinuteNum(infoData)
    if not infoData then
        return
    end
    local number = 0
    local materialKey,goodsKey = 21,22
    if math.floor(infoData.itemId / 100000) == materialKey then
        number = Material[infoData.itemId].numOneSec * infoData.workerNum * 60
    elseif math.floor(infoData.itemId / 100000) == goodsKey then
        number = Good[infoData.itemId].numOneSec * infoData.workerNum * 60
    end
    local numStr = "("..math.floor(number).."/min"..")"
    return numStr
end
--刷新时间
function HomePageDisplay:Update()
    if WarehouseRateItem.warehouseCapacity <= 0 then
        UpdateBeat:Remove(self.Update,self)
        return
    end
    if self.remainingTime <= 1 then
        self.timeText.text = "00:00:00"
        UpdateBeat:Remove(self.Update,self);
        return
    else
        self.remainingTime = self.remainingTime - UnityEngine.Time.unscaledDeltaTime
        local timeTable = getTimeBySec(self.remainingTime)
        local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
        self.timeText.text = timeStr
    end
end
--刷新目前产量
function HomePageDisplay:refreshNowConte(msg)
    if not msg then
        return
    end
    for i,v in pairs(HomeProductionLineItem.productionTab) do
        if v.id == msg.id then
            v.productionSlider.value = msg.nowCount
            v.numberText.text = msg.nowCount.."/"..self.maxValue
        end
    end
end
--移除事件
function HomePageDisplay:closeEvent()
    UpdateBeat:Remove(self.Update,self);
    Event.RemoveListener("c_refreshNowConte")
end