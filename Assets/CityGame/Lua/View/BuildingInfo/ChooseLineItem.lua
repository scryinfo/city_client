---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/12/18 18:21
---路线面板
local class = require 'Framework/class'
require('Framework/UI/UIPage')
ChooseLineItem = class('ChooseLineItem')

--初始化方法   数据（读配置表）
function ChooseLineItem:initialize(prefab,mgr,DataInfo,pos)
    self.prefab = prefab;
    self.buildingId = DataInfo.info.id;
    self.manager = mgr;
    self.posX =  DataInfo.info.pos.x
    self.posY =  DataInfo.info.pos.y
    self.manager = mgr;
    self.state = DataInfo.info.state

    self.bg = self.prefab.transform:Find("bg").gameObject:GetComponent("Button");
    self.name = self.prefab.transform:Find("factory/name").gameObject:GetComponent("Text");
    self.factory = self.prefab.transform:Find("factory").gameObject:GetComponent("Text");
    self.size = self.prefab.transform:Find("smallbg/small").gameObject:GetComponent("Text");
    self.houseIcon = self.prefab.transform:Find("transportDetails/houseIcon"):GetComponent("Image");
    self.warehouse_Slider = self.prefab.transform:Find("icon/Warehouse_Slider"):GetComponent("Slider");
    self.number = self.prefab.transform:Find("icon/number").gameObject:GetComponent("Text");
    self.distance = self.prefab.transform:Find("transportDetails/distance/distanceText").gameObject:GetComponent("Text");
    self.money = self.prefab.transform:Find("transportDetails/money/moneyText").gameObject:GetComponent("Text");

    self.factory.text = DataInfo.info.name

    local n = 0
    if DataInfo.info.mId == nil then
        self.size.text =GetLanguage(21030007)
        self.name.text = GetLanguage(21030008)
        local bagCapacity = DataManager.GetBagCapacity()  --仓库总容量
        self.warehouse_Slider.maxValue = bagCapacity
        n = DataManager.GetBagNum()      --仓库内物品数量
        self.spareCapacity = bagCapacity - n --剩余容量
        self.number.text = n .. "/" .. bagCapacity
    else
        self.name.text = GetLanguage(PlayerBuildingBaseData[DataInfo.info.mId].typeName)
        self.size.text = GetLanguage(PlayerBuildingBaseData[DataInfo.info.mId].sizeName)
        self.warehouse_Slider.maxValue = PlayerBuildingBaseData[DataInfo.info.mId].storeCapacity;
        if DataInfo.store.inHand == nil then
            n = 0
        else
            for i, v in pairs(DataInfo.store.inHand) do
                n = n + v.n
            end
        end
        if  DataInfo.store.locked ~= nil then
            for i, v in pairs(DataInfo.store.locked) do
                n = n + v.n
            end
        end
        self.spareCapacity = PlayerBuildingBaseData[DataInfo.info.mId].storeCapacity - n --剩余容量
        self.number.text = n .. "/" .. PlayerBuildingBaseData[DataInfo.info.mId].storeCapacity
    end

    self.sizeName = self.factory.text.. self.size.text..self.name.text

    local distances
    distances = math.sqrt(math.pow((pos.x-self.posX),2) + math.pow((pos.y-self.posY),2))
    self.distance.text = math.floor(distances).."km"
    local moneys = distances * BagPosInfo[1].postageCost
    self.money.text = "E"..GetClientPriceString(moneys).."/1"
    self.price = moneys

    --图片
    --local type = ct.getType(UnityEngine.Sprite)
    --panelMgr:LoadPrefab_A(PlayerBuildingBaseData[DataInfo.info.mId]["imgPath"],type,nil,function(goodData,obj)
    --    if obj ~= nil then
    --        local texture = ct.InstantiatePrefab(obj)
    --        self.houseIcon.sprite = texture
    --    end
    --end)

    self.num = n
    self.warehouse_Slider.value = n
    self.bg.onClick:AddListener(function()
        self:OnLinePanelBG(self);
    end)
end

function ChooseLineItem:OnLinePanelBG(go)
    if go.posX ~= 51 then
        if go.state ~= "OPERATE"  then
            Event.Brocast("SmallPop",GetLanguage(21030009),300)
            return
        end
    end
    go.manager:TransportConfirm(go.isOnClick )
    -- [[  点击使其可以运输
    go.manager:_onClick()
    go.manager:TransportConfirm()
    -- ]]
    local data = {}
    data.buildingId = go.buildingId
    data.posX = go.posX
    data.posY = go.posY
    data.name =  go.sizeName
    data.spareCapacity = go.spareCapacity
    data.price = go.price
    Event.Brocast("c_OnLinePanelBG",data)
    ChooseWarehouseCtrl:OnClick_returnBtn()
end