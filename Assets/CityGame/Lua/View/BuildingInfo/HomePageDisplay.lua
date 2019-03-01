HomePageDisplay = class('HomePageDisplay')

--初始化
function HomePageDisplay:initialize(type,goodsDataInfo,prefab,...)
    local arg = {...}
    if type == ct.homePage.shelf then
        self:homePageShelf(goodsDataInfo,prefab)
    elseif type == ct.homePage.productionLine then
        self:homePageProductionLine(goodsDataInfo,prefab,arg)
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
                self.iconImg.sprite = texture
            end
        end)
    end
    self.numberText.text = homePageShelfInfo.n
    self.moneyText.text = "E"..getPriceString(GetClientPriceString(homePageShelfInfo.price),15,13)
end
--主页生产线
function HomePageDisplay:homePageProductionLine(lineInfo,prefab,ageTab)
    self.prefab = prefab;
    self.lineInfo = lineInfo
    self.itemId = lineInfo.itemId
    self.lineId = lineInfo.id

    self.itemGoodsbg = self.prefab.transform:Find("itembg/itemGoodsbg")
    self.itemMaterialbg = self.prefab.transform:Find("itembg/itemMaterialbg")
    self.brandbg = self.prefab.transform:Find("itembg/brandbg")
    self.brandName = self.prefab.transform:Find("itembg/brandbg/brandName"):GetComponent("Text")
    self.brand = self.prefab.transform:Find("itembg/brand")
    self.brandValue = self.prefab.transform:Find("itembg/brand/brandValue"):GetComponent("Text")   --品牌评分
    self.quality = self.prefab.transform:Find("itembg/quality")
    self.qualityValue = self.prefab.transform:Find("itembg/quality/qualityValue"):GetComponent("Text")   --品质评分
    self.nameText = self.prefab.transform:Find("itembg/nameText"):GetComponent("Text")
    self.icon = prefab.transform:Find("itembg/icon"):GetComponent("Image")
    self.accreditIcon = prefab.transform:Find("itembg/accreditIcon")
    self.timeText = prefab.transform:Find("time/timeText"):GetComponent("Text")
    self.productionSlider = prefab.transform:Find("productionSlider"):GetComponent("Slider")
    self.numberText = prefab.transform:Find("numberText"):GetComponent("Text")
    self.deleteBtn = prefab.transform:Find("deleteBtn")
    self.countdownText = prefab.transform:Find("countdownText"):GetComponent("Text")

    self:InitializeData()
    ageTab[1]:AddClick(self.deleteBtn.gameObject,function()
        PlayMusEff(1002)
        Event.Brocast("m_ReqMaterialDeleteLine",ageTab[2],self.lineId)
    end)
    Event.AddListener("c_refreshNowConte",self.refreshNowConte,self)
end
--生产线初始化
function HomePageDisplay:InitializeData()
    local materialKey,goodsKey = 21,22  --商品类型
    if math.floor(self.itemId / 100000) == materialKey then
        self.brandbg.localScale = Vector3.New(0,0,0)
        self.brand.localScale = Vector3.New(0,0,0)
        self.quality.localScale = Vector3.New(0,0,0)
        self.itemGoodsbg.localScale = Vector3.New(0,0,0)
        LoadSprite(Material[self.itemId].img,self.icon,false)
    elseif math.floor(self.itemId / 100000) == goodsKey then
        self.brandbg.localScale = Vector3.New(0,0,0)
        self.brand.localScale = Vector3.New(0,0,0)
        self.quality.localScale = Vector3.New(0,0,0)
        self.itemMaterialbg.localScale = Vector3.New(0,0,0)
        LoadSprite(Good[self.itemId].img,self.icon,false)
        ---self.brandValue =
        ---self.qualityValue =
    end
    self.brandName.text = GetLanguage(4301011)
    self.nameText.text = GetLanguage(self.itemId)
    self.accreditIcon.localScale = Vector3.New(0,0,0)
    local number = {}
    number["num1"] = self.lineInfo.nowCount
    number["num2"] = self.lineInfo.targetCount
    number["col1"] = "blue"
    number["col2"] = "black"
    self.numberText.text = getColorString(number)
    self.productionSlider.maxValue = 0
    self.productionSlider.value = 0
    self.countdownText.text = "00:00"
    self.timeText.text = self:GetTime(self.lineInfo.targetCount,self.lineInfo.workerNum)
end
--计算时间
function HomePageDisplay:GetTime(targetCount,workerNum)
    if targetCount == 0 then
        return "00:00:00"
    end
    local materialKey,goodsKey = 21,22  --商品类型
    local time
    if math.floor(self.itemId / 100000) == materialKey then
        time = targetCount / (Material[self.itemId].numOneSec * workerNum)
    elseif math.floor(self.itemId / 100000) == goodsKey then
        time = targetCount / (Good[self.itemId].numOneSec * workerNum)
    end
    local timeTable = getTimeBySec(time)
    local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
    return timeStr
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