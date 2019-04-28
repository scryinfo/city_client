---
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/3/28 16:30
---

-- 公司、我的土地、土地的详细信息显示
LandInfoItem = class("LandInfoItem")

function LandInfoItem:initialize(prefab, data)
    self.prefab = prefab
    self.data = data

    local transform = prefab.transform
    self.ownerNamText = transform:Find("OwnerNameText"):GetComponent("Text")
    self.rentNameText = transform:Find("RentNameText"):GetComponent("Text")
    self.moneyLineImage = transform:Find("MoneyLineImage")
    self.rentMoneyTitleText = transform:Find("MoneyLineImage/RentMoneyTitleText"):GetComponent("Text")
    self.rentMoneyText = transform:Find("MoneyLineImage/RentMoneyText"):GetComponent("Text")
    self.timeLineImage = transform:Find("TimeLineImage")
    self.rentTimeText = transform:Find("TimeLineImage/RentTimeText"):GetComponent("Text")
    self.goBtn = transform:Find("GoBtn"):GetComponent("Button")

    self.goBtn.onClick:RemoveAllListeners()
    self.goBtn.onClick:AddListener(function ()
        self:_goPos()
    end)

    -- 显示时，先重置他们的状态
    self.ownerNamText.text = ""
    self.rentNameText.text = ""
    self.moneyLineImage.localScale = Vector3.zero
    self.rentMoneyText.text = ""
    self.timeLineImage.localScale = Vector3.zero
    self.rentTimeText.text = ""

    if data.ownerId == DataManager.GetMyOwnerID() then
        if data.rent and data.rent.renterId then -- 已出租
            PlayerInfoManger.GetInfos({data.ownerId}, self._showOwnerName, self)
            PlayerInfoManger.GetInfos({data.rent.renterId}, self._showRenterName, self)
            self.moneyLineImage.localScale = Vector3.one
            self.rentMoneyTitleText.text = "Rental/d"
            self.rentMoneyText.text = GetClientPriceString(data.rent.rentPreDay) -- "租金：" ..
            local timeTable = getFormatUnixTime(data.rent.rentBeginTs/1000 + data.rent.rentDays * 24 * 60 * 60)
            self.timeLineImage.localScale = Vector3.one
            self.rentTimeText.text = timeTable.year .. "/" .. timeTable.month .. "/" ..timeTable.day -- "到期时间：" ..
        elseif data.rent and not data.rent.renterId then -- 出租中
            self.ownerNamText.text = DataManager.GetCompanyName()
            self.rentNameText.text = DataManager.GetCompanyName()
            self.moneyLineImage.localScale = Vector3.one
            self.rentMoneyTitleText.text = "Rental/d"
            self.rentMoneyText.text = GetClientPriceString(data.rent.rentPreDay) -- "租金：" ..
        elseif data.sell then -- 出售中
            self.ownerNamText.text = DataManager.GetCompanyName()
            self.rentNameText.text = DataManager.GetCompanyName()
            self.moneyLineImage.localScale = Vector3.one
            self.rentMoneyTitleText.text = "Price/d"
            self.rentMoneyText.text = GetClientPriceString(data.sell.price) -- "售价：" ..
        else -- 可使用
            self.ownerNamText.text = DataManager.GetCompanyName()
            self.rentNameText.text = DataManager.GetCompanyName()
        end
    else
        if data.rent and data.rent.renterId then  -- 租用中
            PlayerInfoManger.GetInfos({data.ownerId}, self._showOwnerName, self)
            PlayerInfoManger.GetInfos({data.rent.renterId}, self._showRenterName, self)
            self.moneyLineImage.localScale = Vector3.one
            self.rentMoneyTitleText.text = "Rental/d"
            self.rentMoneyText.text = GetClientPriceString(data.rent.rentPreDay) -- "租金：" ..
            local timeTable = getFormatUnixTime(data.rent.rentBeginTs/1000 + data.rent.rentDays * 24 * 60 * 60)
            self.timeLineImage.localScale = Vector3.one
            self.rentTimeText.text = timeTable.year .. "/" .. timeTable.month .. "/" ..timeTable.day -- "到期时间：" ..
        end
    end
end

-- 显示所有者名字
function LandInfoItem:_showOwnerName(playerData)
    self.ownerNamText.text = playerData[1].companyName
end

-- 显示使用者名字
function LandInfoItem:_showRenterName(playerData)
    self.rentNameText.text = playerData[1].companyName
end

-- 跳转到场景上土地的位置
function LandInfoItem:_goPos()
    UIPanel.ClosePage()
    local id = TerrainManager.GridIndexTurnBlockID(self.data)
    local targetPos = TerrainManager.BlockIDTurnPosition(id)
    CameraMove.MoveCameraToPos(targetPos)
end