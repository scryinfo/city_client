---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---点击其他人的建筑
MapRightOtherBuildingPage = class('MapRightOtherBuildingPage', MapRightPageBase)
MapRightOtherBuildingPage.moneyColor = "#F4AD07FF"

--初始化方法
function MapRightOtherBuildingPage:initialize(viewRect)
    self.viewRect = viewRect:GetComponent("RectTransform")

    local trans = self.viewRect.transform
    self.closeBtn = trans:Find("topRoot/closeBtn"):GetComponent("Button")
    self.goHereBtn = trans:Find("bottomRoot/goHereBtn"):GetComponent("Button")
    self.portraitImg = trans:Find("topRoot/protaitRoot/bg")
    self.nameText = trans:Find("topRoot/nameText"):GetComponent("Text")
    self.companyText = trans:Find("topRoot/companyText"):GetComponent("Text")
    self.buildingNameText = trans:Find("topRoot/bg/buildingNameText"):GetComponent("Text")
    --self.femaleIconTran = trans:Find("topRoot/nameText/femaleIcon")
    --self.manIconTran = trans:Find("topRoot/nameText/manIcon")

    self.simpleInfo = trans:Find("bottomRoot/simpleInfo")  --其他只显示简单信息的建筑
    self.simpleShowRoot = trans:Find("bottomRoot/simpleInfo/showInfoRoot")

    self.promotionInfo = trans:Find("bottomRoot/promotionInfo")  --推广公司
    self.promotionItem = MapRightOtherPromotePage:new(self.promotionInfo)

    self.technologyInfo = trans:Find("bottomRoot/technologyInfo")  --研究所
    self.technologyItem = MapRightOtherTechnologyPage:new(self.technologyInfo)

    self.matGoodInfo = trans:Find("bottomRoot/matGoodInfo")  --显示Mat Good的建筑
    self.matGoodItem = MapRightOtherMatGoodPage:new(self.matGoodInfo)

    self.closeBtn.onClick:AddListener(function ()
        self:close()
    end)
    self.goHereBtn.onClick:AddListener(function ()
        self:_goHereBtn()
    end)
    --
    self.goHereText01 = self.viewRect.transform:Find("bottomRoot/goHereBtn/Text"):GetComponent("Text")
end
--详细数据 & 当前搜索的数据
function MapRightOtherBuildingPage:refreshData(data, typeData)
    self.viewRect.anchoredPosition = Vector2.zero
    self:_cleanItems()

    self.data = data.detailData
    self:switchShowTrans(typeData.typeId)
    self:showByType(typeData)
    self:openShow()
end
--根据搜索类型显示详情
function MapRightOtherBuildingPage:switchShowTrans(typeId)
    self.matGoodInfo.localScale = Vector3.zero
    self.promotionInfo.localScale = Vector3.zero
    self.technologyInfo.localScale = Vector3.zero
    self.simpleInfo.localScale = Vector3.zero

    if typeId == EMapSearchType.Material or typeId == EMapSearchType.Goods then
        self.matGoodInfo.localScale = Vector3.one
    elseif typeId == EMapSearchType.Promotion then
        self.promotionInfo.localScale = Vector3.one
    elseif typeId == EMapSearchType.Technology then
        self.technologyInfo.localScale = Vector3.one
    else
        self.simpleInfo.localScale = Vector3.one
    end
end
--
function MapRightOtherBuildingPage:showByType(typeData)
    PlayerInfoManger.GetInfos({[1] = self.data.ownerId}, self._initPersonalInfo, self)

    --直接搜索类型
    if typeData.detailId == nil then
        if typeData.typeId == EMapSearchType.Warehouse then
            self.buildingNameText.text = string.format("%s %s%s", self.data.name, GetLanguage(PlayerBuildingBaseData[self.data.metaId].sizeName), GetLanguage(PlayerBuildingBaseData[self.data.metaId].typeName))
            self:_createWarehouse()
            self:_sortInfoItems()

        elseif typeData.typeId == EMapSearchType.Signing then
            self.buildingNameText.text = string.format("%s %s%s", self.data.buildingName, GetLanguage(PlayerBuildingBaseData[self.data.mId].sizeName), GetLanguage(PlayerBuildingBaseData[self.data.mId].typeName))
            self:_createSign()
            self:_sortInfoItems()
        end
    else
        if typeData.typeId == EMapSearchType.Material or typeData.typeId == EMapSearchType.Goods then
            if self.data.metaId ~= nil then
                self.buildingNameText.text = string.format("%s %s%s", self.data.name, GetLanguage(PlayerBuildingBaseData[self.data.metaId].sizeName), GetLanguage(PlayerBuildingBaseData[self.data.metaId].typeName))
            else
                self.buildingNameText.text = self.data.name
            end
            self.matGoodItem:refreshData(self.data, typeData)

        elseif typeData.typeId == EMapSearchType.Promotion then
            self.buildingNameText.text = string.format("%s %s%s", self.data.name, GetLanguage(PlayerBuildingBaseData[self.data.metaId].sizeName), GetLanguage(PlayerBuildingBaseData[self.data.metaId].typeName))
            self.promotionItem:refreshData(self.data, typeData)

        elseif typeData.typeId == EMapSearchType.Technology then
            self.buildingNameText.text = string.format("%s %s%s", self.data.name, GetLanguage(PlayerBuildingBaseData[self.data.metaId].sizeName), GetLanguage(PlayerBuildingBaseData[self.data.metaId].typeName))
            self.technologyItem:refreshData(self.data, typeData)
        end
    end
end
--
function MapRightOtherBuildingPage:_initPersonalInfo(info)
    local data = info[1]
    if data ~= nil then
        self.nameText.text = data.name
        local trueTextW = self.nameText.preferredWidth
        self.nameText.rectTransform.sizeDelta = Vector2.New(trueTextW, self.nameText.rectTransform.sizeDelta.y)

        self.companyText.text = data.companyName
        --if data.male == true then
        --    self.manIconTran.localScale = Vector3.one
        --    self.femaleIconTran.localScale = Vector3.zero
        --else
        --    self.manIconTran.localScale = Vector3.zero
        --    self.femaleIconTran.localScale = Vector3.one
        --end
        self.avatar = AvatarManger.GetSmallAvatar(data.faceId, self.portraitImg.transform,0.2)
    end
end
--
function MapRightOtherBuildingPage:_sortInfoItems()
    if self.items == nil or #self.items == 0 then
        return
    end
    local pos = Vector3.zero
    for i, item in ipairs(self.items) do
        item:setPos(pos)
        pos.y = pos.y - 66  --66是item的高度+间隔得来的
    end
end
--
function MapRightOtherBuildingPage:_createInfoByType(buildingType)
    if buildingType == BuildingType.House or buildingType == BuildingType.RetailShop then  --签约
        self:_createSign()
    elseif buildingType == BuildingType.Warehouse then
        --self:_createWarehouse()
    end
end
--签约
function MapRightOtherBuildingPage:_createSign()
    local str2 = string.format("<color=%s>E%s</color>/D", MapRightOtherBuildingPage.moneyColor, GetClientPriceString(self.data.price))
    local data2 = {infoTypeStr = "Price", value = str2}  --价格
    self.items[#self.items + 1] = self:_createShowItem(data2, self.simpleShowRoot)

    local str1 = self.data.hours.."h"
    local data1 = {infoTypeStr = "SignTime", value = str1}  --签约时间
    self.items[#self.items + 1] = self:_createShowItem(data1, self.simpleShowRoot)

    local str3 = string.format("%0.2f", self.data.lift * 100).."%"
    local data3 = {infoTypeStr = "SignPromotion", value = str3}  --签约加成
    self.items[#self.items + 1] = self:_createShowItem(data3, self.simpleShowRoot)
end
--仓库
function MapRightOtherBuildingPage:_createWarehouse()
    local str2 = string.format("<color=%s>E%s</color>/h", MapRightOtherBuildingPage.moneyColor, GetClientPriceString(self.data.rent))
    local data2 = {infoTypeStr = "Price", value = str2}  --价格
    self.items[#self.items + 1] = self:_createShowItem(data2, self.simpleShowRoot)

    local str1 = string.format("%dh - %dh", self.data.minHourToRent, self.data.maxHourToRent)
    local data1 = {infoTypeStr = "WarehouseTime", value = str1}  --时间
    self.items[#self.items + 1] = self:_createShowItem(data1, self.simpleShowRoot)

    local str3 = self.data.availableSize
    local data3 = {infoTypeStr = "WarehouseRent", value = str3}  --可用仓位
    self.items[#self.items + 1] = self:_createShowItem(data3, self.simpleShowRoot)
end
--
function MapRightOtherBuildingPage:_createShowItem(data, parentTrans, hasDetail)
    local obj
    if hasDetail == true then
        obj = MapPanel.prefabPools[MapPanel.MapShowInfoHasImgPoolName]:GetAvailableGameObject()
    else
        obj = MapPanel.prefabPools[MapPanel.MapShowInfoPoolName]:GetAvailableGameObject()
    end
    obj.transform:SetParent(parentTrans)
    obj.transform.localScale = Vector3.one
    local item = MapRightShowInfoItem:new(obj)
    item:initData(data)
    return item
end
--
function MapRightOtherBuildingPage:_cleanItems()
    if self.items == nil then
        self.items = {}
        return
    end
    for i, item in pairs(self.items) do
        if item:getIsDetail() == true then
            MapPanel.prefabPools[MapPanel.MapShowInfoHasImgPoolName]:RecyclingGameObjectToPool(item.viewRect.gameObject)
        else
            MapPanel.prefabPools[MapPanel.MapShowInfoPoolName]:RecyclingGameObjectToPool(item.viewRect.gameObject)
        end
        item = nil
    end
    self.items = {}
end

--重置状态
function MapRightOtherBuildingPage:openShow()
    self:_language()
    self.viewRect.anchoredPosition = Vector2.zero
end
--多语言
function MapRightOtherBuildingPage:_language()
    --正式代码
    --self.goHereText01.text = GetLanguage()
    self.goHereText01.text = "Go here"
end
--关闭
function MapRightOtherBuildingPage:close()
    self.viewRect.anchoredPosition = Vector2.New(506, 0)
    self:_cleanItems()
    if self.avatar ~= nil then
        AvatarManger.CollectAvatar(self.avatar)
        self.avatar = nil
    end
    self.technologyItem:close()
    self.promotionItem:close()
    self.matGoodItem:close()
end
--去地图上的一个建筑
function MapRightOtherBuildingPage:_goHereBtn()
    MapBubbleManager.GoHereFunc(self.data.pos)
    local blockId = TerrainManager.GridIndexTurnBlockID(self.data.pos)
    local tempValue = DataManager.GetBaseBuildDataByID(blockId)
    if tempValue ~= nil then
        tempValue:OpenPanel()
        CameraMove.MoveIntoUILayer(blockId)
    end
end