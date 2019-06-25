---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---点击其他人推广建筑
MapRightOtherPromotePage = class('MapRightOtherPromotePage')
MapRightOtherPromotePage.moneyColor = "#F4AD07FF"

--初始化方法
function MapRightOtherPromotePage:initialize(viewRect)
    self.viewTrans = viewRect.transform

    self.showInfoRoot = self.viewTrans:Find("showInfoRoot")
    self.iconImg = self.viewTrans:Find("abilityRoot/iconImg"):GetComponent("Image")
    self.infoText = self.viewTrans:Find("abilityRoot/infoText"):GetComponent("Text")
    self.text01 = self.viewTrans:Find("abilityRoot/Text01"):GetComponent("Text")
    self.valueText = self.viewTrans:Find("abilityRoot/valueText"):GetComponent("Text")
end
--
function MapRightOtherPromotePage:refreshData(data, typeData)
    self.viewTrans.localScale = Vector3.one
    self.data = data

    local promotType = {}
    for i, key in pairs(self.data.typeIds) do
        promotType[key] = self.data.CurAbilitys[i]
    end
    if typeData.typeId == EMapSearchType.Promotion then
        local type1 = MapPromotionConfig[typeData.detailId]
        local value = promotType[type1]
        local infoData = MapPromotionInfoConfig[typeData.detailId]

        LoadSprite(infoData.imgPath, self.iconImg, true)
        self.iconImg.color = getColorByVector3(infoData.colorV3)
        self.infoText.text = GetLanguage(MapPromotionInfoConfig[typeData.detailId].languageId)
        self.valueText.text = "+"..value.."/"..GetLanguage(20100003)

        self:_language()
        self:_createPromotion()
        self:_sortInfoItems()
    end
end
--
function MapRightOtherPromotePage:_sortInfoItems()
    if self.items == nil or #self.items == 0 then
        return
    end
    local pos = Vector3.zero
    for i, item in ipairs(self.items) do
        item:setPos(pos)
        pos.y = pos.y - 66  --66是item的高度+间隔得来的
    end
end
--推广
function MapRightOtherPromotePage:_createPromotion()
    local str2 = string.format("<color=%s>E%s</color>/%s", MapRightOtherPromotePage.moneyColor, GetClientPriceString(self.data.pricePerHour), GetLanguage(20150004))
    local data2 = {infoTypeStr = "Price", value = str2}  --价格
    self.items[#self.items + 1] = self:_createShowItem(data2, self.showInfoRoot)

    local str1 = self.data.remainTime / 3600000 ..GetLanguage(20100003)
    local data1 = {infoTypeStr = "PromotionTime", value = str1}  --时间
    self.items[#self.items + 1] = self:_createShowItem(data1, self.showInfoRoot)

    local str3
    if self.data.queuedTimes ~= -1 then
        str3 = os.date("%H:%M %m/%d/%Y", self.data.queuedTimes / 1000)
    else
        --str3 = os.date("%H:%M %m/%d/%Y", os.time())
        str3 = GetLanguage(27040032)
    end
    local data3 = {infoTypeStr = "Queued", value = str3}  --
    self.items[#self.items + 1] = self:_createShowItem(data3, self.showInfoRoot)
end
--
function MapRightOtherPromotePage:_createShowItem(data, parentTrans, hasDetail)
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
function MapRightOtherPromotePage:_cleanItems()
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
--多语言
function MapRightOtherPromotePage:_language()
    self.text01.text = GetLanguage(20130004)
end
--关闭
function MapRightOtherPromotePage:close()
    self:_cleanItems()
    self.viewTrans.localScale = Vector3.zero
end