---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---小地图系统建筑
MapSystemItem = class('MapSystemItem')

--初始化方法
function MapSystemItem:initialize(data, viewRect)
    self.viewRect = viewRect:GetComponent("RectTransform")
    self.data = data

    self.btn = self.viewRect.transform:Find("btn"):GetComponent("Button")
    self.iconImg = self.viewRect.transform:Find("btn/bg/protaitImg"):GetComponent("Image")
    self.detailShowImg = self.viewRect.transform:Find("detailShowImg"):GetComponent("Image")  --镜头拉近时显示大小

    self.btn.onClick:AddListener(function ()
        self:_clickFunc()
    end)

    --LoadSprite(data.disSelectIconPath, self.iconImg, true)
    Event.AddListener("c_MapBubbleScale", self._changeScale, self)
end

--
function MapSystemItem:_clickFunc()
    if self.data == nil then
        return
    end
    ct.log("")
end

--初始设置设置缩放比以及位置
function MapSystemItem:setScaleAndPos(scale, pos, sizeDelta)
    if scale ~= nil then
        self.viewRect.transform.localScale = scale
    end
    if pos ~= nil then
        self.viewRect.anchoredPosition = pos
    end
    if sizeDelta ~= nil then
        self.startDelta = sizeDelta
        self.detailShowImg.rectTransform.sizeDelta = sizeDelta
        self.detailShowImg.transform.localScale = scale
        self.detailShowImg.enabled = false
    end
end
--
function MapSystemItem:_changeScale(mapScale)
    if mapScale == 0 or self.viewRect == nil then
        return
    end
    local scale = 1 / mapScale
    self.viewRect.transform.localScale = Vector3.one * scale
    self.detailShowImg.transform.localScale = Vector3.one * mapScale
end
--设置显示建筑大小
function MapSystemItem:toggleShowDetailImg(show)
    if self.detailShowImg == nil then
        return
    end

    if show == true then
        self.detailShowImg.enabled = true
    else
        self.detailShowImg.enabled = false
    end
end