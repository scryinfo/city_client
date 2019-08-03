---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/7/29 11:40
--- 市场数据卡片（仓库卡片）
DataBaseCardItem = class('DataBaseCardItem')

--初始化方法   数据（读配置表）
function DataBaseCardItem:initialize(inluabehaviour, prefab, goodsDataInfo,building,dataType)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.building = building
    self.type = goodsDataInfo.itemKey.id
    self.storeNum = goodsDataInfo.storeNum
    self.lockedNum = goodsDataInfo.lockedNum
    self.dataType = dataType

    self.bg = self.prefab.transform:Find("bg").gameObject
    self.num = self.prefab.transform:Find("num"):GetComponent("Text");
    self.icon = self.prefab.transform:Find("icon/Image"):GetComponent("Image");
    self.name = self.prefab.transform:Find("down/name"):GetComponent("Text");

    if dataType == DataType.DataBase then
        self.num.text = "x" .. (goodsDataInfo.storeNum + goodsDataInfo.lockedNum)
    elseif dataType == DataType.DataSale then
        self.num.text = ""
    end
    self.name.text = GetLanguage(ResearchConfig[goodsDataInfo.itemKey.id].name)
    LoadSprite(ResearchConfig[goodsDataInfo.itemKey.id].iconPath, self.icon, true)
    self._luabehaviour:AddClick(self.bg, self.OnBg, self);

end

function DataBaseCardItem:OnBg(go)
    PlayMusEff(1002)
    if go.dataType == DataType.DataBase then
        local data = {}
        data.wareHouse = go.storeNum
        data.sale = go.lockedNum
        data.itemId = go.type
        data.userFunc = function(num)
            DataManager.DetailModelRpcNoRet(go.building, 'm_userData',go.building,go.type,num)
        end
        ct.OpenCtrl("UserDataCtrl",data)
    elseif go.dataType == DataType.DataSale then
        local data = {}
        data.wareHouse = go.storeNum
        data.sale = go.lockedNum
        data.itemId = go.type
        data.building = go.building
        data.shelf = Shelf.AddShelf
        ct.OpenCtrl("DataShelfCtrl",data)
    end

end