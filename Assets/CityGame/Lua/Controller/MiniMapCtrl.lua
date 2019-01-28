---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by allen.
--- DateTime: 2019/1/28 17:42
---小地图
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
    --关闭面板
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

--放大地图[over]
function MiniMapCtrl:EnLargeMap()
    if self.my_Scale ~= nil and  self.ScaleOffset ~= nil and self.ScaleMax ~= nil then
        local scale_value = self.my_Scale + self.ScaleOffset
        if scale_value >= self.ScaleMax then
            scale_value = self.ScaleMax
        end
        if self.my_Scale ~= scale_value then
            self.my_Scale = scale_value
            RefreshMiniMapScale()
        end
    end
end

--缩小地图[over]
function MiniMapCtrl:NarrowMap()
    if self.my_Scale ~= nil and  self.ScaleOffset ~= nil and self.ScaleMin ~= nil then
        local scale_value = self.my_Scale - self.ScaleOffset
        if scale_value <= self.ScaleMin then
            scale_value = self.ScaleMin
        end
        if self.my_Scale ~= scale_value then
            self.my_Scale = scale_value
            RefreshMiniMapScale()
        end
    end
end

--刷新当前地图的大小
function RefreshMiniMapScale()
    --刷新Slider
    MiniMapPanel.slider_Scale.value = self.my_Scale
    --TODO:做中心偏移
    this.rect_MiniMapBg:DOScale(Vector3.New(self.my_Scale,self.my_Scale,self.my_Scale),self.ScaleDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
end

function MiniMapCtrl:Awake(go)
    self.gameObject = go
    self:InitConfig()
end

--读取配置表
function MiniMapCtrl:InitConfig()
    --读取配置表
    self.ScaleMin = TerrainConfig[MiniMap].ScaleMin
    self.ScaleMax = TerrainConfig[MiniMap].ScaleMax
    self.ScaleOffset = TerrainConfig[MiniMap].ScaleOffset
    self.my_Scale = TerrainConfig[MiniMap].ScaleStart
    self.ScaleDuringTime = TerrainConfig[MiniMap].ScaleDuringTime
    --
    self.itemWidth = MiniMapPanel.rect_MiniMapBg.sizeDelta.x / TerrainConfig[MiniMap].MapSize   --一格Item的Rect大小
    self.itemDelta = Vector2.New(self.itemWidth , self.itemWidth)                               --一格Item的Scale大小
end

function MiniMapCtrl:Active()
    UIPanel.Active(self)
    --设置地图大小和Slider初始值
    MiniMapPanel.slider_Scale.minValue = self.ScaleMin
    MiniMapPanel.slider_Scale.maxValue = self.ScaleMax
    RefreshMiniMapScale()
    self:_initSystemItem()
end

--生成系统建筑，只在Awake生成一次
function MiniMapCtrl:_initSystemItem()
    --生成中心建筑
    local obj = UnityEngine.GameObject.Instantiate(MiniMapPanel.prefab_CentralItem,MiniMapPanel.root_system)
    local objRect = obj:GetComponent("RectTransform")
    local rectPos = Vector2.New(TerrainConfig.CentralBuilding.CenterNodePos.x ,TerrainConfig.CentralBuilding.CenterNodePos.z )
    objRect.anchoredPosition = rectPos * self.itemWidth
    objRect.sizeDelta = self.itemDelta *  PlayerBuildingBaseData[TerrainConfig.CentralBuilding.BuildingType].x
    local tempBtn =  obj:GetComponent("Button")
    tempBtn.onClick:RemoveAllListeners();
    tempBtn.onClick:AddListener(function ()
        self:_clickConstructBtn(rectPos)
    end)
end


function MiniMapCtrl:Refresh()
    self:_initItemData()
end

function MiniMapCtrl:_initItemData()
    --根据配置表生成Items
    local MyBuild = DataManager.GetMyAllBuildingDetail()
    --生成住宅
    if MyBuild.apartment ~= nil then
        self:CreateItems(MyBuild.apartment,MiniMapPanel.prefab_HomeItem,MiniMapPanel.root_home)
    end
    --生成原料厂
    if MyBuild.materialFactory ~= nil then
        self:CreateItems(MyBuild.materialFactory,MiniMapPanel.prefab_MaterialItem,MiniMapPanel.root_material)
    end
    --生成加工厂
    if MyBuild.produceDepartment ~= nil then
        self:CreateItems(MyBuild.produceDepartment,MiniMapPanel.prefab_FactoryItem,MiniMapPanel.root_factory)
    end
    --生成零售店
    if MyBuild.retailShop ~= nil then
        self:CreateItems(MyBuild.retailShop,MiniMapPanel.prefab_SupermarketItem,MiniMapPanel.root_supermarket)
    end
    local path = 'View/Items/ConstructItem'
    local prefab = UnityEngine.Resources.Load(path);
    if not prefab then
        return
    end
    local contentWidth = 0
    self.Items  = {}
    for key, item in ipairs(ConstructConfig) do
        local itemObj = UnityEngine.GameObject.Instantiate(prefab,self.contentTrans)
        self.Items[key] = ConstructItem:new(item, itemObj.transform ,contentWidth)
        contentWidth =  self.Items[key].sizeDeltaX
    end
    contentWidth  =  contentWidth - 12
    self.contentTrans:GetComponent("RectTransform").sizeDelta = Vector2.New(contentWidth,self.contentTrans:GetComponent("RectTransform").sizeDelta.y)
end


function MiniMapCtrl:CreateItems(itemDatas,itemPrefab,itemRoot)
    if self.Btn_Objs == nil then
        self.Btn_Objs = {}
    end
    for key, value in pairs(itemDatas) do
        if value.info ~= nil and value.info.pos ~= nil and value.info.pos.x ~= nil and value.info.pos.y ~= nil and value.info.mId ~= nil and PlayerBuildingBaseData[value.info.mId] ~= nil and PlayerBuildingBaseData[value.info.mId].x ~= nil  then
            local obj = UnityEngine.GameObject.Instantiate(itemPrefab,itemRoot)
            local objRect = obj:GetComponent("RectTransform")
            objRect.anchoredPosition = value.info.pos * self.itemWidth
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

--点击建筑按钮
function MiniMapCtrl:_clickConstructBtn(tempPos)
    PlayMusEff(1002)
    local MoveToPos = Vector3.New(tempPos.x,0,tempPos.y)
    CameraMove.MoveCameraToPos(MoveToPos)
    UIPanel.Close()
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

