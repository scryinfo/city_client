---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/8/13 10:39
---城市信息titleItem
CityInfoTitleItem = class('CityInfoTitleItem')
local lastBg
local titleGoodsItem = {}
local titleInfoItem = {}
local prefabs = {}

--初始化方法   数据（读配置表）
function CityInfoTitleItem:initialize(inluabehaviour, prefab, goodsDataInfo,msg)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.msg = msg
    self.id = goodsDataInfo.id
    self.type = goodsDataInfo.type

    self.notSelect = self.prefab.transform:Find("notSelectBg").gameObject
    self.notSelectText = self.prefab.transform:Find("notSelectBg/Text"):GetComponent("Text");
    self.select = self.prefab.transform:Find("selectBg")
    self.selectText = self.prefab.transform:Find("selectBg/Text"):GetComponent("Text");

    self.notSelect.transform.localScale = Vector3.one
    self.select.localScale = Vector3.zero

    self.notSelectText.text = goodsDataInfo.name
    self.selectText.text = goodsDataInfo.name

    self._luabehaviour:AddClick(self.notSelect, self.OnNotSelect, self);
end

function CityInfoTitleItem:OnNotSelect(go)
    if lastBg then
        lastBg.notSelect.transform.localScale = Vector3.one
        lastBg.select.localScale = Vector3.zero
    end
    go.notSelect.transform.localScale = Vector3.zero
    go.select.localScale = Vector3.one
    lastBg = go

    go:ShowPanel(go)
end

function CityInfoTitleItem:SetLast(ins)
    lastBg = ins
end

function CityInfoTitleItem:GetLast()
    return lastBg
end

function CityInfoTitleItem:ShowPanel(data)
    CityInfoPanel.four.gameObject:SetActive(false)
    CityInfoPanel.five.gameObject:SetActive(false)
    CityInfoPanel.six.gameObject:SetActive(false)
    if data.id == 1 then
        DataManager.DetailModelRpcNoRet(data.msg.msg.m_data.insId, 'm_querySupplyAndDemand',data.type)  --查询行业供需
        CityInfoPanel.supplyDemandBg.localScale = Vector3.one
        CityInfoPanel.twoContent:SetActive(false)
        CityInfoPanel.rankList.localScale = Vector3.zero
        CityInfoPanel.twoContent:SetActive(false)
        CityInfoPanel.shelves.localScale = Vector3.one
        CityInfoPanel.purchases.localScale = Vector3.one
        CityInfoPanel.eva.localScale = Vector3.zero
    elseif data.id == 2 then
        DataManager.DetailModelRpcNoRet(data.msg.msg.m_data.insId, 'm_queryIndustryTopInfo',data.msg.msg.ownerId,data.type)  --查询收入排行
        CityInfoPanel.supplyDemandBg.localScale = Vector3.zero
        CityInfoPanel.twoContent:SetActive(false)
        CityInfoPanel.rankList.localScale = Vector3.one
        CityInfoPanel.twoContent:SetActive(false)
        if data.type == 20 then
            CityInfoPanel.four.gameObject:SetActive(true)
        elseif data.type ==11 or data.type ==15 or data.type ==16 then
            CityInfoPanel.five.gameObject:SetActive(true)
        elseif data.type ==12 or data.type ==13 or data.type ==14 then
            CityInfoPanel.six.gameObject:SetActive(true)
        end
    elseif data.id == 3 then            --详情
        DataManager.DetailModelRpcNoRet(data.msg.msg.m_data.insId, 'm_queryItemSales',data.type,data.goodsDataInfo.inside[1].itemId)  --查询营业额
        if data.type == 11 or data.type == 12 or data.type == 13 then
            CityInfoPanel.productIcon.sprite = SpriteManager.GetSpriteByPool(data.goodsDataInfo.inside[1].itemId)
        end
        CityInfoPanel.productText.text = data.goodsDataInfo.inside[1].name
        if data.goodsDataInfo.inside[1].date then
            if #prefabs < #data.goodsDataInfo.inside[1].date then
                for i = 1, #data.goodsDataInfo.inside[1].date - #prefabs do
                    local temp = createPrefabs(CityInfoPanel.productTitleInfoItem,CityInfoPanel.productContent)
                    table.insert(prefabs,temp)
                end
            elseif #prefabs > #data.goodsDataInfo.inside[1].date then
                for i = 1, #prefabs - #data.goodsDataInfo.inside[1].date do
                    destroy(prefabs[#prefabs].gameObject)
                    table.remove(prefabs)
                end
            end
            for i, v in ipairs(data.goodsDataInfo.inside[1].date) do
                titleInfoItem[i] = TitleInfoItem:new(self._luabehaviour,prefabs[i],v,data.goodsDataInfo.inside[1].itemId,data.type,data.msg.msg.m_data.insId)
            end
            titleInfoItem[1]:ShowPanel(titleInfoItem[1])
        end
        CityInfoPanel.twoContent:SetActive(true)
        CityInfoPanel.supplyDemandBg.localScale = Vector3.zero
        CityInfoPanel.rankList.localScale = Vector3.zero
        self:Close()
        if data.goodsDataInfo.inside then
            for i, v in ipairs(data.goodsDataInfo.inside) do
                local prefab = createPrefabs(CityInfoPanel.productsListTitleGoodsItem,CityInfoPanel.productsListContent)
                titleGoodsItem[i] = TitleGoodsItem:new(self._luabehaviour,prefab,v,self,titleInfoItem,data.type,data.msg.msg.m_data.insId)
            end
        end
        CityInfoPanel.productContent.localPosition = Vector3.zero
    elseif data.id == 4 then
        DataManager.DetailModelRpcNoRet(data.msg.msg.m_data.insId, 'm_queryEvaGrade',data.type,data.type,2)  --获取Eva分布
        CityInfoPanel.supplyDemandBg.localScale = Vector3.one
        CityInfoPanel.twoContent:SetActive(false)
        CityInfoPanel.rankList.localScale = Vector3.zero
        CityInfoPanel.shelves.localScale = Vector3.zero
        CityInfoPanel.purchases.localScale = Vector3.zero
        CityInfoPanel.eva.localScale = Vector3.one
    elseif data.id == 5 then
        CityInfoPanel.supplyDemandBg.localScale = Vector3.one
        CityInfoPanel.twoContent:SetActive(false)
        CityInfoPanel.rankList.localScale = Vector3.zero
        CityInfoPanel.shelves.localScale = Vector3.zero
        CityInfoPanel.purchases.localScale = Vector3.zero
        CityInfoPanel.eva.localScale = Vector3.zero
        local bool
        if data.type == 14 then
            bool = true
        elseif data.type == 20 then
            bool = false
        end
        DataManager.DetailModelRpcNoRet(data.msg.msg.m_data.insId, 'm_queryAvgPrice',bool)  --查询收入排行
    end
end

function CityInfoTitleItem:Close()
    if next(titleGoodsItem) then
        for i, v in pairs(titleGoodsItem) do
            destroy(v.prefab.gameObject)
        end
        titleGoodsItem[1]:Close()
        titleGoodsItem = {}
    end
end