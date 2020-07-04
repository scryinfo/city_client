---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---Construction bubble
MapBuildingItem = class('MapBuildingItem', MapBubbleBase)

--Initialization method
function MapBuildingItem:_childInit()
    self.btn = self.viewRect.transform:Find("selfRoot/btn"):GetComponent("Button")
    self.buildingIcon = self.viewRect.transform:Find("selfRoot/btn/buildingIcon"):GetComponent("Image")
    self.selectTran = self.viewRect.transform:Find("selfRoot/btn/selectImg")
    self.detailShowImg = self.viewRect.transform:Find("detailShowImg"):GetComponent("Image")
    self.detailShowBtn = self.viewRect.transform:Find("detailShowImg"):GetComponent("Button")
    self.scaleRoot = self.viewRect.transform:Find("selfRoot")

    self.btn.onClick:AddListener(function ()
        PlayMusEff(1002)
        self:_clickFunc()
    end)
    self.detailShowBtn.onClick:AddListener(function ()
        PlayMusEff(1002)
        self:_clickFunc()
    end)

    if self.data.tempPath ~= "" then
        MapBubbleManager.SetBuildingIconSpite(self.data.tempPath, self.buildingIcon)
        --LoadSprite(self.data.tempPath, self.buildingIcon, true)  --Building icon
        self.selectTran.localScale = Vector3.zero
    end
end

--Different buildings have different click effects
--Requires buildingId
function MapBuildingItem:_clickFunc()
    if self.data == nil then
        return
    end
    MapCtrl.selectCenterItem(self)
    Event.Brocast("c_MapSelectSelfBuildingPage", self)
end
--Set display building size
function MapBuildingItem:toggleShowDetailImg(show)
    if self.detailShowImg == nil then
        return
    end
    if show == true then
        self.detailShowImg.enabled = true
    else
        self.detailShowImg.enabled = false
    end
end