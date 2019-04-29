---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---土地交易
MapRightGroundTransPage = class('MapRightGroundTransPage', MapRightPageBase)

--初始化方法
function MapRightGroundTransPage:initialize(viewRect)
    self.viewRect = viewRect:GetComponent("RectTransform")

    self.nameText = viewRect:Find("root/nameBg/nameText"):GetComponent("Text")
    self.closeBtn = viewRect:Find("root/closeBtn"):GetComponent("Button")
    self.ownerBtn = viewRect:Find("root/ownerBtn"):GetComponent("Button")
    self.portraitImg = viewRect:Find("root/ownerBtn/portraitImg")

    self.sellRoot = viewRect:Find("root/sellRoot")
    self.sellPriceText = viewRect:Find("root/sellRoot/sellPriceText"):GetComponent("Text")

    self.rentRoot = viewRect:Find("root/rentRoot")
    self.dayRentalText = viewRect:Find("root/rentRoot/rentalText"):GetComponent("Text")
    self.rentDayText = viewRect:Find("root/rentRoot/rentDayText"):GetComponent("Text")
    self.goHereBtn = viewRect:Find("root/goHereBtn"):GetComponent("Button")

    self.titleText01 = viewRect:Find("root/titleText"):GetComponent("Text")
    self.sellPriceText02 = viewRect:Find("root/sellRoot/Text"):GetComponent("Text")
    self.tenancyText03 = viewRect:Find("root/rentRoot/Text01"):GetComponent("Text")
    self.rentalText04 = viewRect:Find("root/rentRoot/Text02"):GetComponent("Text")

    self.closeBtn.onClick:AddListener(function ()
        self:close()
    end)
    self.ownerBtn.onClick:AddListener(function ()
        self:_clickPlayerInfoBtn()
    end)
    self.goHereBtn.onClick:AddListener(function ()
        self:_goHereBtn()
    end)
end
--
function MapRightGroundTransPage:refreshData(data)
    self.viewRect.anchoredPosition = Vector2.zero
    self.data = data

    local groundInfo = DataManager.GetGroundDataByID(self.data.detailData.blockId).Data
    PlayerInfoManger.GetInfos({[1] = groundInfo.ownerId}, self._initPersonalInfo, self)

    if data.detailData.groundState == GroundTransState.Sell then
        self.sellRoot.localScale = Vector3.one
        self.rentRoot.localScale = Vector3.zero
        self.sellPriceText.text = "E"..getPriceString(GetClientPriceString(groundInfo.sell.price), 24, 20)
    elseif data.detailData.groundState == GroundTransState.Rent then
        self.rentRoot.localScale = Vector3.one
        self.sellRoot.localScale = Vector3.zero
        self.rentDayText.text = groundInfo.rent.rentDaysMin.."-"..groundInfo.rent.rentDaysMax
        self.dayRentalText.text = "E"..getPriceString(GetClientPriceString(groundInfo.rent.rentPreDay), 24, 20)
    end
    self:openShow()
end
--重置状态
function MapRightGroundTransPage:openShow()
    self:_language()
    self.viewRect.anchoredPosition = Vector2.zero
end
--多语言
function MapRightGroundTransPage:_language()
    self.titleText01.text = GetLanguage(24040002)
    self.sellPriceText02.text = GetLanguage(24040004)
    self.tenancyText03.text = GetLanguage(24050005)
    self.rentalText04.text = GetLanguage(24050006)
end
--关闭
function MapRightGroundTransPage:close()
    self.viewRect.anchoredPosition = Vector2.New(506, 0)
    if self.avatar ~= nil then
        AvatarManger.CollectAvatar(self.avatar)
    end
end
--去地图上的一个建筑
function MapRightGroundTransPage:_goHereBtn()
    local tempServerPos = TerrainManager.BlockIDTurnPosition(self.data.detailData.blockId)
    local temp = {x = tempServerPos.x, y = tempServerPos.z}
    MapBubbleManager.GoHereFunc(temp)
end
--
function MapRightGroundTransPage:_initPersonalInfo(info)
    local data = info[1]
    if data ~= nil then
        self.nameText.text = data.name
        self.avatar = AvatarManger.GetSmallAvatar(data.faceId, self.portraitImg.transform,0.2)
        self.data.playerInfo = data
    end
end
--
function MapRightGroundTransPage:_clickPlayerInfoBtn()
    if self.data.playerInfo == nil then
        return
    end
    ct.OpenCtrl("PersonalHomeDialogPageCtrl", self.data.playerInfo)
end