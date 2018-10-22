---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/22 17:54
---
require "Common/define"

local transform

ExchangeTransactionPanel = {};
local this = ExchangeTransactionPanel;

function ExchangeTransactionPanel.Awake(obj)
    transform = obj.transform;

    this.InitPanel();
end

function ExchangeTransactionPanel.InitPanel()
    this.backBtn = transform:Find("topRoot/backBtn");
    this.buyScroll = transform:Find("bodyRoot/left/buy/scroll"):GetComponent("ActiveLoopScrollRect");
    this.sellScroll = transform:Find("bodyRoot/left/sell/scroll"):GetComponent("ActiveLoopScrollRect");
    this.itemIconImg = transform:Find("bodyRoot/left/center/icon"):GetComponent("Image");  --item信息
    this.itemNameText = transform:Find("bodyRoot/left/center/name"):GetComponent("Text");
    this.changeText = transform:Find("bodyRoot/left/center/changeText"):GetComponent("Text");
    this.newestPriceText = transform:Find("bodyRoot/left/center/priceText"):GetComponent("Text");
    this.buyBtn = transform:Find("bodyRoot/right/top/buyBtn");  --买卖按钮
    this.buyBtnCloseTran = transform:Find("bodyRoot/right/top/buyBtn/close");
    this.sellBtn = transform:Find("bodyRoot/right/top/sellBtn");
    this.sellBtnCloseTran = transform:Find("bodyRoot/right/top/sellBtn/close");

    this.buyRoot = transform:Find("bodyRoot/right/top/buyRoot");
    this.buyCountInput = transform:Find("bodyRoot/right/top/buyRoot/countInput"):GetComponent("InputField");
    this.buyPriceInput = transform:Find("bodyRoot/right/top/buyRoot/priceInput"):GetComponent("InputField");
    this.buyChooseBtn = transform:Find("bodyRoot/right/top/buyRoot/chooseRoot/chooseBtn");
    this.buyChooseTipTran = transform:Find("bodyRoot/right/top/buyRoot/chooseRoot/tipText");  --提示请选择仓库
    this.buyChooseText = transform:Find("bodyRoot/right/top/buyRoot/chooseRoot/chooseText"):GetComponent("Text");  --选择完仓库之后的显示
    this.sellRoot = transform:Find("bodyRoot/right/top/sellRoot");
    this.sellCountInput = transform:Find("bodyRoot/right/top/sellRoot/countInput"):GetComponent("InputField");
    this.sellPriceInput = transform:Find("bodyRoot/right/top/sellRoot/priceInput"):GetComponent("InputField");
    this.sellChooseBtn = transform:Find("bodyRoot/right/top/sellRoot/chooseRoot/chooseBtn");
    this.sellChooseTipTran = transform:Find("bodyRoot/right/top/sellRoot/chooseRoot/tipText");  --提示请选择仓库
    this.sellChooseText = transform:Find("bodyRoot/right/top/sellRoot/chooseRoot/chooseText");  --选择完仓库之后的显示

    this.calculateText = transform:Find("bodyRoot/right/bottom/calculateText"):GetComponent("Text");  --单价x总量得到的值
    this.serviceText = transform:Find("bodyRoot/right/bottom/serviceText"):GetComponent("Text");  --手续费
    this.totalText = transform:Find("bodyRoot/right/bottom/bg02/totalText"):GetComponent("Text");  --总价格
    this.confirmBtn = transform:Find("bodyRoot/right/bottom/confirmBtn");
    this.confirmBtnShowTran = transform:Find("bodyRoot/right/bottom/confirmBtn/show");
end
--与数据无关的初始化设置
function ExchangeTransactionPanel._initPanel()
    this.calculateText.text = "0"
    this.serviceText.text = "0"
    this.totalText.text = "0"
    this._openBuy()

    this.buyCountInput.text = ""
    this.buyPriceInput.text = ""
    this.buyChooseText.transform.localScale = Vector3.zero
    this.buyChooseTipTran.localScale = Vector3.one
    this.sellCountInput.text = ""
    this.sellPriceInput.text = ""
    this.sellChooseText.transform.localScale = Vector3.zero
    this.sellChooseTipTran.localScale = Vector3.one
end

--打开关闭买卖界面
function ExchangeTransactionPanel._openBuy()
    this.buyBtnCloseTran.localScale = Vector3.zero
    this.buyRoot.localScale = Vector3.one
    this.sellBtnCloseTran.localScale = Vector3.one
    this.sellRoot.localScale = Vector3.zero
end
function ExchangeTransactionPanel._openSell()
    this.sellBtnCloseTran.localScale = Vector3.zero
    this.sellRoot.localScale = Vector3.one
    this.buyBtnCloseTran.localScale = Vector3.one
    this.buyRoot.localScale = Vector3.zero
end