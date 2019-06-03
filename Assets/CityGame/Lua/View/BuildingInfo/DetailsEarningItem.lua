---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/1/31 14:23
---收益详情item
DetailsEarningItem = class('DetailsEarningItem')
--初始化方法
function DetailsEarningItem:initialize(dataInfo, viewRect,id)
    self.dataInfo = dataInfo
    self.viewRect = viewRect
    self.id = id
    local viewTrans = self.viewRect

    self.head = viewTrans:Find("bg/headImage/head"):GetComponent("Image")  --头像
    self.headName = viewTrans:Find("bg/headImage/name"):GetComponent("Text")  --头像
    self.income = viewTrans:Find("bg/income"):GetComponent("Text")
    self.name = viewTrans:Find("bg/headImage/name")        --名字
    self.incomeText = viewTrans:Find("bg/incomeText"):GetComponent("Text")   --收益金额
    self.picture = viewTrans:Find("bg/picture"):GetComponent("Image")         --图片
    self.pictureText = viewTrans:Find("bg/picture/pictureText"):GetComponent("Text")   --图片内容
    self.rent = viewTrans:Find("bg/rent")
    self.sell = viewTrans:Find("bg/sell")

    self.income.text = GetLanguage(17010002)

    self.faceId = 0

    self.playerId = 0

    self.incomeText.text = "E"..GetClientPriceString(dataInfo.cost)
    self.sell.localScale = Vector3.zero
    self.rent.localScale = Vector3.zero
    if dataInfo.buyer == "PLAYER" then
        self.faceId = dataInfo.faceId
        self.playerId = dataInfo.buyerId
        self.head.color = Color.New(0,0,0,0)
        --LoadSprite(PlayerHead[self.faceId].earningsPath, self.head, true)
        AvatarManger.GetSmallAvatar(self.faceId,self.head.transform,0.125)
        self.name.localScale = Vector3.zero
        if dataInfo.type == "BUY_GROUND" or dataInfo.type == "RENT_GROUND" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/landx1.png", self.picture, true)
            self.pictureText.text = "("..dataInfo.coord[1].x..","..dataInfo.coord[1].y..")"
            if dataInfo.type == "BUY_GROUND" then
                self.sell.localScale = Vector3.one
            end
            if dataInfo.type == "RENT_GROUND" then
                self.rent.localScale = Vector3.one
            end
        elseif dataInfo.type == "INSHELF" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/goods/"..dataInfo.itemId..".png", self.picture)
            self.pictureText.text = "X"..dataInfo.counte
        elseif dataInfo.type == "PROMO" then
            if dataInfo.itemId == 1300 then
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/icon-ad.png", self.picture, true)
            elseif dataInfo.itemId == 1400 then
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/icon-ad.png", self.picture, true)
            else
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/goods/"..dataInfo.itemId..".png",self.picture)
            end
            self.pictureText.text = "X"..dataInfo.duration .. "h"
        elseif dataInfo.type == "LAB" then
            self.sell.localScale = Vector3.zero
            self.rent.localScale = Vector3.zero
            if dataInfo.itemId then
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/goods/"..dataInfo.itemId..".png", GameMainInterfacePanel.simplePicture)
            end
            self.pictureText.text = "X"..dataInfo.duration .. "h"
        end
    elseif dataInfo.buyer == "NPC" then
        self.faceId = 0
        self.playerId = 0
        for i = 0, self.head.transform.childCount-1 do
            destroy(self.head.transform:GetChild(i).gameObject)
        end
        self.head.color = Color.New(255,255,255,255)
        LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/NPC.png", self.head, true)
        self.headName.text = GetLanguage(11020006)
        self.name.localScale = Vector3.one
        if dataInfo.type == "RENT_ROOM" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/icon-apartment.png", self.picture, true)
            self.pictureText.text = "X1"
        elseif dataInfo.type == "INSHELF" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/goods/"..dataInfo.itemId..".png", self.picture)
            self.pictureText.text = "X"..dataInfo.count
        end
    end
end
