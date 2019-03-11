---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---
MapDetailPageItem = class('MapDetailPageItem')

--初始化方法
function MapDetailPageItem:initialize(mapSearchType, viewRect)
    self.viewRect = viewRect
    self.content = viewRect.transform:Find("scroll/content")
    self.mapSearchType = mapSearchType
    self:_createItems()
end
--重置状态
function MapDetailPageItem:resetState()
    if self.items ~= nil then
        for i, value in pairs(self.items) do
            value:resetState()
        end
    end
end
--创建items
function MapDetailPageItem:_createItems()
    self.items = {}
    if self.mapSearchType == EMapSearchType.Material then
        self:_createMatGoodRoot(self.mapSearchType)
    elseif self.mapSearchType == EMapSearchType.Goods then
        self:_createMatGoodRoot(self.mapSearchType)
    end
end
--
function MapDetailPageItem:_createMatGoodRoot(type)
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
--
function MapDetailPageItem:getTypeId()
    return self.mapSearchType
end
--
function MapDetailPageItem:toggleState(open)
    if open == true then
        self.viewRect.transform.localScale = Vector3.one
    else
        self.viewRect.transform.localScale = Vector3.zero
    end
end