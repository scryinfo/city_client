---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---点击其他人研究所
MapRightOtherTechnologyPage = class('MapRightOtherTechnologyPage')
MapRightOtherTechnologyPage.moneyColor = "#F4AD07FF"
MapRightOtherTechnologyPage.successNum = 1000

--初始化方法
function MapRightOtherTechnologyPage:initialize(viewRect)
    self.viewTrans = viewRect.transform

    self.showInfoRoot = self.viewTrans:Find("showInfoRoot")
    self.iconImg = self.viewTrans:Find("abilityRoot/bg/iconImg"):GetComponent("Image")
    self.infoText = self.viewTrans:Find("abilityRoot/bg/Image/infoText"):GetComponent("Text")
end
--
function MapRightOtherTechnologyPage:refreshData(data, typeData)
    self.viewTrans.localScale = Vector3.one
    self.data = data

    if typeData.typeId == EMapSearchType.Technology then
        --根据类型更换Icon / 多语言
        if self.data.metaId ~= nil then
            for i, value in pairs(MapTechnologyInfoConfig) do --比较傻的做法
                if value.type == self.data.metaId then
                    self.infoText.text = GetLanguage(value.languageId)
                    LoadSprite(value.imgPath, self.iconImg, false)
                end
            end
        end
        self:_createTech()
        self:_sortInfoItems()
    end
end
--
function MapRightOtherTechnologyPage:_sortInfoItems()
    if self.items == nil or #self.items == 0 then
        return
    end
    local pos = Vector3.zero
    for i, item in ipairs(self.items) do
        item:setPos(pos)
        pos.y = pos.y - 66  --66是item的高度+间隔得来的--TODO：//参数调整
    end
end
--科研
function MapRightOtherTechnologyPage:_createTech()
    --数量
    local str1 = self.data.sale.count
    local data1 = {infoTypeStr = "TechnologyQuantity", value = str1}  --数量
    self.items[#self.items + 1] = self:_createShowItem(data1, self.showInfoRoot)
    --价格
    local str2 = string.format("<color=%s>E%s</color>/", MapRightOtherPromotePage.moneyColor, GetClientPriceString(self.data.sale.price))
    local data2 = {infoTypeStr = "Price", value = str2}  --价格
    self.items[#self.items + 1] = self:_createShowItem(data2, self.showInfoRoot)
    --竞争力
    local str3 = ct.CalculationLaboratoryCompetitivePower(self.data.sale.guidePrice,self.data.sale.price,self.data.typeIds)
    local data3 = {infoTypeStr = "CompetitivePower", value = str3}  --竞争力
    self.items[#self.items + 1] = self:_createShowItem(data3, self.showInfoRoot)
end
--
function MapRightOtherTechnologyPage:_createShowItem(data, parentTrans, hasDetail)
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
function MapRightOtherTechnologyPage:_cleanItems()
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

--关闭
function MapRightOtherTechnologyPage:close()
    self:_cleanItems()
    self.viewTrans.localScale = Vector3.zero
end