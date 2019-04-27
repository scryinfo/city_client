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
    CompanyCtrl.static.companyMgr = CompanyMgr:new()

    local luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")

    luaBehaviour:AddClick(CompanyPanel.backBtn, self.OnBack, self)
    luaBehaviour:AddClick(CompanyPanel.infoBtn.gameObject, self.OnInfo, self)
    luaBehaviour:AddClick(CompanyPanel.landBtn.gameObject, self.OnLand, self)
    luaBehaviour:AddClick(CompanyPanel.buildingBtn.gameObject, self.OnBuilding, self)
    luaBehaviour:AddClick(CompanyPanel.evaBtn.gameObject, self.OnEva, self)
    luaBehaviour:AddClick(CompanyPanel.introductionBtn, self.OnIntroduction, self)
    luaBehaviour:AddClick(CompanyPanel.closeTipsBtn.gameObject, self.OnCloseTips, self)

    -- 土地节点
    self.landSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.landSource.mProvideData = CompanyCtrl.static.landData
    self.landSource.mClearData = CompanyCtrl.static.landClearData

    -- 建筑节点
    self.buildingSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.buildingSource.mProvideData = CompanyCtrl.static.buildingData
    self.buildingSource.mClearData = CompanyCtrl.static.buildingClearData

    -- Eva节点2
    self.evaOptionTwoSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.evaOptionTwoSource.mProvideData = CompanyCtrl.static.evaOptionTwoData
    self.evaOptionTwoSource.mClearData = CompanyCtrl.static.evaOptionTwoClearData

    -- Eva节点3
    self.evaOptionThereSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.evaOptionThereSource.mProvideData = CompanyCtrl.static.evaOptionThereData
    self.evaOptionThereSource.mClearData = CompanyCtrl.static.evaOptionThereClearData

    -- 初始化数据
    self:_initData()
end

-- 注册监听事件
function CompanyCtrl:Active()
    UIPanel.Active(self)
    self:_addListener()

    --CompanyPanel.incomeTitle.text = GetLanguage(17010002)
    --CompanyPanel.expenditureTitle.text = GetLanguage(17010003)
    --CompanyPanel.tips.text = GetLanguage(17010005)
    --CompanyPanel.tipsTextCom.text = GetLanguage(17010006)
end

function CompanyCtrl:Refresh()
    self:_updateData()
    self:initInsData()
    --CityEngineLua.login_tradeapp(true)
end

function CompanyCtrl:Hide()
    --CityEngineLua.login_tradeapp(false)
    self:_removeListener()
    UIPanel.Hide(self)
end

-- 监听Model层网络回调
function CompanyCtrl:_addListener()
    Event.AddListener("c_OnGetGroundInfo", self.c_OnGetGroundInfo, self)
    Event.AddListener("c_OnQueryMyBuildings", self.c_OnQueryMyBuildings, self)
    Event.AddListener("c_OnQueryMyEva", self.c_OnQueryMyEva, self)
    Event.AddListener("c_OnUpdateMyEva", self.c_OnUpdateMyEva, self)
end

-- 注销model层网络回调
function CompanyCtrl:_removeListener()
    Event.RemoveListener("c_OnGetGroundInfo", self.c_OnGetGroundInfo, self)
    Event.RemoveListener("c_OnQueryMyBuildings", self.c_OnQueryMyBuildings, self)
    Event.RemoveListener("c_OnQueryMyEva", self.c_OnQueryMyEva, self)
    Event.RemoveListener("c_OnUpdateMyEva", self.c_OnUpdateMyEva, self)
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

function CompanyCtrl:OnInfo(go)
    PlayMusEff(1002)
    go:_showMainRoot(1)
end

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

function CompanyCtrl:OnBuilding(go)
    PlayMusEff(1002)
    go:_showMainRoot(3)
    -- 建筑选项生成
    CompanyCtrl.static.companyMgr.buildingTypeNum = 0 -- 0 全部 1 原料厂 2 加工厂 3 零售店 4 推广公司 5 学院 6 住宅 7 仓库
    if CompanyCtrl.static.companyMgr:GetBuildingTitleItem() then
        DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_QueryMyBuildings')
        CompanyPanel.buildingTitleRt.anchoredPosition = Vector2.New(0,0)
    else
        CompanyCtrl.static.companyMgr:CreateBuildingTitleItem()
    end
end

function CompanyCtrl:OnEva(go)
    PlayMusEff(1002)
    go:_showMainRoot(4)
    -- Eva选项生成
    go.isClickEva = true
    go:ShowOptionTwo(0)
    go:ShowOptionThere(0)
    CompanyPanel.closeTipsBtn.localScale = Vector3.zero
    CompanyPanel.myEvaText.text = DataManager.GetEvaPoint()
    if CompanyCtrl.static.companyMgr:GetEvaTitleItem() then
        DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_QueryMyEva')
        CompanyPanel.optionOneScroll.localPosition = Vector3.zero --Vector2.New(0,0)
    else
        CompanyCtrl.static.companyMgr:CreateEvaTitleItem(go)
    end
end

--显示eva介绍
function CompanyCtrl:OnIntroduction(go)
    PlayMusEff(1002)
    ct.OpenCtrl("CompanyIntroductionCtrl")
end

--关闭eva小提示
function CompanyCtrl:OnCloseTips(go)
    --PlayMusEff(1002)
    CompanyPanel.closeTipsBtn.localScale = Vector3.zero
    CompanyCtrl.static.companyMgr:ClsoeTips()
end

-- 初始数据
function CompanyCtrl:_initData()
    -- 整合各大分页的切换
    self.mainSwitchTab =
    {
        {btn = CompanyPanel.infoBtn, root = CompanyPanel.infoRoot, transform = CompanyPanel.infoBtn.transform},
        {btn = CompanyPanel.landBtn, root = CompanyPanel.landRoot, transform = CompanyPanel.landBtn.transform},
        {btn = CompanyPanel.buildingBtn, root = CompanyPanel.buildingRoot, transform = CompanyPanel.buildingBtn.transform},
        {btn = CompanyPanel.evaBtn, root = CompanyPanel.evaRoot, transform = CompanyPanel.evaBtn.transform},
    }
end

-- 切换各节点
function CompanyCtrl:_showMainRoot(index)
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
end

--function CompanyCtrl:_sendGroundInfo()
--    DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_GetGroundInfo')
--end

-- 初始化基本数据
function CompanyCtrl:_updateData()
    if self.m_data.id == DataManager.GetMyOwnerID() then
        CompanyPanel.evaBtn.transform.localScale = Vector3.one
        CompanyPanel.titleText.text = GetLanguage(17010001)
        CompanyPanel.coinBg:SetActive(true)
        CompanyPanel.coinText.text = DataManager.GetMoneyByString()
    else
        CompanyPanel.evaBtn.transform.localScale = Vector3.zero
        CompanyPanel.titleText.text = GetLanguage(17010007)
        CompanyPanel.coinBg:SetActive(false)
    end
    if self.avatarData then
        AvatarManger.CollectAvatar(self.avatarData)
    end
    self.avatarData = AvatarManger.GetSmallAvatar(self.m_data.faceId,CompanyPanel.headImage,0.2)
    CompanyPanel.companyNameText.text = self.m_data.companyName
    CompanyPanel.nameText.text = self.m_data.name
    local timeTable = getFormatUnixTime(self.m_data.createTs/1000)
    CompanyPanel.foundingTimeText.text = string.format(GetLanguage(17010004) .."%s", timeTable.year .. "/" .. timeTable.month .. "/" ..timeTable.day)

    --self:_showMainRoot(1)
    self:OnLand(self)
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

-- 网络回调
function CompanyCtrl:c_OnGetGroundInfo(groundInfos)
    if groundInfos.info then
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
    else
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

function CompanyCtrl:c_OnQueryMyBuildings(groundInfos)
    if groundInfos.myBuildingInfo then
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
                --v:SetSelect(false)
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
    else
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

-- 查询Eva
function CompanyCtrl:c_OnQueryMyEva(evas)
    CompanyCtrl.static.companyMgr:SetEvaData(evas)
    CompanyCtrl.static.companyMgr:SetEvaDefaultState()
end

-- 更新Eva
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

function CompanyCtrl:ShowOptionTwo(itemNumber)
    CompanyCtrl.optionTwoScript = {}
    CompanyPanel.optionTwoScroll:ActiveLoopScroll(self.evaOptionTwoSource, itemNumber, "View/Company/EvaBtnTwoItem")
    CompanyPanel.optionTwoScroll:RefillCells()
end

function CompanyCtrl:ShowOptionThere(itemNumber)
    CompanyCtrl.optionThereScript = {}
    CompanyPanel.optionThereScroll:ActiveLoopScroll(self.evaOptionThereSource, itemNumber, "View/Company/EvaBtnThereItem")
    CompanyPanel.optionThereScroll:RefillCells()
end