---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/1/15 15:28
---

CompanyCtrl = class("CompanyCtrl", UIPanel)
UIPanel:ResgisterOpen(CompanyCtrl)

function CompanyCtrl:initialize()
    ct.log("tina_w22_friends", "CompanyCtrl:initialize()")
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function CompanyCtrl:bundleName()
    ct.log("tina_w22_friends", "CompanyCtrl:bundleName()")
    return "Assets/CityGame/Resources/View/CompanyPanel.prefab"
end

function CompanyCtrl:OnCreate(obj)
    ct.log("tina_w22_friends", "CompanyCtrl:OnCreate()")
    UIPanel.OnCreate(self, obj)
end

function CompanyCtrl:Awake()
    ct.log("tina_w22_friends", "CompanyCtrl:Awake()")
    --初始化管理器
    CompanyCtrl.static.companyMgr = CompanyMgr:new(self)

    local luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")

    luaBehaviour:AddClick(CompanyPanel.backBtn, self.OnBack, self)
    luaBehaviour:AddClick(CompanyPanel.infoBtn.gameObject, self.OnInfo, self)
    luaBehaviour:AddClick(CompanyPanel.landBtn.gameObject, self.OnLand, self)
    luaBehaviour:AddClick(CompanyPanel.buildingBtn.gameObject, self.OnBuilding, self)
    --luaBehaviour:AddClick(CompanyPanel.evaBtn.gameObject, self.OnEva, self)
    luaBehaviour:AddClick(CompanyPanel.brandBtn.gameObject, self.OnBrand, self)
    --luaBehaviour:AddClick(CompanyPanel.introductionBtn, self.OnIntroduction, self)
    --luaBehaviour:AddClick(CompanyPanel.closeTipsBtn.gameObject, self.OnCloseTips, self)
    luaBehaviour:AddClick(CompanyPanel.companyRenameBtn.gameObject, self.OnCompanyRename, self)
    luaBehaviour:AddClick(CompanyPanel.sizeBtn.gameObject, self.OnSize, self)
    luaBehaviour:AddClick(CompanyPanel.choiceOBtn.gameObject, self.OnChoiceO, self)
    luaBehaviour:AddClick(CompanyPanel.choiceTBtn.gameObject, self.OnChoiceT, self)

    -- 土地节点
    self.landSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.landSource.mProvideData = CompanyCtrl.static.landData
    self.landSource.mClearData = CompanyCtrl.static.landClearData

    -- 建筑节点
    self.buildingSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.buildingSource.mProvideData = CompanyCtrl.static.buildingData
    self.buildingSource.mClearData = CompanyCtrl.static.buildingClearData

    -- Eva节点2
    --self.evaOptionTwoSource = UnityEngine.UI.LoopScrollDataSource.New()
    --self.evaOptionTwoSource.mProvideData = CompanyCtrl.static.evaOptionTwoData
    --self.evaOptionTwoSource.mClearData = CompanyCtrl.static.evaOptionTwoClearData

    -- Eva节点3
    --self.evaOptionThereSource = UnityEngine.UI.LoopScrollDataSource.New()
    --self.evaOptionThereSource.mProvideData = CompanyCtrl.static.evaOptionThereData
    --self.evaOptionThereSource.mClearData = CompanyCtrl.static.evaOptionThereClearData

    -- 品牌节点
    self.brandSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.brandSource.mProvideData = CompanyCtrl.static.brandData
    self.brandSource.mClearData = CompanyCtrl.static.brandClearData

    -- 初始化数据
    self:_initData()
end

-- 注册监听事件
function CompanyCtrl:Active()
    UIPanel.Active(self)
    --CompanyPanel.curve.anchoredPosition = Vector3.New(-2903, 47,0)
    --CompanyPanel.curve.sizeDelta = Vector2.New(4335, 535)
    self:_addListener()

    -- 多语言适配
    CompanyPanel.infoBtnText.text = GetLanguage(18010002)
    CompanyPanel.incomeTitleText.text = GetLanguage(18010003)
    CompanyPanel.expenditureTitleText.text = GetLanguage(18010004)
    CompanyPanel.landBtnText.text = GetLanguage(18020001)
    CompanyPanel.buildingBtnText.text = GetLanguage(18030001)
    CompanyPanel.brandBtnText.text = GetLanguage(18030001)
end

function CompanyCtrl:Refresh()
    self:initInsData()
    self:_updateData()
    --CityEngineLua.login_tradeapp(true)
end

function CompanyCtrl:Hide()
    --CityEngineLua.login_tradeapp(false)
    self:_removeListener()
    UIPanel.Hide(self)
    --CompanyPanel.curve.anchoredPosition = Vector3.New(-2903, 47,0)
    --CompanyPanel.curve.sizeDelta = Vector2.New(4335, 535)
end

-- 监听Model层网络回调
function CompanyCtrl:_addListener()
    Event.AddListener("c_OnGetGroundInfo", self.c_OnGetGroundInfo, self)
    Event.AddListener("c_OnQueryMyBuildings", self.c_OnQueryMyBuildings, self)
    --Event.AddListener("c_OnQueryMyEva", self.c_OnQueryMyEva, self)
    Event.AddListener("c_OnUpdateMyEva", self.c_OnUpdateMyEva, self)
    Event.AddListener("c_OnQueryPlayerIncomePayCurve", self.c_OnQueryPlayerIncomePayCurve, self)
    Event.AddListener("c_OnModifyCompanyName", self.c_OnModifyCompanyName, self)
    Event.AddListener("c_OnMQueryMyBrands", self.c_OnMQueryMyBrands, self)
    Event.AddListener("c_OnModyfyMyBrandName", self.c_OnModyfyMyBrandName, self)
end

-- 注销model层网络回调
function CompanyCtrl:_removeListener()
    Event.RemoveListener("c_OnGetGroundInfo", self.c_OnGetGroundInfo, self)
    Event.RemoveListener("c_OnQueryMyBuildings", self.c_OnQueryMyBuildings, self)
    --Event.RemoveListener("c_OnQueryMyEva", self.c_OnQueryMyEva, self)
    Event.RemoveListener("c_OnUpdateMyEva", self.c_OnUpdateMyEva, self)
    Event.RemoveListener("c_OnQueryPlayerIncomePayCurve", self.c_OnQueryPlayerIncomePayCurve, self)
    Event.RemoveListener("c_OnModifyCompanyName", self.c_OnModifyCompanyName, self)
    Event.RemoveListener("c_OnMQueryMyBrands", self.c_OnMQueryMyBrands, self)
    Event.RemoveListener("c_OnModyfyMyBrandName", self.c_OnModyfyMyBrandName, self)
end

-- 打开model
function CompanyCtrl:initInsData()
    DataManager.OpenDetailModel(CompanyModel, OpenModelInsID.CompanyCtrl)
end

-- 各按钮
function CompanyCtrl:OnBack(go)
    PlayMusEff(1002)
    UIPanel.ClosePage()
end

-- 收支曲线图
function CompanyCtrl:c_PromoteSignCurve(info,todayIncome,todayPay)
    CompanyPanel.curveFunctionalGraph:Close()
    CompanyPanel.curveSlide:Close()
    local currentTimes = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local currentTime = currentTimes
    local ts = getFormatUnixTime(currentTime)
    local second = tonumber(ts.second)
    local minute = tonumber(ts.minute)
    local hour = tonumber(ts.hour)
    if second ~= 0 then
        currentTime = currentTime -second
    end
    if minute ~= 0 then
        currentTime = currentTime - minute * 60
    end
    if hour ~= 0 then
        currentTime = currentTime - hour * 3600
    end
    local taday = currentTimes - currentTime
    currentTime = math.floor(currentTime)               --当前小时数-整数
    local monthAgo = currentTime - 2592000 + 86400     --30天前
    local updataTime = monthAgo
    local time = {}
    local boundaryLine = {}
    local incomeTab = {}
    local payTab = {}

    local buildingTs = math.floor(self.m_data.createTs/1000)
    if tonumber(getFormatUnixTime(buildingTs).second) ~= 0 then
        buildingTs = buildingTs - tonumber(getFormatUnixTime(buildingTs).second)
    end
    if tonumber(getFormatUnixTime(buildingTs).minute) ~= 0 then
        buildingTs = buildingTs - tonumber(getFormatUnixTime(buildingTs).minute) * 60
    end
    if tonumber(getFormatUnixTime(buildingTs).hour) ~= 0 then
        buildingTs = buildingTs - tonumber(getFormatUnixTime(buildingTs).hour) * 3600
    end
    local buildingTime = buildingTs
    if buildingTs >= monthAgo then
        updataTime = buildingTs
        for i = 1, 30 do
            if tonumber(getFormatUnixTime(updataTime).day) == 1 then
                table.insert(boundaryLine,(updataTime - buildingTs + 86400) / 86400 * 140)
            end
            time[i] = getFormatUnixTime(updataTime).month .. "/" .. getFormatUnixTime(updataTime).day
            if updataTime <= currentTime then
                incomeTab[i] = {}
                incomeTab[i].coordinate = (updataTime - buildingTs + 86400) / 86400 * 140
                incomeTab[i].flow = 0  --看具体字段
                payTab[i] = {}
                payTab[i].coordinate = (updataTime - buildingTs + 86400) / 86400 * 140
                payTab[i].flow = 0  --看具体字段
                if info ~= nil then
                    for k, v in pairs(info) do
                        if updataTime == v.time / 1000 then
                            incomeTab[i].lift = tonumber(GetClientPriceString(v.income))
                            payTab[i].lift = tonumber(GetClientPriceString(v.pay))
                        end
                    end
                end
                if updataTime == currentTime then
                    incomeTab[i].lift = tonumber(GetClientPriceString(todayIncome))
                    payTab[i].lift = tonumber(GetClientPriceString(todayPay))
                end
            end
            updataTime = updataTime + 86400
        end
    else
        for i = 1, 30 do
            if tonumber(getFormatUnixTime(updataTime).day) == 1 then
                time[i] = getFormatUnixTime(updataTime).month .. "/" .. getFormatUnixTime(updataTime).day
                table.insert(boundaryLine,(updataTime - monthAgo + 86400) / 86400 * 140)
            else
                time[i] = tostring(getFormatUnixTime(updataTime).day) .. "d"
            end
            incomeTab[i] = {}
            incomeTab[i].coordinate = (updataTime - monthAgo + 86400) / 86400 * 140
            incomeTab[i].flow = 0  --看具体字段
            payTab[i] = {}
            payTab[i].coordinate = (updataTime - monthAgo + 86400) / 86400 * 140
            payTab[i].flow = 0  --看具体字段
            if info ~= nil then
                for k, v in pairs(info) do
                    if updataTime == v.time / 1000 then
                        incomeTab[i].lift = tonumber(GetClientPriceString(v.income))
                        payTab[i].lift = tonumber(GetClientPriceString(v.pay))
                    end
                end
            end
            incomeTab[#incomeTab].y= tonumber(GetClientPriceString(todayIncome))
            payTab[#payTab].y= tonumber(GetClientPriceString(todayPay))
            updataTime = updataTime + 86400
        end
    end

    local income = {}
    for i, v in ipairs(incomeTab) do
        income[i] = Vector2.New(v.coordinate,v.lift)  --
    end
    local pay = {}
    for i, v in ipairs(payTab) do
        pay[i] = Vector2.New(v.coordinate,v.lift)  --
    end
    table.insert(time,1,"0")
    table.insert(boundaryLine,1,0)
    table.insert(income,1,Vector2.New(0,0))
    table.insert(pay,1,Vector2.New(0,0))
    local max = 0
    for i, v in ipairs(income) do
        if v.y > max then
            max = v.y
        end
    end
    for i, v in ipairs(pay) do
        if v.y > max then
            max = v.y
        end
    end
    local scale = SetYScale(max,5,CompanyPanel.yScaleRT)
    local incomeVet = {}
    local payVet = {}
    for i, v in ipairs(income) do
        if scale == 0 then
            incomeVet[i] = Vector2.New(v.x, v.y)
        else
            incomeVet[i] = Vector2.New(v.x,v.y / scale * 105)
        end
    end
    for i, v in ipairs(pay) do
        if scale == 0 then
            payVet[i] = Vector2.New(v.x, v.y)
        else
            payVet[i] = Vector2.New(v.x,v.y / scale * 105)
        end
    end

    --if buildingTs >= monthAgo then
    --    if buildingTime == currentTime then
    --        incomeVet[2].x = incomeVet[2].x + (taday * (140 / 86400))
    --        payVet[2].x = payVet[2].x + (taday * (140 / 86400))
    --        table.insert(incomeVet,2,Vector2.New(140,0))
    --        table.insert(payVet,2,Vector2.New(140,0))
    --        table.insert(income,2,Vector2.New(140,0))
    --        table.insert(pay,2,Vector2.New(140,0))
    --    else
    --      local dis = (currentTime - buildingTime)/86400 *40
    --        local id
    --        for i, v in ipairs(incomeVet) do
    --            if v.x == dis then
    --                id = i
    --            end
    --        end
    --        --if id then
    --        --    incomeVet[id].x = incomeVet[id].x + (taday * (140 / 86400))
    --        --    payVet[id].x = payVet[id].x + (taday * (140 / 86400))
    --        --end
    --    end
    --else
    --    --incomeVet[#incomeVet].x = incomeVet[#incomeVet].x + (taday * (140 / 86400))
    --    --payVet[#payVet].x = payVet[#payVet].x + (taday * (140 / 86400))
    --end
    --if buildingTime == currentTime then
    --    local incomeVetTemp = {}
    --    local payVetTemp = {}
    --    incomeVetTemp.x = incomeVet[#incomeVet].x + (taday * (140 / 86400))
    --    incomeVetTemp.y = incomeVet[#incomeVet].y
    --    payVetTemp.x = payVet[#payVet].x + (taday * (140 / 86400))
    --    payVetTemp.y = payVet[#payVet].y
    --    table.insert(incomeVet,Vector2.New(incomeVetTemp.x,incomeVetTemp.y))
    --    table.insert(payVet,Vector2.New(payVetTemp.x,payVetTemp.y))
    --    incomeVet[#incomeVet-1].y = 0
    --    payVet[#payVet-1].y = 0
    --    table.insert(income,#incomeVet-1,Vector2.New(incomeVet[#incomeVet-1].x,0))
    --    table.insert(pay,#payVet-1,Vector2.New(payVet[#payVet-1].x,0))
    --else
    --    incomeVet[#incomeVet].x = incomeVet[#incomeVet].x + (taday * (140 / 86400))
    --    payVet[#payVet].x = payVet[#payVet].x + (taday * (140 / 86400))
    --end

    local difference = (currentTime - buildingTs) / 86400  --距离开业的天数
    if difference < 10 then
        CompanyPanel.curve.anchoredPosition = Vector3.New(-40, 47,0)
        CompanyPanel.curve.sizeDelta = Vector2.New(1528, 535)
    elseif difference < 30 then
        CompanyPanel.curve.anchoredPosition = Vector3.New(-40, 47,0)
        CompanyPanel.curve.sizeDelta = Vector2.New(1528, 535)
        CompanyPanel.curve.anchoredPosition = Vector3.New(CompanyPanel.curve.anchoredPosition.x - (difference - 10) * 140, 47,0)
        CompanyPanel.curve.sizeDelta = Vector2.New(CompanyPanel.curve.sizeDelta.x + (difference - 10) * 140, 533)
    else
        CompanyPanel.curve.anchoredPosition = Vector3.New(-2902, 47,0)
        CompanyPanel.curve.sizeDelta = Vector2.New(4335, 535)
    end

    CompanyPanel.curveSlide:SetXScaleValue(time,140)
    CompanyPanel.curveFunctionalGraph:BoundaryLine(boundaryLine)

    CompanyPanel.curveFunctionalGraph:DrawLine(incomeVet, getColorByInt(8, 139, 108),1) --收入
    CompanyPanel.curveSlide:SetCoordinate(incomeVet, income, getColorByInt(41, 61, 108),1)

    CompanyPanel.curveFunctionalGraph:DrawLine(payVet, getColorByInt(213, 34, 76),2) --支出
    CompanyPanel.curveSlide:SetCoordinate(payVet, pay, getColorByInt(41, 61, 108),2)

    --CompanyPanel.curve.localPosition = CompanyPanel.curve.localPosition + Vector3.New(0.01, 0,0)
    --CompanyPanel.curve.sizeDelta = CompanyPanel.curve.sizeDelta + Vector2.New(0.01, 0)
end


-- 显示基本信息
function CompanyCtrl:OnInfo(go)
    PlayMusEff(1002)

    go:_showMainRoot(1)
    --go:c_PromoteSignCurve({})
    DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_QueryPlayerIncomePayCurve')
end

-- 显示土地信息
function CompanyCtrl:OnLand(go)
    PlayMusEff(1002)
    go:_showMainRoot(2)
    -- 土地选项生成
    CompanyCtrl.static.companyMgr.landTypeNum = 0 -- 0 全部 1 租用中 2 已出租 3 出租中 4 出售中 5 可使用
    if CompanyCtrl.static.companyMgr:GetLandTitleItem() then
        DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_GetGroundInfo')
    else
        CompanyCtrl.static.companyMgr:CreateLandTitleItem()
    end
end

-- 显示建筑信息
function CompanyCtrl:OnBuilding(go)
    PlayMusEff(1002)
    go:_showMainRoot(3)
    -- 建筑选项生成
    CompanyCtrl.static.companyMgr.buildingTypeNum = 0 -- 0 全部 1 原料厂 2 加工厂 3 零售店 4 推广公司 5 研究所 6 住宅 7 仓库
    if CompanyCtrl.static.companyMgr:GetBuildingTitleItem() then
        DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_QueryMyBuildings')
        CompanyPanel.buildingTitleRt.anchoredPosition = Vector2.New(0,0)
    else
        CompanyCtrl.static.companyMgr:CreateBuildingTitleItem()
    end
end

-- 打开品牌
function CompanyCtrl:OnBrand(go)
    PlayMusEff(1002)
    go:_showMainRoot(5)
    -- 品牌选项生成
    CompanyCtrl.static.companyMgr:SetBrandSizeNum(1)
    --CompanyCtrl.static.companyMgr.brandTypeNum = 0
    if CompanyCtrl.static.companyMgr:GetBrandTitleItem() then
        DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_QueryMyBrands')
    else
        CompanyCtrl.static.companyMgr:CreateBrandTitleItem()
    end
end

-- 给公司改名
function CompanyCtrl:OnCompanyRename(go)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(18010006)
    data.tipInfo = GetLanguage(18010012)
    data.characterLimit = 8
    data.btnCallBack = function(text)
        if text == nil or text == "" then
            Event.Brocast("SmallPop", GetLanguage(18010010),80)
            return
        end
        DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_ModifyCompanyName', { pid = DataManager.GetMyOwnerID(), newName = text })
    end
    ct.OpenCtrl("CompanyInputCtrl", data)
end

-- 品牌主菜单
function CompanyCtrl:OnSize(go)
    CompanyPanel.sizeBg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic)
    CompanyPanel.sizeBtnImage:DORotate(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic)
end

-- 品牌菜单1
function CompanyCtrl:OnChoiceO(go)
    PlayMusEff(1002)
    if CompanyCtrl.static.companyMgr.brandSizeNum == 1 then
        CompanyCtrl.static.companyMgr:SetBrandSizeNum(2)
    elseif CompanyCtrl.static.companyMgr.brandSizeNum == 2 then
        CompanyCtrl.static.companyMgr:SetBrandSizeNum(1)
    elseif CompanyCtrl.static.companyMgr.brandSizeNum == 3 then
        CompanyCtrl.static.companyMgr:SetBrandSizeNum(1)
    end
    for _, v in ipairs(CompanyCtrl.brandScript) do
        v:ShowContent()
    end
end

-- 品牌菜单2
function CompanyCtrl:OnChoiceT(go)
    PlayMusEff(1002)
    if CompanyCtrl.static.companyMgr.brandSizeNum == 1 then
        CompanyCtrl.static.companyMgr:SetBrandSizeNum(3)
    elseif CompanyCtrl.static.companyMgr.brandSizeNum == 2 then
        CompanyCtrl.static.companyMgr:SetBrandSizeNum(3)
    elseif CompanyCtrl.static.companyMgr.brandSizeNum == 3 then
        CompanyCtrl.static.companyMgr:SetBrandSizeNum(2)
    end
    for _, v in ipairs(CompanyCtrl.brandScript) do
        v:ShowContent()
    end
end

-- 初始数据
function CompanyCtrl:_initData()
    -- 整合各大分页的切换(每添加一个，则需要把相应的节点传进来，即可实现不同节点的交替)
    self.mainSwitchTab =
    {
        {btn = CompanyPanel.infoBtn, root = CompanyPanel.infoRoot, transform = CompanyPanel.infoBtn.transform},
        {btn = CompanyPanel.landBtn, root = CompanyPanel.landRoot, transform = CompanyPanel.landBtn.transform},
        {btn = CompanyPanel.buildingBtn, root = CompanyPanel.buildingRoot, transform = CompanyPanel.buildingBtn.transform},
        --{btn = CompanyPanel.evaBtn, root = CompanyPanel.evaRoot, transform = CompanyPanel.evaBtn.transform},
        {btn = CompanyPanel.brandBtn, root = CompanyPanel.brandRoot, transform = CompanyPanel.brandBtn.transform},
    }
end

-- 切换各节点
function CompanyCtrl:_showMainRoot(index)
    CompanyPanel.noContentRoot.localScale = Vector3.zero
    for i, v in ipairs(self.mainSwitchTab) do
        if i == index then
            v.btn.interactable = false
            v.root.localScale = Vector3.one
            v.transform:Find("OpenImage").localScale = Vector3.one
            v.transform:Find("CloseImage").localScale = Vector3.zero
            v.transform:Find("Text"):GetComponent("Text").color = getColorByVector3(Vector3.New(255, 255, 255))
        else
            v.btn.interactable = true
            v.root.localScale = Vector3.zero
            v.transform:Find("OpenImage").localScale = Vector3.zero
            v.transform:Find("CloseImage").localScale = Vector3.one
            v.transform:Find("Text"):GetComponent("Text").color = getColorByVector3(Vector3.New(205, 219, 255))
        end
    end

    -- 控制Eva标题的显示，解决设置content位置不成功的bug
    --if index == 4 then
    --    CompanyPanel.optionOneObj:SetActive(true)
    --else
    --    CompanyPanel.optionOneObj:SetActive(false)
    --end
end

-- 初始化基本数据
function CompanyCtrl:_updateData()
    if self.m_data.id == DataManager.GetMyOwnerID() then
        --CompanyPanel.evaBtn.transform.localScale = Vector3.one
        CompanyPanel.companyRenameBtn.localScale = Vector3.one
        CompanyPanel.titleText.text = GetLanguage(18010001)
        --CompanyPanel.coinBg:SetActive(true)
        --CompanyPanel.coinText.text = DataManager.GetMoneyByString()
        CompanyCtrl.static.companyMgr:SetIsOwn(true)
    else
        --CompanyPanel.evaBtn.transform.localScale = Vector3.zero
        CompanyPanel.companyRenameBtn.localScale = Vector3.zero
        CompanyPanel.titleText.text = GetLanguage(18010009)
        --CompanyPanel.coinBg:SetActive(false)
        CompanyCtrl.static.companyMgr:SetIsOwn(false)
    end
    if self.avatarData then
        AvatarManger.CollectAvatar(self.avatarData)
    end
    self.avatarData = AvatarManger.GetSmallAvatar(self.m_data.faceId,CompanyPanel.headImage,0.2)
    CompanyPanel.companyNameText.text = self.m_data.companyName
    CompanyPanel.nameText.text = self.m_data.name
    CompanyCtrl.static.companyMgr:SetCompanyName(self.m_data.companyName)
    CompanyCtrl.static.companyMgr:SetId(self.m_data.id)
    local sexPath = self.m_data.male and "Assets/CityGame/Resources/Atlas/Company/male.png" or "Assets/CityGame/Resources/Atlas/Company/famale.png"
    LoadSprite(sexPath, CompanyPanel.sexImage, true)
    local timeTable = getFormatUnixTime(self.m_data.createTs/1000)
    CompanyPanel.foundingTimeText.text = string.format(GetLanguage(18010005) .."%s", timeTable.year .. "/" .. timeTable.month .. "/" ..timeTable.day)

    self:OnInfo(self)
end

-- 滑动复用
-- 土地信息显示
CompanyCtrl.static.landData = function(transform, idx)
    idx = idx + 1
    local item = LandInfoItem:new(transform, CompanyCtrl.landInfos[idx])
end

CompanyCtrl.static.landClearData = function(transform)
end

-- 建筑信息显示
CompanyCtrl.static.buildingData = function(transform, idx)
    idx = idx + 1
    local item = BuildingInfoItem:new(transform, CompanyCtrl.buildingInfos[idx])
end

CompanyCtrl.static.buildingClearData = function(transform)
end

-- Eva选项2信息显示
CompanyCtrl.static.evaOptionTwoData = function(transform, idx)
    idx = idx + 1
    CompanyCtrl.optionTwoScript[idx] = OptionItem:new(transform, 2, idx)
end

CompanyCtrl.static.evaOptionTwoClearData = function(transform)
end

-- Eva选项3信息显示
CompanyCtrl.static.evaOptionThereData = function(transform, idx)
    idx = idx + 1
    CompanyCtrl.optionThereScript[idx] = OptionItem:new(transform, 3, idx)
end

CompanyCtrl.static.evaOptionThereClearData = function(transform)
end

-- 品牌信息显示
CompanyCtrl.static.brandData = function(transform, idx)
    idx = idx + 1
    CompanyCtrl.brandScript[idx] = BrandItem:new(transform, CompanyCtrl.static.companyMgr.partBrandData[idx])
end

CompanyCtrl.static.brandClearData = function(transform)
end

-- 网络回调
-- 服务器土地信息回调，创建新表，把各项信息分别放进去，用于显示各项土地个数，滑动则只显示选择的那一项
function CompanyCtrl:c_OnGetGroundInfo(groundInfos)
    if groundInfos.info then
        CompanyPanel.noContentRoot.localScale = Vector3.zero
        CompanyCtrl.landTypeInfo = {{}, {}, {}, {}, {}}
        for _, v in ipairs(groundInfos.info) do
            if v.ownerId == DataManager.GetMyOwnerID() then
                if v.rent and v.rent.renterId then -- 已出租
                    table.insert(CompanyCtrl.landTypeInfo[2], v)
                elseif v.rent and not v.rent.renterId then -- 出租中
                    table.insert(CompanyCtrl.landTypeInfo[3], v)
                elseif v.sell then -- 出售中
                    table.insert(CompanyCtrl.landTypeInfo[4], v)
                else -- 可使用
                    table.insert(CompanyCtrl.landTypeInfo[5], v)
                end
            else
                if v.rent and v.rent.renterId then -- 租用中
                    table.insert(CompanyCtrl.landTypeInfo[1], v)
                end
            end
        end

        local landTitleItemMgrTab = CompanyCtrl.static.companyMgr:GetLandTitleItem()
        landTitleItemMgrTab[1]:SetNumber(#groundInfos.info)
        if CompanyCtrl.static.companyMgr.landTypeNum == 0 then
            CompanyCtrl.landInfos = groundInfos.info
            landTitleItemMgrTab[1]:SetSelect(false)
            for i, v in ipairs(CompanyCtrl.landTypeInfo) do
                landTitleItemMgrTab[i + 1]:SetNumber(#v)
                landTitleItemMgrTab[i + 1]:SetSelect(true)
            end
        else
            CompanyCtrl.landInfos = CompanyCtrl.landTypeInfo[CompanyCtrl.static.companyMgr.landTypeNum]
            landTitleItemMgrTab[1]:SetSelect(true)
            for i, v in ipairs(CompanyCtrl.landTypeInfo) do
                landTitleItemMgrTab[i + 1]:SetNumber(#v)
                if i ~= CompanyCtrl.static.companyMgr.landTypeNum then
                    landTitleItemMgrTab[i + 1]:SetSelect(true)
                end
            end
        end
        CompanyPanel.landScroll:ActiveLoopScroll(self.landSource, #CompanyCtrl.landInfos, "View/Company/LandInfoItem")
        CompanyPanel.landScroll:RefillCells()

        if #CompanyCtrl.landInfos == 0 then
            CompanyPanel.noContentRoot.localScale = Vector3.one
            CompanyPanel.tipsText.text = GetLanguage(18020011)
        end
    else
        -- 当没有土地需要显示时，各项数据皆为零
        CompanyPanel.noContentRoot.localScale = Vector3.one
        CompanyPanel.tipsText.text = GetLanguage(18020011)
        CompanyPanel.landScroll:ActiveLoopScroll(self.landSource, 0, "View/Company/LandInfoItem")
        local landTitleItemMgrTab = CompanyCtrl.static.companyMgr:GetLandTitleItem()
        for i, v in ipairs(landTitleItemMgrTab) do
            v:SetNumber()
            if i - 1 ~= CompanyCtrl.static.companyMgr.landTypeNum then
                v:SetSelect(true)
            end
        end
    end
end

-- 服务器建筑信息显示回调，不需要自己分类，服务器已经分好了，根据他的type判断就好啦
function CompanyCtrl:c_OnQueryMyBuildings(groundInfos)
    if groundInfos.myBuildingInfo then
        CompanyPanel.noContentRoot.localScale = Vector3.zero
        CompanyCtrl.buildingInfos = {}
        local buildingTitleItemMgrTab = CompanyCtrl.static.companyMgr:GetBuildingTitleItem()
        if CompanyCtrl.static.companyMgr.buildingTypeNum == 0 then
            for _, a in ipairs(groundInfos.myBuildingInfo) do
                for _, b in ipairs(a.info) do
                    table.insert(CompanyCtrl.buildingInfos, b)
                end
            end
            for i, v in ipairs(buildingTitleItemMgrTab) do
                for _, j in ipairs(groundInfos.myBuildingInfo) do
                    if j.type - 10 == i - 1 then
                        v:SetNumber(#j.info)
                        v:SetSelect(true)
                        break
                    end
                end
            end
            buildingTitleItemMgrTab[1]:SetSelect(false)
            buildingTitleItemMgrTab[1]:SetNumber(#CompanyCtrl.buildingInfos)
        else
            local totalNum = 0
            for _, a in ipairs(groundInfos.myBuildingInfo) do
                for _, b in ipairs(a.info) do
                    totalNum = totalNum + 1
                end
            end
            buildingTitleItemMgrTab[1]:SetNumber(totalNum)
            for i, v in ipairs(buildingTitleItemMgrTab) do
                for _, j in ipairs(groundInfos.myBuildingInfo) do
                    if j.type - 10 == i - 1 then
                        v:SetNumber(#j.info)
                        break
                    end
                end
                if i - 1 == CompanyCtrl.static.companyMgr.buildingTypeNum then
                    for _, k in ipairs(groundInfos.myBuildingInfo) do
                        if k.type - 10 == i - 1 then
                            CompanyCtrl.buildingInfos = k.info
                            break
                        end
                    end
                else
                    buildingTitleItemMgrTab[i]:SetSelect(true)
                end
            end
        end
        CompanyPanel.buildingScroll:ActiveLoopScroll(self.buildingSource, #CompanyCtrl.buildingInfos, "View/Company/BuildingInfoItem")
        CompanyPanel.buildingScroll:RefillCells()
        if #CompanyCtrl.buildingInfos == 0 then
            CompanyPanel.noContentRoot.localScale = Vector3.one
            CompanyPanel.tipsText.text = GetLanguage(18030002)
        end
    else
        CompanyPanel.noContentRoot.localScale = Vector3.one
        CompanyPanel.tipsText.text = GetLanguage(18030002)

        -- 当没有建筑需要显示时，各项数据皆为零
        CompanyPanel.buildingScroll:ActiveLoopScroll(self.buildingSource, 0, "View/Company/BuildingInfoItem")
        local buildingTitleItemMgrTab = CompanyCtrl.static.companyMgr:GetBuildingTitleItem()
        for i, v in ipairs(buildingTitleItemMgrTab) do
            v:SetNumber()
            if i - 1 ~= CompanyCtrl.static.companyMgr.buildingTypeNum then
                v:SetSelect(true)
            end
        end
    end
end

-- 服务器查询Eva，并把Eva信息保存下來，并默认显示第一项
--function CompanyCtrl:c_OnQueryMyEva(evas)
--    CompanyCtrl.static.companyMgr:SetEvaData(evas)
--    CompanyCtrl.static.companyMgr:SetEvaDefaultState()
--end

-- 加点后，更新Eva信息
function CompanyCtrl:c_OnUpdateMyEva(eva)
    local data = {}
    data.id = eva.id
    data.at = eva.at
    data.b = eva.b
    data.cexp = eva.cexp
    data.lv = eva.lv
    data.pid = eva.pid
    data.bt = eva.bt
    local evaPoint = DataManager.GetEvaPoint()
    evaPoint = evaPoint - eva.decEva
    CompanyPanel.myEvaText.text = tostring(evaPoint)
    DataManager.SetEvaPoint(evaPoint)
    CompanyCtrl.static.companyMgr:UpdateMyEva(data)
    CompanyCtrl.static.companyMgr:UpdateMyEvaProperty(data)
end

-- 收支返回
function CompanyCtrl:c_OnQueryPlayerIncomePayCurve(curveInfo)
    local pay = 0
    local income = 0

    -- 获得往期的收支
    if curveInfo.playerIncome then
        for _, v in pairs(curveInfo.playerIncome) do
            if v.income then
                income = income + v.income
            end
            if v.pay then
                pay = pay + v.pay
            end
        end
    end

    -- 营收
    if curveInfo.todayIncome then
        income = income + curveInfo.todayIncome
    end

    -- 支出
    if curveInfo.todayPay then
        pay = pay + curveInfo.todayPay
    end

    -- 设置UI上的值
    if income > 0 then
        CompanyPanel.incomeText.text = GetClientPriceString(income)
    else
        CompanyPanel.incomeText.text = "0"
    end
    if pay > 0 then
        CompanyPanel.expenditureText.text = GetClientPriceString(pay)
    else
        CompanyPanel.expenditureText.text = "0"
    end

    -- 生成曲线图
    self:c_PromoteSignCurve(curveInfo.playerIncome,curveInfo.todayIncome,curveInfo.todayPay)
end

-- 公司改名
function CompanyCtrl:c_OnModifyCompanyName(roleInfo)
    CompanyPanel.companyNameText.text = roleInfo.companyName
    Event.Brocast("SmallPop",GetLanguage(18010008),80)
    DataManager.SetMyPersonalHomepageInfo(1,{roleInfo})
end

-- 品牌返回
function CompanyCtrl:c_OnMQueryMyBrands(MyAllBrands)

    CompanyCtrl.static.companyMgr:SetBrandData(MyAllBrands)
    CompanyCtrl.static.companyMgr:SetBrandDefaultState()
end

-- 品牌改名返回
function CompanyCtrl:c_OnModyfyMyBrandName(modyfyMyBrandName)
    -- 刷新界面
    for _, v in ipairs(CompanyCtrl.brandScript) do
        v:ChangeName(modyfyMyBrandName)
    end

    -- 刷新数据
    CompanyCtrl.static.companyMgr:SetBrandName(modyfyMyBrandName)
    Event.Brocast("SmallPop",GetLanguage(18040007),80)
end

-- 刷新Eva滑动选项2的信息
--function CompanyCtrl:ShowOptionTwo(itemNumber)
--    CompanyCtrl.optionTwoScript = {}
--    CompanyPanel.optionTwoScroll:ActiveLoopScroll(self.evaOptionTwoSource, itemNumber, "View/Company/EvaBtnTwoItem")
--    CompanyPanel.optionTwoScroll:RefillCells()
--end

-- 刷新Eva滑动选项3的信息
--function CompanyCtrl:ShowOptionThere(itemNumber)
--    CompanyCtrl.optionThereScript = {}
--    CompanyPanel.optionThereScroll:ActiveLoopScroll(self.evaOptionThereSource, itemNumber, "View/Company/EvaBtnThereItem")
--    CompanyPanel.optionThereScroll:RefillCells()
--end

-- 刷新品牌的信息
function CompanyCtrl:ShowBrand(itemNumber)
    CompanyCtrl.brandScript = {}
    CompanyPanel.brandScroll:ActiveLoopScroll(self.brandSource, itemNumber, "View/Company/BrandItem")
    CompanyPanel.brandScroll:RefillCells()
end