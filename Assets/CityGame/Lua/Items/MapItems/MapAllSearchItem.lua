---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---小地图全局搜索结果
MapAllSearchItem = class('MapAllSearchItem')

--初始化方法
function MapAllSearchItem:initialize(data, viewRect)
    self.viewRect = viewRect:GetComponent("RectTransform")
    self.data = data

    self.btn = self.viewRect.transform:Find("btn"):GetComponent("Button")
    self.countText = self.viewRect.transform:Find("btn/Text"):GetComponent("Text")
    self.countText.text = self.data.num

    Event.AddListener("c_MapBubbleScale", self._changeScale, self)

    self.btn.onClick:AddListener(function ()
        self:_clickFunc()
    end)
end

--放大到临界值
function MapAllSearchItem:_clickFunc()
    if self.data == nil then
        return
    end

end

--设置缩放比以及位置
function MapAllSearchItem:setScaleAndPos(scale, pos)
    if scale ~= nil then
        self.viewRect.transform.localScale = Vector3.one * scale
    end
    if pos ~= nil then
        self.viewRect.anchoredPosition = pos
    end
end
--
function MapAllSearchItem:_changeScale(mapScale)
    if mapScale == 0 or self.viewRect == nil then
        return
    end
    local scale = 1 / mapScale
    self.viewRect.transform.localScale = Vector3.one * scale
end
--
function MapAllSearchItem:close()
    if self.viewRect ~= nil and self.data.poolName ~= nil then
        MapBubbleManager.recyclingObjToPool(self.data.poolName, self.viewRect.gameObject)
    end
    self.data = nil
    self = nil
end