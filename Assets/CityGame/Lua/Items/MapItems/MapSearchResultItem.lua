---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---小地图搜索详情气泡
MapSearchResultItem = class('MapSearchResultItem', MapBubbleBase)

--初始化方法
function MapSearchResultItem:_childInit()
    self.btn = self.viewRect.transform:Find("root/btn"):GetComponent("Button")
    self.protaitImg = self.viewRect.transform:Find("root/bg/protaitImg"):GetComponent("Image")
    self.selfBuildingTran = self.viewRect.transform:Find("root/bg")
    self.selectTran = self.viewRect.transform:Find("root/detailShowImg")
    self.scaleRoot = self.viewRect.transform:Find("root")  --需要缩放的气泡

    self.btn.onClick:AddListener(function ()
        PlayMusEff(1002)
        self:_clickFunc()
    end)

    self:_setPos()
end
--计算位置
function MapSearchResultItem:_setPos()
    if self.data.detailData ~= nil then
        local data
        if self.data.detailData.pos ~= nil then
            data = self.data.detailData
        elseif self.data.detailData.buildingInfo.pos ~= nil then
            data = self.data.detailData.buildingInfo
        else
            return
        end
        local blockID = TerrainManager.GridIndexTurnBlockID(data.pos)
        local tempInfo = DataManager.GetBaseBuildDataByID(blockID)
        if tempInfo ~= nil and tempInfo.Data ~= nil then
            local mId = tempInfo.Data["mId"]
            local delta = self.data.itemWidth *  PlayerBuildingBaseData[mId].x
            self.viewRect.sizeDelta = Vector2.New(delta, delta)
            self.viewRect.transform.localScale = Vector3.one

            if data.ownerId == DataManager.GetMyOwnerID() then
                local type = GetBuildingTypeById(mId)
                local path = MapBubbleManager._getBuildingIconPath(type)
                MapBubbleManager.SetBuildingIconSpite(path, self.protaitImg)
                self.selfBuildingTran.localScale = Vector3.one
                --LoadSprite(path, self.protaitImg, true)
                --self.protaitImg.enabled = true
            else
                --PlayerInfoManger.GetInfos({[1] = data.ownerId}, self._initPersonalInfo, self)
                --self.protaitImg.enabled = false
                self.selfBuildingTran.localScale = Vector3.zero
            end

            self.viewRect.anchoredPosition = Vector2.New(data.pos.y, -data.pos.x) * self.data.itemWidth
            local scale = Vector3.one * (1 / MapCtrl.getCurrentScaleValue())
            self.scaleRoot.transform.localScale = scale

            --self.detailShowImg.transform.localScale = scale
            --self.detailShowImg.rectTransform.sizeDelta = MapCtrl.getCurrentScaleValue() * self.viewRect.sizeDelta
        end
    end
end

--buildingId
function MapSearchResultItem:_clickFunc()
    if self.data == nil then
        return
    end
    MapCtrl.selectCenterItem(self)
    Event.Brocast("c_MapOpenRightOthersPage", self)
end
--
function MapSearchResultItem:_initPersonalInfo(info)
    --local data = info[1]
    --if data ~= nil and self ~= nil and self.data ~= nil then
    --    self.data.playerInfo = data
    --    --self.avatar = AvatarManger.GetSmallAvatar(data.faceId, self.protaitImg.transform,0.1)
    --end
end
