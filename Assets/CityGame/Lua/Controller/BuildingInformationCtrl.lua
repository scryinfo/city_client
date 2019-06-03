---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
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
BuildingInformationCtrl.LaboratoryItem_Path = "Assets/CityGame/Resources/View/NewItems/laboratoryItem.prefab"                 --零售店
BuildingInformationCtrl.HouseItem_Path = "Assets/CityGame/Resources/View/NewItems/houseBuildingInfoItem.prefab"                 --住宅
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
end
function BuildingInformationCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("openTipBox",self.openTipBox,self)
end
function BuildingInformationCtrl:Refresh()
    self:language()
    self:getBuildingInfo()
    self:initializeUiInfoData()
end

function BuildingInformationCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("openTipBox",self.openTipBox,self)
    destroy(self.buildingInfoItem.prefab.gameObject)
    self.buildingInfoItem = nil
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

    --buildingTypeContent                                                               --根据不同建筑生成不同的Item
    self.buildingTypeContent = go.transform:Find("content/buildingInfoRoot/content/buildingTypeContent")
end
---------------------------------------------------------------初始化函数------------------------------------------------------------------------------
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
        elseif self.m_data.buildingType == BuildingType.Laboratory then
            --研究所
            DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqRetailLaboratoryInfo',self.m_data.id,self.m_data.ownerId)
        elseif self.m_data.buildingType == BuildingType.House then
            --住宅
            DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqHouseInfo',self.m_data.id,self.m_data.ownerId)
        end
    end
end

--初始化UI信息
function BuildingInformationCtrl:initializeUiInfoData()
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
        local data = PlayerBuildingBaseData[self.m_data.mId]
        self.buildingTypeText.text = GetLanguage(data.sizeName)..GetLanguage(data.typeName)
        self.tipText.text = "本厂采用原料生产同步产品，提高了产品的质量和知名度。"
        local function callback(obj)
            self.buildingInfoItem = houseBuildingInfoItem:new(self.buildingInfo,obj,self.luaBehaviour,self.m_data.ownerId)
        end
        createPrefab(BuildingInformationCtrl.HouseItem_Path,self.buildingTypeContent,callback)
    elseif self.m_data.buildingType == BuildingType.Municipal then
        --推广公司
    elseif self.m_data.buildingType == BuildingType.Laboratory then
        --研究所
        if self.m_data.mId == 1500001 then
            self.buildingTypeText.text = "小型研究所"
        elseif self.m_data.mId == 1500002 then
            self.buildingTypeText.text = "中型研究所"
        elseif self.m_data.mId == 1500003 then
            self.buildingTypeText.text = "大型研究所"
        end
        self.tipText.text = "研究所为Eva提供研究点数以及发明新商品。"
        local function callback(obj)
            self.buildingInfoItem = laboratoryItem:new(self.buildingInfo,obj,self.luaBehaviour,self.m_data.ownerId)
        end
        createPrefab(BuildingInformationCtrl.LaboratoryItem_Path,self.buildingTypeContent,callback)
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