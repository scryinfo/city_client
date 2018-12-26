RetailGoodsItem = class('RetailGoodsItem')

--初始化
function RetailGoodsItem:initialize(goodsDataInfo,prefab,inluabehaviour,id)
    self.id = id;
    self.prefab = prefab;
    self.inluabehaviour = inluabehaviour;
    self.goodsDataInfo = goodsDataInfo;

    self.shelfImg = self.prefab.transform:Find("shelfImg").gameObject;
    self.goodsicon = self.prefab.transform:Find("details/goodsicon"):GetComponent("Image");
    self.nameText = self.prefab.transform:Find("details/nameText"):GetComponent("Text");
    self.numberText = self.prefab.transform:Find("details/numberText"):GetComponent("Text");
    self.icon = self.prefab.transform:Find("details/icon"):GetComponent("Image");
    self.brandName = self.prefab.transform:Find("details/brandName/brandNameText"):GetComponent("Text");
    self.brandValue = self.prefab.transform:Find("details/brandValue/brandValueText"):GetComponent("Text");
    self.qualityValue = self.prefab.transform:Find("details/qualityValue/qualityValueText"):GetComponent("Text");
    self.moneyText = self.prefab.transform:Find("moneyImg/moneyText"):GetComponent("Text");
    self.detailsBtn = self.prefab.transform:Find("detailsBtn");
    self.XBtn = self.prefab.transform:Find("XBtn");

    --UI信息赋值
    self.nameText.text = self.goodsDataInfo.name
    self.numberText.text = self.goodsDataInfo.number
    self.brandName.text = self.goodsDataInfo.brandName
    self.brandValue.text = self.goodsDataInfo.brandValue
    self.qualityValue.text = self.goodsDataInfo.qualityValue
    self.moneyText.text = "E"..self.goodsDataInfo.price..".0000"

end