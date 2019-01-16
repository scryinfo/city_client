local transform;
local gameObject;

DETAILSBoxPanel = {};
local this = DETAILSBoxPanel;

function DETAILSBoxPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function DETAILSBoxPanel.InitPanel()
    this.XBtn = transform:Find("XBtn");
    this.confirmBtn = transform:Find("confirmBtn");
    --商品
    this.playerGoodInfo = transform:Find("playerGoodInfo");
    this.goodsIcon = transform:Find("playerGoodInfo/goodsIcon"):GetComponent("Image");
    this.playerName = transform:Find("playerGoodInfo/playerName"):GetComponent("Text");
    this.GoodNameText = transform:Find("playerGoodInfo/goodsNameText"):GetComponent("Text");
    this.companyNameText = transform:Find("playerGoodInfo/companyNamebg/companyNameText"):GetComponent("Text");
    this.headImg = transform:Find("playerGoodInfo/headImg"):GetComponent("Image")
    --原料
    this.playerMaterialInfo = transform:Find("playerMaterialInfo");
    this.materialNameText = transform:Find("playerMaterialInfo/infoBg/materialNameText"):GetComponent("Text");
    this.materialIcon = transform:Find("playerMaterialInfo/infoBg/materialIcon"):GetComponent("Image");
    --通用
    this.numberInput = transform:Find("goodsInfo/numberInput"):GetComponent("InputField");
    this.priceInput = transform:Find("goodsInfo/priceInput"):GetComponent("InputField");
    this.priceText = transform:Find("goodsInfo/priceText"):GetComponent("Text");
    this.numberSlider = transform:Find("goodsInfo/numberSlider"):GetComponent("Slider");
end