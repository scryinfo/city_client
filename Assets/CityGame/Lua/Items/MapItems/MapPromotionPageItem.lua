---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---推广二级菜单
MapPromotionPageItem = class('MapPromotionPageItem', MapDetailPageBase)

--初始化
function MapPromotionPageItem:childInit(viewRect)
    self.content = viewRect:Find("scroll/content")
    self.bgImg = viewRect:Find("Image"):GetComponent("Image")
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
    self:sortItemPos(self.items)
end
--
function MapPromotionPageItem:initLanguage()
    --self.text01.text = GetLanguage(12345678)
    self.text01.text = "推广"
    local width = self.text01.preferredWidth + 35
    self.bgImg.rectTransform.sizeDelta = Vector2.New(width, 50)
end
--
function MapPromotionPageItem:sortItemPos(itemTable)
    if itemTable ~= nil and #itemTable ~= 0 then
        local pos = Vector3.zero
        for i, item in ipairs(itemTable) do
            item:setPos(pos)
            pos = pos - Vector3.New(0, 132, 0)
        end
    end
end