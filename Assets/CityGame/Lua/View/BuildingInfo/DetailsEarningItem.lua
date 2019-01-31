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
    self.name = viewTrans:Find("bg/headImage/name")        --名字
    self.incomeText = viewTrans:Find("bg/incomeText"):GetComponent("Text")   --收益金额
    self.picture = viewTrans:Find("bg/picture"):GetComponent("Image")         --图片
    self.pictureText = viewTrans:Find("bg/picture/pictureText"):GetComponent("Text")   --图片内容
    self.rent = viewTrans:Find("bg/rent")
    self.sell = viewTrans:Find("bg/sell")

    self.faceId = 0

    self.playerId = 0

    self.incomeText.text = "E"..GetClientPriceString(dataInfo.cost)
    if dataInfo.buyer == "PLAYER" then
        self.faceId = dataInfo.faceId
        self.playerId = dataInfo.buyerId
        LoadSprite(PlayerHead[self.faceId].earningsPath, self.head, true)
        self.name.localScale = Vector3.zero
        if dataInfo.type == "BUY_GROUND" or dataInfo.type == "RENT_GROUND" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/icon-apartment.png", self.picture, true)
            self.pictureText.text = "("..dataInfo.coord[1].x..","..dataInfo.coord[1].y..")"
            if dataInfo.type == "BUY_GROUND" then
                self.sell.localScale = Vector3.one
            end
            if dataInfo.type == "RENT_GROUND" then
                self.rent.localScale = Vector3.one
            end
        elseif dataInfo.type == "INSHELF" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/goods/"..dataInfo.itemId..".png", self.picture)
            self.pictureText.text = "X"..dataInfo.count
        end
    elseif dataInfo.buyer == "NPC" then
        self.playerId = 0
        LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/NPC.png", self.head, true)
        if dataInfo.type == "RENT_ROOM" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/icon-apartment.png", self.picture, true)
            self.pictureText.text = "X1"
        elseif dataInfo.type == "INSHELF" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/goods/"..dataInfo.itemId..".png", self.picture)
            self.pictureText.text = "X"..dataInfo.count
        end
    end
    --if self.faceId ~= 0 then
    --    self.head:GetComponent("Button").onClick:AddListener(function ()
    --        self:_OnHeadBtn(self)
    --    end)
    --end
end

function DetailsEarningItem:_OnHeadBtn(go)
    if go.playerId ~= 0 then
       Event.Brocast("m_GetFriendInfo",go.playerId)
    end
end