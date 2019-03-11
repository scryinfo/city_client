---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---小地图搜索详情气泡
MapSearchResultItem = class('MapSearchResultItem', MapBubbleBase)

--初始化方法
function MapSearchResultItem:_childInit()
    self.btn = self.viewRect.transform:Find("btn"):GetComponent("Button")
    self.detailShowImgBtn = self.viewRect.transform:Find("detailShowImg"):GetComponent("Button")
    self.protaitImg = self.viewRect.transform:Find("btn/bg/protaitImg"):GetComponent("Image")
    self.detailShowImg = self.viewRect.transform:Find("detailShowImg"):GetComponent("Image")
    self.scaleRoot = self.viewRect.transform:Find("btn")  --需要缩放的气泡
    self:toggleShowDetailImg(false)  --开始的时候隐藏

    self.detailShowImgBtn.onClick:AddListener(function ()
        self:_clickFunc()
    end)
    self.btn.onClick:AddListener(function ()
        self:_clickFunc()
    end)

    self:_setPos()
end
--计算位置
function MapSearchResultItem:_setPos()
    if self.data.detailData ~= nil and self.data.detailData.pos ~= nil then
        local data = self.data.detailData

        local blockID = TerrainManager.GridIndexTurnBlockID(data.pos)
        local tempInfo = DataManager.GetBaseBuildDataByID(blockID)
        if tempInfo ~= nil and tempInfo.Data ~= nil then
            local buildingBase = {}
            buildingBase.pos = data.pos
            buildingBase.buildingId = tempInfo.Data["id"]
            buildingBase.ownerId = tempInfo.Data["ownerId"]
            buildingBase.name = tempInfo.Data["name"]

            PlayerInfoManger.GetInfosOneByOne({[1] = buildingBase.ownerId}, self._initPersonalInfo, self)
            if tempInfo.Data["mId"] ~= nil then
                buildingBase.mId = tempInfo.Data["mId"]
                local delta = self.data.itemWidth *  PlayerBuildingBaseData[buildingBase.mId].x
                self.viewRect.sizeDelta = Vector2.New(delta, delta)
                self.viewRect.transform.localScale = Vector3.one
            end
            self.viewRect.anchoredPosition = Vector2.New(data.pos.y, -data.pos.x) * self.data.itemWidth
            local scale = Vector3.one * (1 / MapCtrl.getCurrentScaleValue())
            self.scaleRoot.transform.localScale = scale

            self.detailShowImg.transform.localScale = scale
            self.detailShowImg.rectTransform.sizeDelta = MapCtrl.getCurrentScaleValue() * self.viewRect.sizeDelta
            self.data.buildingBase = buildingBase
        end
    end
end

--buildingId
function MapSearchResultItem:_clickFunc()
    if self.data == nil then
        return
    end
    Event.Brocast("c_MapOpenRightMatPage", self)
end
--
function MapSearchResultItem:_initPersonalInfo(data)
    if data ~= nil then
        self.data.playerInfo = data
        self.avatar = AvatarManger.GetSmallAvatar(data.faceId, self.protaitImg.transform,0.1)
    end
end
