---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---
MapMatGoodRootItem = class('MapMatGoodRootItem')
MapMatGoodRootItem.static.TitleHeight = 68  --类型标题的高度

--初始化方法
function MapMatGoodRootItem:initialize(data, viewRect)
    self.viewRect = viewRect
    self.data = data

    self.detailRoot = self.viewRect.transform:Find("detailRoot")
    self.typeNameText = self.viewRect.transform:Find("bg/typeNameText"):GetComponent("Text")
    self.bgImg = self.viewRect.transform:Find("bg"):GetComponent("Image")
    self.element = self.viewRect.transform:GetComponent("LayoutElement")

    self:_createItems()
    self:_language()
end
--重置状态
function MapMatGoodRootItem:resetState()
    self:_language()
    for i, value in pairs(self.items) do
        value:resetState()
    end
end
--多语言
function MapMatGoodRootItem:_language()
    self.typeNameText.text = GetLanguage(self.data.detailData[1].name)
    local width = self.typeNameText.preferredWidth + 35
    self.bgImg.rectTransform.sizeDelta = Vector2.New(width, 50)
end
--
function MapMatGoodRootItem:_createItems()
    self.items = {}
    local count = 0
    for i, value in ipairs(self.data.detailData) do
        count = count + 1
        local go = UnityEngine.GameObject.Instantiate(MapPanel.mapMatGoodSearchItem)
        go.transform:SetParent(self.detailRoot.transform)
        go.transform.localScale = Vector3.one
        local data = {itemId = value.itemId, mapSearchType = self.data.mapSearchType}
        self.items[value.itemId] = MapMatGoodSearchItem:new(data, go)
    end

    local h = 138 * math.ceil(count / 4)
    self.element.preferredHeight = h + 68
end