---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---推广二级菜单
MapPromotionPageItem = class('MapPromotionPageItem', MapDetailPageBase)

--初始化
function MapPromotionPageItem:childInit(viewRect)
    self.content = viewRect:Find("scroll/content")
    self.text01 = viewRect:Find("Image/Text"):GetComponent("Text")
end
--创建items
function MapPromotionPageItem:createItems()
    self.items = {}
    for i, value in ipairs(MapPromotionInfoConfig) do
        local go = UnityEngine.GameObject.Instantiate(MapPanel.mapPromotionDetailItem)
        go.transform:SetParent(self.content.transform)
        go.transform.localScale = Vector3.one
        local data = {promotionIndex = i, mapSearchType = EMapSearchType.Promotion}
        local item = MapPromotionDetailItem:new(data, go)
        self.items[i] = item
    end
end
--
function MapPromotionPageItem:initLanguage()
    self.text01.text = GetLanguage(12345678)
end