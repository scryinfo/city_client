---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---Raw material product page
MapMatDetailPageItem = class('MapMatDetailPageItem', MapDetailPageBase)

--Initialization method
function MapMatDetailPageItem:childInit(viewRect)
    self.content = viewRect:Find("scroll/content")
end
--Create items
function MapMatDetailPageItem:createItems()
    self.items = {}
    if self.mapSearchType == EMapSearchType.Material then
        self:_createMatGoodRoot(self.mapSearchType)
    elseif self.mapSearchType == EMapSearchType.Goods then
        self:_createMatGoodRoot(self.mapSearchType)
    end
end
--
function MapMatDetailPageItem:_createMatGoodRoot(type)
    for i, value in pairs(CompoundTypeConfig) do
        if (i < 2250 and type == EMapSearchType.Material) or (i > 2250 and type == EMapSearchType.Goods) then
            local go = UnityEngine.GameObject.Instantiate(MapPanel.mapMatGoodRootItem)
            go.transform:SetParent(self.content.transform)
            go.transform.localScale = Vector3.one
            local data = {mapSearchType = type, detailData = value}
            local item = MapMatGoodRootItem:new(data, go)
            self.items[i] = item
        end
    end
end