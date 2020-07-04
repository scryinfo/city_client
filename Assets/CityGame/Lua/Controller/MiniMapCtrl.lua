---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by allen.
--- DateTime: 2019/1/28 17:42
---Minimap
-----

MiniMapCtrl = class('MiniMapCtrl',UIPanel)
UIPanel:ResgisterOpen(MiniMapCtrl)

function MiniMapCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.None)
end

function MiniMapCtrl:bundleName()
    return "Assets/CityGame/Resources/View/MiniMapPanel.prefab"
end

function MiniMapCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
    --Close panel
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    LuaBehaviour:AddClick(MiniMapPanel.bg_back, function()
        PlayMusEff(1002)
        UIPanel.ClosePage()
    end )
    LuaBehaviour:AddClick(MiniMapPanel.btn_back, function()
        PlayMusEff(1002)
        UIPanel.ClosePage()
    end )
    LuaBehaviour:AddClick(MiniMapPanel.btn_enlarge, function()
        PlayMusEff(1002)
        self:EnLargeMap()
    end )
    LuaBehaviour:AddClick(MiniMapPanel.btn_narrow, function()
        PlayMusEff(1002)
        self:NarrowMap()
    end )
end

--Enlarge the map [over]
function MiniMapCtrl:EnLargeMap()
    if self.my_Scale ~= nil and  self.ScaleOffset ~= nil and self.ScaleMax ~= nil then
        local scale_value = self.my_Scale + self.ScaleOffset
        if scale_value >= self.ScaleMax then
            scale_value = self.ScaleMax
        end
        if self.my_Scale ~= scale_value then
            self:CenterOffset(self.my_Scale,scale_value)
            self.my_Scale = scale_value
            self:RefreshMiniMapScale()
        end
    end
end

--Zoom out the map [over][over]
function MiniMapCtrl:NarrowMap()
    if self.my_Scale ~= nil and  self.ScaleOffset ~= nil and self.ScaleMin ~= nil then
        local scale_value = self.my_Scale - self.ScaleOffset
        if scale_value <= self.ScaleMin then
            scale_value = self.ScaleMin
        end
        if self.my_Scale ~= scale_value then
            self:CenterOffset(self.my_Scale,scale_value)
            self.my_Scale = scale_value
            self:RefreshMiniMapScale()
        end
    end
end

--Do center offset
function MiniMapCtrl:CenterOffset(beginScale,EndScale)
    local TargetAnchoredPosition = MiniMapPanel.rect_MiniMapBg.anchoredPosition * (EndScale/ beginScale)
    local NowRangeSize = (EndScale - 1) * MiniMapPanel.rect_MiniMapBg.sizeDelta.x / 2
    if TargetAnchoredPosition.x > NowRangeSize then
        TargetAnchoredPosition.x = NowRangeSize
    elseif  TargetAnchoredPosition.x < -NowRangeSize then
        TargetAnchoredPosition.x = -NowRangeSize
    end
    if TargetAnchoredPosition.y > NowRangeSize then
        TargetAnchoredPosition.y = NowRangeSize
    elseif  TargetAnchoredPosition.y < -NowRangeSize then
        TargetAnchoredPosition.y = -NowRangeSize
    end
    MiniMapPanel.rect_MiniMapBg:DOAnchorPos(TargetAnchoredPosition , self.ScaleDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
end


--Refresh the current map size
function MiniMapCtrl:RefreshMiniMapScale()
    --Refresh Slider
    MiniMapPanel.slider_Scale.value = self.my_Scale
    --TODO: Do center offset.
    MiniMapPanel.rect_MiniMapBg:DOScale(Vector3.New(self.my_Scale,self.my_Scale,self.my_Scale),self.ScaleDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
end

function MiniMapCtrl:Awake(go)
    self.gameObject = go
    self:InitConfig()
end

--Read the configuration table.
function MiniMapCtrl:InitConfig()
    --Read configuration table
    self.ScaleMin = TerrainConfig.MiniMap.ScaleMin
    self.ScaleMax = TerrainConfig.MiniMap.ScaleMax
    self.ScaleOffset = TerrainConfig.MiniMap.ScaleOffset
    self.my_Scale = TerrainConfig.MiniMap.ScaleStart
    self.ScaleDuringTime = TerrainConfig.MiniMap.ScaleDuringTime
    --
    self.itemWidth = MiniMapPanel.rect_MiniMapBg.sizeDelta.x / TerrainConfig.MiniMap.MapSize   --The Rect size of one item
    self.itemDelta = Vector2.New(self.itemWidth , self.itemWidth)                               --Scale size of one item
end

function MiniMapCtrl:Active()
    UIPanel.Active(self)

    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getAllBuildingDetail","gs.BuildingSet",self.n_OnReceiveAllBuildingDetailInfo,self)
    --Set the map size and slider initial value
    MiniMapPanel.slider_Scale.minValue = self.ScaleMin
    MiniMapPanel.slider_Scale.maxValue = self.ScaleMax
    self:RefreshMiniMapScale()
    self:_initSystemItem()
end

--Generate system building, only once in Awake
function MiniMapCtrl:_initSystemItem()
    --Spawn center building
    local obj = UnityEngine.GameObject.Instantiate(MiniMapPanel.prefab_CentralItem,MiniMapPanel.root_system)
    obj:SetActive(true)
    local objRect = obj:GetComponent("RectTransform")
    local rectPos = Vector2.New(TerrainConfig.CentralBuilding.CenterNodePos.z ,- TerrainConfig.CentralBuilding.CenterNodePos.x )
    objRect.anchoredPosition = rectPos * self.itemWidth
    objRect.sizeDelta = self.itemDelta *  PlayerBuildingBaseData[TerrainConfig.CentralBuilding.BuildingType].x
    local tempBtn =  obj:GetComponent("Button")
    tempBtn.onClick:RemoveAllListeners()
    rectPos.y = - rectPos.y
    tempBtn.onClick:AddListener(function ()
        self:_clickConstructBtn(rectPos)
    end)
end


function MiniMapCtrl:Refresh()
    local msgId = pbl.enum("gscode.OpCode", "getAllBuildingDetail")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end

function MiniMapCtrl:_initItemData()
    --Refresh the land item according to the available land
    self:CalculateMyGrounds()
    --Generate building items according to the configuration table
    local MyBuild = DataManager.GetMyAllBuildingDetail()
    --Build a house
    if MyBuild.apartment ~= nil then
        self:CreateBuildItems(MyBuild.apartment,MiniMapPanel.prefab_HomeItem,MiniMapPanel.root_home)
    end
    --Raw material plant
    if MyBuild.materialFactory ~= nil then
        self:CreateBuildItems(MyBuild.materialFactory,MiniMapPanel.prefab_MaterialItem,MiniMapPanel.root_material)
    end
    --Generate processing plant
    if MyBuild.produceDepartment ~= nil then
        self:CreateBuildItems(MyBuild.produceDepartment,MiniMapPanel.prefab_FactoryItem,MiniMapPanel.root_factory)
    end
    --Generate retail store
    if MyBuild.retailShop ~= nil then
        self:CreateBuildItems(MyBuild.retailShop,MiniMapPanel.prefab_SupermarketItem,MiniMapPanel.root_supermarket)
    end
end


function MiniMapCtrl:CreateBuildItems(itemDatas,itemPrefab,itemRoot)
    if self.Btn_Objs == nil then
        self.Btn_Objs = {}
    end
    for key, value in pairs(itemDatas) do
        if value.info ~= nil and value.info.pos ~= nil and value.info.pos.x ~= nil and value.info.pos.y ~= nil and value.info.mId ~= nil and PlayerBuildingBaseData[value.info.mId] ~= nil and PlayerBuildingBaseData[value.info.mId].x ~= nil  then
            local obj = UnityEngine.GameObject.Instantiate(itemPrefab,itemRoot)
            obj:SetActive(true)
            local objRect = obj:GetComponent("RectTransform")
            objRect.anchoredPosition = Vector2.New( value.info.pos.y, - value.info.pos.x) * self.itemWidth
            objRect.sizeDelta = self.itemDelta *  PlayerBuildingBaseData[value.info.mId].x
            local tempBtn =  obj:GetComponent("Button")
            tempBtn.onClick:RemoveAllListeners();
            tempBtn.onClick:AddListener(function ()
                self:_clickConstructBtn(value.info.pos)
            end)
            table.insert(self.Btn_Objs,obj)
        end
    end
end

function MiniMapCtrl:CalculateMyGrounds()
    local myPersonData = DataManager.GetMyPersonData()
    if myPersonData == nil then
        return
    end
    if myPersonData.m_groundInfos ~= nil then
        for key, value in pairs(myPersonData.m_groundInfos) do
            if  DataManager.IsOwnerGround({x = value.x, z = value.y}) then
                self:CreateGroundItems(value,MiniMapPanel.prefab_GroundItem,MiniMapPanel.root_ground)
            end
        end
    else
        myPersonData.m_groundInfos = {}
    end
    if  myPersonData.m_rentGroundInfos ~= nil then
        for key, value in pairs(myPersonData.m_rentGroundInfos) do
            if  DataManager.IsOwnerGround({x = value.x, z = value.y}) then
                self:CreateGroundItems(value,MiniMapPanel.prefab_GroundItem,MiniMapPanel.root_ground)
            end
        end
    else
        myPersonData.m_rentGroundInfos = {}
    end
end

--Create My Land Item
function MiniMapCtrl:CreateGroundItems(value,itemPrefab,itemRoot)
    if self.Btn_Objs == nil then
        self.Btn_Objs = {}
    end
    if value.x ~= nil and value.y ~= nil then
        local obj = UnityEngine.GameObject.Instantiate(itemPrefab,itemRoot)
        obj:SetActive(true)
        local objRect = obj:GetComponent("RectTransform")
        objRect.anchoredPosition = Vector2.New( value.y, - value.x) * self.itemWidth
        objRect.sizeDelta = self.itemDelta
        local tempBtn =  obj:GetComponent("Button")
        tempBtn.onClick:RemoveAllListeners();
        tempBtn.onClick:AddListener(function ()
            self:_clickConstructBtn(value)
        end)
        table.insert(self.Btn_Objs,obj)
    end
end

--Click the building button
function MiniMapCtrl:_clickConstructBtn(tempPos)
    PlayMusEff(1002)
    local MoveToPos = Vector3.New(tempPos.x,0,tempPos.y)
    CameraMove.MoveCameraToPos(MoveToPos)
    UIPanel.ClosePage()
end

function MiniMapCtrl:n_OnReceiveAllBuildingDetailInfo(data)
    if data then
        DataManager.SetMyAllBuildingDetail(data)
    end
    self:_initItemData()
end


function MiniMapCtrl:Hide()
    UIPanel.Hide(self)
    if self.Btn_Objs ~= nil then
        for i, go in pairs(self.Btn_Objs) do
            destroy(go)
        end
        self.Btn_Objs = nil
    end
end

