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
    this.goodsIcon = transform:Find("playerInfo/goodsIcon"):GetComponent("Image");
    this.playerName = transform:Find("playerInfo/playerName"):GetComponent("Text");
    this.nameText = transform:Find("playerInfo/goodsNameText"):GetComponent("Text");
    this.numberInput = transform:Find("goodsInfo/numberInput"):GetComponent("InputField");
    this.priceInput = transform:Find("goodsInfo/priceInput"):GetComponent("InputField");
    this.priceText = transform:Find("goodsInfo/priceText"):GetComponent("Text");
    this.numberSlider = transform:Find("goodsInfo/numberSlider"):GetComponent("Slider");
end