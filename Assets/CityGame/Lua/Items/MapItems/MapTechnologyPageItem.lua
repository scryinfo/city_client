---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---科研二级菜单
MapTechnologyPageItem = class('MapTechnologyPageItem', MapDetailPageBase)

--初始化
function MapTechnologyPageItem:childInit(viewRect)
    self.content = viewRect:Find("scroll/content")
    self.bgImg = viewRect:Find("Image"):GetComponent("Image")
    self.text01 = viewRect:Find("Image/Text"):GetComponent("Text")
end
--创建items
function MapTechnologyPageItem:createItems()
    self.items = {}
    for i, value in ipairs(MapTechnologyInfoConfig) do
        local go = UnityEngine.GameObject.Instantiate(MapPanel.mapTechnologyDetailItem)
        go.transform:SetParent(self.content.transform)
        go.transform.localScale = Vector3.one
        local data = {technologyIndex = i, mapSearchType = EMapSearchType.Technology}
        local item = MapTechnologyDetailItem:new(data, go)
        self.items[i] = item
    end
    self:sortItemPos(self.items)
end
--
function MapTechnologyPageItem:initLanguage()
    --self.text01.text = GetLanguage(12345678)
    self.text01.text = "科研"
    local width = self.text01.preferredWidth + 35
    self.bgImg.rectTransform.sizeDelta = Vector2.New(width, 50)
end
--
function MapTechnologyPageItem:sortItemPos(itemTable)
    if itemTable ~= nil and #itemTable ~= 0 then
        local pos = Vector3.zero
        for i, item in ipairs(itemTable) do
            item:setPos(pos)
            pos = pos - Vector3.New(0, 132, 0)
        end
    end
end