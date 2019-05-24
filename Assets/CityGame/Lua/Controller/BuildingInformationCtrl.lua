---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/5/14 10:58
---建筑信息详情

BuildingInformationCtrl = class('BuildingInformationCtrl',UIPanel)
UIPanel:ResgisterOpen(BuildingInformationCtrl)

local isShow = false
local businessState = false
--建筑信息Item路径
BuildingInformationCtrl.MaterialFactoryItem_Path = "Assets/CityGame/Resources/View/NewItems/materialFactoryItem.prefab"         --原料厂
BuildingInformationCtrl.ProcessingFactoryItem_Path = "Assets/CityGame/Resources/View/NewItems/processingFactoryItem.prefab"     --加工厂
BuildingInformationCtrl.RetailStoreItem_Path = "Assets/CityGame/Resources/View/NewItems/retailStoreItem.prefab"                 --零售店
function BuildingInformationCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function BuildingInformationCtrl:bundleName()
    return "Assets/CityGame/Resources/View/BuildingInformationPanel.prefab"
end

function BuildingInformationCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function BuildingInformationCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn.gameObject,self._clickCloseBtn,self)
    self.luaBehaviour:AddClick(self.buildingNomal.gameObject,self._clickBuildingNomal,self)
    self.luaBehaviour:AddClick(self.landNomal.gameObject,self._clickLandNomal,self)
    self.luaBehaviour:AddClick(self.switchBtn.gameObject,self._clickSwitchBtn,self)
    self.luaBehaviour:AddClick(self.buildingName.gameObject,self._clickBuildingName,self)
    --给每块地的button绑定点击事件
    for key,value in pairs(self.mineLandBtnTable) do
        self.luaBehaviour:AddClick(value.gameObject,self._clickGroundBtn,self)
    end
    for key,value in pairs(self.otherLandBtnTable) do
        self.luaBehaviour:AddClick(value.gameObject,self._clickGroundBtn,self)
    end
end
function BuildingInformationCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("openTipBox",self.openTipBox,self)
end
function BuildingInformationCtrl:Refresh()
    self:language()
    --获取,初始化UI建筑信息
    self:getBuildingInfo()
    self:initializeUiBuildingInfo()
    --获取,初始化土地信息
    self:getLandInfo()
end

function BuildingInformationCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("openTipBox",self.openTipBox,self)
    destroy(self.buildingInfoItem.prefab.gameObject)
    self.buildingInfoItem = nil
    if isShow == true then
        self.tipBox.transform:SetParent(self.content)
        self.tipBoxText.text = ""
        self.tipBox.transform.localScale = Vector3.zero
    end
end
-------------------------------------------------------------获取组件---------------------------------------------------------------------------------
function BuildingInformationCtrl:_getComponent(go)
    ---TopRoot
    self.closeBtn = go.transform:Find("topRoot/top/closeBtn")
    self.topName = go.transform:Find("topRoot/top/topName"):GetComponent("Text")
    --buildingInfoBtn
    self.buildingNomal = go.transform:Find("topRoot/button/buildingInfoBtn/nomal")      --建筑信息按钮未选择
    self.buildingNomalText = go.transform:Find("topRoot/button/buildingInfoBtn/nomal/nomalText"):GetComponent("Text")
    self.buildingChoose = go.transform:Find("topRoot/button/buildingInfoBtn/choose")    --建筑信息按钮已选择
    self.buildingChooseText = go.transform:Find("topRoot/button/buildingInfoBtn/choose/chooseText"):GetComponent("Text")
    --landInfomationBtn
    self.landNomal = go.transform:Find("topRoot/button/landInfomationBtn/nomal")        --土地信息按钮未选择
    self.landNomalText = go.transform:Find("topRoot/button/landInfomationBtn/nomal/nomalText"):GetComponent("Text")
    self.landChoose = go.transform:Find("topRoot/button/landInfomationBtn/choose")      --土地信息按钮已选择
    self.landChooseText = go.transform:Find("topRoot/button/landInfomationBtn/choose/chooseText"):GetComponent("Text")
    ---content
    --buildingInfoRoot
    self.buildingInfoRoot = go.transform:Find("content/buildingInfoRoot")               --建筑信息
    self.content = go.transform:Find("content/buildingInfoRoot/content")
    self.buildingName = go.transform:Find("content/buildingInfoRoot/content/buildingName"):GetComponent("Text")
    self.modifyImg = go.transform:Find("content/buildingInfoRoot/content/modifyImg")
    self.buildingTypeText = go.transform:Find("content/buildingInfoRoot/content/buildingTypeText"):GetComponent("Text")
    self.tipText = go.transform:Find("content/buildingInfoRoot/content/tipBg/tipText"):GetComponent("Text")
    self.buildingIcon = go.transform:Find("content/buildingInfoRoot/content/buildingIcon"):GetComponent("Image")
    self.buildTimeText = go.transform:Find("content/buildingInfoRoot/content/infoBg/buildTimeText"):GetComponent("Text")
    self.timeText = go.transform:Find("content/buildingInfoRoot/content/infoBg/timeText"):GetComponent("Text")
    self.switchBtn = go.transform:Find("content/buildingInfoRoot/content/infoBg/switchBtn"):GetComponent("Text")
    self.tipBox = go.transform:Find("content/buildingInfoRoot/content/tipBox")
    self.tipBoxText = go.transform:Find("content/buildingInfoRoot/content/tipBox/tipBoxText"):GetComponent("Text")
    --landInfoRoot
    self.landInfoRoot = go.transform:Find("content/landInfoRoot")                       --土地信息
    self.gridGroup = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content"):GetComponent("GridLayoutGroup")
----------------------------------------------------------landInfoConten 地块----------------------------------------------------------------------------------
    --地块1
    self.mineLandBtn1 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg7/mineLandBtn7")
    self.otherLandBtn1 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg7/otherLandBtn7")
    --地块2
    self.mineLandBtn2 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg8/mineLandBtn8")
    self.otherLandBtn2 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg8/otherLandBtn8")
    --地块3
    self.mineLandBtn3 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg9/mineLandBtn9")
    self.otherLandBtn3 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg9/otherLandBtn9")
    --地块4
    self.mineLandBtn4 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg12/mineLandBtn12")
    self.otherLandBtn4 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg12/otherLandBtn12")
    --地块5
    self.mineLandBtn5 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg13/mineLandBtn13")
    self.otherLandBtn5 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg13/otherLandBtn13")
    --地块6
    self.mineLandBtn6 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg14/mineLandBtn14")
    self.otherLandBtn6 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg14/otherLandBtn14")
    --地块7
    self.mineLandBtn7 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg17/mineLandBtn17")
    self.otherLandBtn7 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg17/otherLandBtn17")
    --地块8
    self.mineLandBtn8 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg18/mineLandBtn18")
    self.otherLandBtn8 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg18/otherLandBtn18")
    --地块9
    self.mineLandBtn9 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg19/mineLandBtn19")
    self.otherLandBtn9 = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/landBg19/otherLandBtn19")
    --地块选择框
    self.chooseBoxImg = go.transform:Find("content/landInfoRoot/content/landInfoConten/Viewport/Content/chooseBoxImg")
    --mineLandBtnTable
    if not self.mineLandBtnTable then
        self.mineLandBtnTable = {}
        for i = 1,9 do
            table.insert(self.mineLandBtnTable,self["mineLandBtn"..tostring(i)])
        end
    end
    --otherLandBtnTable
    if not self.otherLandBtnTable then
        self.otherLandBtnTable = {}
        for i = 1,9 do
            table.insert(self.otherLandBtnTable,self["otherLandBtn"..tostring(i)])
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------
    --mineLandInfo
    self.mineLandInfo = go.transform:Find("content/landInfoRoot/content/mineLandInfo")
    self.buyingTime = go.transform:Find("content/landInfoRoot/content/mineLandInfo/buyingTime/time"):GetComponent("Text")
    self.buyingTimeText = go.transform:Find("content/landInfoRoot/content/mineLandInfo/buyingTime/time/timeText"):GetComponent("Text")
    self.buyingPrice = go.transform:Find("content/landInfoRoot/content/mineLandInfo/buyingPrice/price"):GetComponent("Text")
    self.buyingPriceText = go.transform:Find("content/landInfoRoot/content/mineLandInfo/buyingPrice/price/priceText"):GetComponent("Text")
    --otherLandInfo
    self.otherLandInfo = go.transform:Find("content/landInfoRoot/content/otherLandInfo")
    self.headImg = go.transform:Find("content/landInfoRoot/content/otherLandInfo/headBg/headImg"):GetComponent("Image")
    self.nameText = go.transform:Find("content/landInfoRoot/content/otherLandInfo/name/nameText"):GetComponent("Text")
    self.genderImg = go.transform:Find("content/landInfoRoot/content/otherLandInfo/name/nameText/genderImg"):GetComponent("Image")
    self.companyText = go.transform:Find("content/landInfoRoot/content/otherLandInfo/company/companyText"):GetComponent("Text")
    self.leaseTime = go.transform:Find("content/landInfoRoot/content/otherLandInfo/leaseTime/leaseTimeText"):GetComponent("Text")
    self.leaseTimeText = go.transform:Find("content/landInfoRoot/content/otherLandInfo/leaseTime/timeText"):GetComponent("Text")
    self.rentText = go.transform:Find("content/landInfoRoot/content/otherLandInfo/rent/rentText"):GetComponent("Text")
    self.priceText = go.transform:Find("content/landInfoRoot/content/otherLandInfo/rent/priceText"):GetComponent("Text")
    --buildingTypeContent                                                               --根据不同建筑生成不同的Item
    self.buildingTypeContent = go.transform:Find("content/buildingInfoRoot/content/buildingTypeContent")
end
---------------------------------------------------------------初始化函数------------------------------------------------------------------------------
---------------------------------------------------------------建筑信息--------------------------------------------------------------------------------
--请求建筑信息
function BuildingInformationCtrl:getBuildingInfo()
    if self.m_data then
        self.m_data.insId = OpenModelInsID.BuildingInfoId
        DataManager.OpenDetailModel(BuildingInformationModel,self.m_data.insId)
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            --原料厂
            DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqMaterialFactoryInfo',self.m_data.id,self.m_data.ownerId)
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            --加工厂
            DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqProcessingFactoryInfo',self.m_data.id,self.m_data.ownerId)
        elseif self.m_data.buildingType == BuildingType.RetailShop then
            --零售店
            DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqRetailShopInfo',self.m_data.id,self.m_data.ownerId)
        end
    end
end
--初始化UI建筑信息
function BuildingInformationCtrl:initializeUiBuildingInfo()
    self.buildingName.text = self.m_data.name
    LoadSprite(BuildingInformationIcon[self.m_data.mId].imgPath,self.buildingIcon,true)
    self.timeText.text = self:getStringTime(self.m_data.constructCompleteTs)
    --开业停业
    self:initializeButtonInfo()
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        --原料厂
        if self.m_data.mId == 1100001 then
            self.buildingTypeText.text = "小型原料厂"
        elseif self.m_data.mId == 1100002 then
            self.buildingTypeText.text = "中型原料厂"
        elseif self.m_data.mId == 1100003 then
            self.buildingTypeText.text = "大型原料厂"
        end
        self.tipText.text = "原料厂可生产各种基本原料，这些原料是生产产品所必需的。"
        local function callback(obj)
            self.buildingInfoItem = materialFactoryItem:new(self.buildingInfo,obj,self.luaBehaviour,self.m_data.ownerId)
        end
        createPrefab(BuildingInformationCtrl.MaterialFactoryItem_Path,self.buildingTypeContent,callback)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        --加工厂
        if self.m_data.mId == 1200001 then
            self.buildingTypeText.text = "小型加工厂"
        elseif self.m_data.mId == 1200002 then
            self.buildingTypeText.text = "中型加工厂"
        elseif self.m_data.mId == 1200003 then
            self.buildingTypeText.text = "大型加工厂"
        end
        self.tipText.text = "加工厂采用原料生产同步产品，提高了产品的质量和知名度。"
        local function callback(obj)
            self.buildingInfoItem = processingFactoryItem:new(self.buildingInfo,obj,self.luaBehaviour,self.m_data.ownerId)
        end
        createPrefab(BuildingInformationCtrl.ProcessingFactoryItem_Path,self.buildingTypeContent,callback)
    elseif self.m_data.buildingType == BuildingType.RetailShop then
        --零售店
        if self.m_data.mId == 1300001 then
            self.buildingTypeText.text = "小型零售店"
        elseif self.m_data.mId == 1300002 then
            self.buildingTypeText.text = "中型零售店"
        elseif self.m_data.mId == 1300003 then
            self.buildingTypeText.text = "大型零售店"
        end
        self.tipText.text = "本厂采用原料生产同步产品，提高了产品的质量和知名度。"
        local function callback(obj)
            self.buildingInfoItem = retailStoreItem:new(self.buildingInfo,obj,self.luaBehaviour,self.m_data.ownerId)
        end
        createPrefab(BuildingInformationCtrl.RetailStoreItem_Path,self.buildingTypeContent,callback)
    elseif self.m_data.buildingType == BuildingType.House then
        --住宅
    elseif self.m_data.buildingType == BuildingType.Municipal then
        --推广公司
    elseif self.m_data.buildingType == BuildingType.Laboratory then
        --研究所
    end
    self:defaultBuildingInfoTrue()
end
--初始化按钮信息
function BuildingInformationCtrl:initializeButtonInfo()
    --是否是建筑主人
    if self.m_data.ownerId == DataManager.GetMyOwnerID() then
        --是否开业
        if self.m_data.state == "OPERATE" then
            self.switchBtn.text = "停业"
            businessState = true
        else
            self.switchBtn.text = "拆除"
            businessState = false
        end
    else
        self.switchBtn.transform.localScale = Vector3.zero
        self.modifyImg.transform.localScale = Vector3.zero
        self.buildingName:GetComponent("Button").interactable = false
    end
end
--默认打开建筑信息
function BuildingInformationCtrl:defaultBuildingInfoTrue()
    self.tipBox.transform.localScale = Vector3.zero
    self.buildingChoose.transform.localScale = Vector3.one
    self.buildingInfoRoot.transform.localScale = Vector3.one
    self.landChoose.transform.localScale = Vector3.zero
    self.landInfoRoot.transform.localScale = Vector3.zero
end
---------------------------------------------------------------土地信息--------------------------------------------------------------------------------
--请求土地信息,土地主人信息,建筑信息
function BuildingInformationCtrl:getLandInfo()
    --请求土地信息
    local startLandId = TerrainManager.GridIndexTurnBlockID(self.m_data.pos)
    local landIds = DataManager.CaculationTerrainRangeBlock(startLandId,PlayerBuildingBaseData[self.m_data.mId].x)
    self.groundData = {}
    for k,landId in pairs(landIds) do
        local data = DataManager.GetGroundDataByID(landId)
        table.insert(self.groundData,data)
    end
    --请求土地主人信息
    self.groundOwnerData = {}
    for k,ground in pairs(self.groundData) do
        local ids = {}
        table.insert(ids,ground.Data.ownerId)
        PlayerInfoManger.GetInfos(ids,self.SaveData,self)
    end
    --请求建筑主人的信息
    local ids = {}
    table.insert(ids,self.m_data.ownerId)
    PlayerInfoManger.GetInfos(ids,self.SaveData,self)
end
--初始化UI土地信息
function BuildingInformationCtrl:initializeUiLandInfo()
    local buildingSize = PlayerBuildingBaseData[self.m_data.mId].x
    if buildingSize == 1 then
        --如果是1*1的建筑,地块UI布局
        self.gridGroup.padding.left = -55
        self.gridGroup.padding.top = -60
        for key,value in pairs(self.mineLandBtnTable) do
            if key == 5 then
                self.chooseBoxImg.transform.localPosition = value.transform.parent.localPosition
            else
                value.transform.localScale = Vector3.zero
            end
        end
    elseif buildingSize == 2 then
        --如果是2*2的建筑,地块UI布局
        self.gridGroup.padding.left = -5
        self.gridGroup.padding.top = -15
    elseif buildingSize == 3 then
        --如果是3*3的建筑,地块UI布局
        self.gridGroup.padding.left = -55
        self.gridGroup.padding.top = -60
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------
--多语言
function BuildingInformationCtrl:language()
    self.topName.text = "建筑综合评分"
    self.buildingNomalText.text = "建筑信息"
    self.buildingChooseText.text = "建筑信息"
    self.landNomalText.text = "土地信息"
    self.landChooseText.text = "土地信息"
    self.buildTimeText.text = "施工时间:"
end
---------------------------------------------------------------点击函数--------------------------------------------------------------------------------
--打开建筑信息
function BuildingInformationCtrl:_clickBuildingNomal(ins)
    PlayMusEff(1002)
    ins.buildingChoose.transform.localScale = Vector3.one
    ins.buildingInfoRoot.transform.localScale = Vector3.one
    ins.landChoose.transform.localScale = Vector3.zero
    ins.landInfoRoot.transform.localScale = Vector3.zero
end
--打开土地信息
function BuildingInformationCtrl:_clickLandNomal(ins)
    PlayMusEff(1002)
    ins:initializeUiLandInfo()
    ins.landChoose.transform.localScale = Vector3.one
    ins.landInfoRoot.transform.localScale = Vector3.one
    ins.buildingChoose.transform.localScale = Vector3.zero
    ins.buildingInfoRoot.transform.localScale = Vector3.zero
end
--停业或拆除
function BuildingInformationCtrl:_clickSwitchBtn(ins)
    PlayMusEff(1002)
    if businessState == true then
        --停业
        local data = {isbool = true,fun = function()
            Event.Brocast("m_ReqClosedBuilding",ins.m_data.id)
        end}
        ct.OpenCtrl('ReminderTipsCtrl',data)
    else
        --拆除
        local data = {isbool = false,fun = function()
            Event.Brocast("m_ReqDemolitionBuilding",ins.m_data.id)
            DataManager.RemoveMyBuildingDetailByBuildID(ins.m_data.id)
            UIPanel.CloseAllPageExceptMain()
            Event.Brocast("SmallPop","拆除成功", 300)
        end}
        ct.OpenCtrl('ReminderTipsCtrl',data)
    end
end
--修改建筑名字
function BuildingInformationCtrl:_clickBuildingName(ins)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(25040001)
    data.btnCallBack = function(name)
        Event.Brocast("m_ReqSetBuildingName",ins.m_data.id,name)
    end
    ct.OpenCtrl("InputDialogPageCtrl",data)
end
--地块信息
function BuildingInformationCtrl:_clickGroundBtn(ins)
    PlayMusEff(1002)
    ins.chooseBoxImg.transform.localPosition = self.transform.parent.localPosition
end
--关闭界面
function BuildingInformationCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
---------------------------------------------------------------回调函数---------------------------------------------------------------------------
--缓存建筑信息回调
function BuildingInformationCtrl:builidngInfo(dataInfo)
    self.buildingInfo = dataInfo
end
--停业成功回调
function BuildingInformationCtrl:closedBuildingSucceed(dataInfo)
    if dataInfo then
        UIPanel.ClosePage()
        self.switchBtn.text = "拆除"
        businessState = false
        Event.Brocast("SmallPop","停业成功", 300)
    end
end
--修改建筑名字成功
function BuildingInformationCtrl:setBuildingNameSucceed(dataInfo)
    if dataInfo then
        UIPanel.ClosePage()
        self.buildingName.text = dataInfo.name
        Event.Brocast("SmallPop","建筑名字修改成功", 300)
    end
end
----------------------------------------------------------------事件函数---------------------------------------------------------------------------
--打开提示框
function BuildingInformationCtrl:openTipBox(stringKey,position,parent)
    if isShow == false then
        if stringKey ~= nil and position ~= nil then
            self.tipBox.transform:SetParent(parent)
            self.tipBoxText.text = GetLanguage(stringKey)
            self.tipBox.transform.anchoredPosition = Vector3.New(-250,0,0)
            self.tipBox.transform.localScale = Vector3.one
        end
        isShow = true
    else
        self.tipBox.transform:SetParent(self.content)
        self.tipBoxText.text = ""
        self.tipBox.transform.localScale = Vector3.zero
        isShow = false
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------------
--时间格式转换
function BuildingInformationCtrl:getStringTime(ms)
    local timeTable = getFormatUnixTimeNumber(ms / 1000)
    local timeStr = timeTable.year.."/"..timeTable.month.."/"..timeTable.day.." "..timeTable.hour..":"..timeTable.min
    return timeStr
end
--缓存建筑主人信息
function BuildingInformationCtrl:SaveData(ownerData)
    if self.groundOwnerData then
        table.insert(self.groundOwnerData,ownerData[1])
    end
end