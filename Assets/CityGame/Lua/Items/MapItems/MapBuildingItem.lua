---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---小地图建筑气泡
MapBuildingItem = class('MapBuildingItem', MapBubbleBase)

--初始化方法
function MapBuildingItem:_childInit()
    self.btn = self.viewRect.transform:Find("selfRoot/btn"):GetComponent("Button")
    self.buildingIcon = self.viewRect.transform:Find("selfRoot/btn/buildingIcon"):GetComponent("Image")
    self.detailShowImg = self.viewRect.transform:Find("detailShowImg"):GetComponent("Image")
    self.scaleRoot = self.viewRect.transform:Find("selfRoot")

    self.btn.onClick:AddListener(function ()
        self:_clickFunc()
    end)

    if self.data.tempPath ~= "" then
        LoadSprite(self.data.tempPath, self.buildingIcon, true)  --建筑icon
    end
end

--不同建筑的点击效果不同
--需要buildingId
function MapBuildingItem:_clickFunc()
    if self.data == nil then
        return
    end

    if self.data.buildingType == BuildingType.House then

    elseif self.data.buildingType == BuildingType.MaterialFactory then

    end
end