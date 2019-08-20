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
    self.rentText = viewTrans:Find("bg/rent/Text"):GetComponent("Text")
    self.sell = viewTrans:Find("bg/sell")
    self.sellText = viewTrans:Find("bg/sell/Text"):GetComponent("Text")

    self.faceId = 0

    self.playerId = 0

    self.incomeText.text = "E"..GetClientPriceString(dataInfo.cost)
    self.sell.localScale = Vector3.zero
    self.rent.localScale = Vector3.zero
    if dataInfo.buyer == "PLAYER" then
        self.faceId = dataInfo.faceId
        self.playerId = dataInfo.buyerId
        self.head.color = Color.New(0,0,0,0)
        AvatarManger.GetSmallAvatar(self.faceId,self.head.transform,0.125)
        self.name.localScale = Vector3.zero
        if dataInfo.type == "BUY_GROUND" or dataInfo.type == "RENT_GROUND" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/landx1.png", self.picture, true)
            self.pictureText.text = "("..dataInfo.coord[1].x..","..dataInfo.coord[1].y..")"
            if dataInfo.type == "BUY_GROUND" then
                self.sellText.text = GetLanguage(11020001)
                self.sell.localScale = Vector3.one
                self.income.text =  GetLanguage(11010013)
            end
            if dataInfo.type == "RENT_GROUND" then
                self.rentText.text = GetLanguage(11020002)
                self.rent.localScale = Vector3.one
                self.income.text = GetLanguage(11010014)
            end
        elseif dataInfo.type == "INSHELF" then
            self.income.text = GetLanguage(PlayerBuildingBaseData[dataInfo.bid].sizeName) .. GetLanguage(PlayerBuildingBaseData[dataInfo.bid].typeName)
            LoadSprite("Assets/CityGame/Resources/View/iconImg/" .. dataInfo.itemId .. ".png", self.picture)
            self.pictureText.text =  GetLanguage(dataInfo.itemId) .. "X"..dataInfo.count
        elseif dataInfo.type == "PROMO" then
            self.income.text =  GetLanguage(PlayerBuildingBaseData[dataInfo.bid].sizeName) .. GetLanguage(PlayerBuildingBaseData[dataInfo.bid].typeName)
            if dataInfo.itemId == 1300 then
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/icon-supermarket.png", self.picture, true)
                self.pictureText.text =  GetLanguage(42020003) .. "X"..dataInfo.duration .. "h"
            elseif dataInfo.itemId == 1400 then
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/icon-house.png", self.picture, true)
                self.pictureText.text =  GetLanguage(42020004) .. "X"..dataInfo.duration .. "h"
            else
                LoadSprite(Good[dataInfo.itemId].img,self.picture)
                self.pictureText.text =  GetLanguage(dataInfo.itemId) .. "X"..dataInfo.duration .. "h"
            end
        elseif dataInfo.type == "LAB" then
            self.income.text =  GetLanguage(PlayerBuildingBaseData[dataInfo.bid].sizeName) .. GetLanguage(PlayerBuildingBaseData[dataInfo.bid].typeName)
            if dataInfo.itemId == 51 then
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/icon-food.png", self.picture, true)
                self.pictureText.text =  GetLanguage(20030002) .. "X"..dataInfo.duration .. "h"
            elseif dataInfo.itemId == 52 then
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/icon-clothes.png",self.picture, true)
                self.pictureText.text =  GetLanguage(20030001) .. "X"..dataInfo.duration .. "h"
            elseif dataInfo.itemId == 0 then
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/icon-EVA-s.png", self.picture, true)
                self.pictureText.text =  GetLanguage(11010001) .. "X"..dataInfo.duration .. "h"
            end
        end
    elseif dataInfo.buyer == "NPC" then
        self.faceId = 0
        self.playerId = 0
        for i = 0, self.head.transform.childCount-1 do
            destroy(self.head.transform:GetChild(i).gameObject)
        end
        self.head.color = Color.New(255,255,255,255)
        LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/NPC.png", self.head, true)
        self.headName.text = GetLanguage(11010008)
        self.name.localScale = Vector3.one
        if dataInfo.type == "RENT_ROOM" then
            self.income.text = GetLanguage(PlayerBuildingBaseData[dataInfo.bid].sizeName) .. GetLanguage(PlayerBuildingBaseData[dataInfo.bid].typeName)
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/icon-apartment.png", self.picture, true)
            self.pictureText.text = GetLanguage(11010016) .. "X1"
        elseif dataInfo.type == "INSHELF" then
            self.income.text = GetLanguage(PlayerBuildingBaseData[dataInfo.bid].sizeName) .. GetLanguage(PlayerBuildingBaseData[dataInfo.bid].typeName)
            LoadSprite(Good[dataInfo.itemId].img, self.picture)
            self.pictureText.text = GetLanguage(dataInfo.itemId) .. "X".. dataInfo.count
        end
    end
end
