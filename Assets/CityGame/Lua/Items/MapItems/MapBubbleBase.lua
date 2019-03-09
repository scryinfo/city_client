---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---小地图气泡基类
MapBubbleBase = class('MapBubbleBase')

--
function MapBubbleBase:initialize(data, viewRect)
    self.viewRect = viewRect:GetComponent("RectTransform")
    self.data = data

    Event.AddListener("c_MapBubbleScale", self._changeScale, self)
    self:_childInit()
end

--初始设置设置缩放比以及位置
function MapBubbleBase:setScaleAndPos(scale, pos, sizeDelta)
    if scale ~= nil then
        if scale == 0 then
            scale = 1
        end
        local myScale = 1 / scale
        self.scaleRoot.transform.localScale = Vector3.one * myScale  --设置子物体缩放大小
    end
    if pos ~= nil then
        self.viewRect.anchoredPosition = pos
    end
    if sizeDelta ~= nil then
        self.viewRect.sizeDelta = sizeDelta  --设置父物体大小
        if self.detailShowImg ~= nil then
            self.detailShowImg.enabled = false
        end
    end
end
--
function MapBubbleBase:_changeScale(mapScale)
    if mapScale == 0 or self.scaleRoot == nil then
        return
    end
    local scale = 1 / mapScale
    self.scaleRoot.localScale = Vector3.one * scale
end
--设置显示建筑大小
function MapBubbleBase:toggleShowDetailImg(show)
    if self.detailShowImg == nil then
        return
    end
    if show == true then
        self.detailShowImg.enabled = true
    else
        self.detailShowImg.enabled = false
    end
end
--
function MapBubbleBase:close()
    if self.viewRect ~= nil and self.data.poolName ~= nil then
        MapBubbleManager.recyclingObjToPool(self.data.poolName, self.viewRect.gameObject)
    end
    self.data = nil
    self = nil
end

--
function MapBubbleBase:_childInit() end

