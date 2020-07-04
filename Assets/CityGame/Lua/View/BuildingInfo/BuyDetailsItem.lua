BuyDetailsItem = class('BuyDetailsItem')

local Math_Floor = math.floor
--Initialization method
function BuyDetailsItem:initialize(goodsDataInfo,prefab,inluabehaviour,id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.id = id;
    self.itemId = self.goodsDataInfo.k.id;
    self.goodsIcon = self.prefab.transform:Find("goodsbg/goodsIcon"):GetComponent("Image");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.inputNumber = self.prefab.transform:Find("InputNumber"):GetComponent("InputField");
    self.numberScrollbar = self.prefab.transform:Find("numberScrollbar"):GetComponent("Slider");
    self.tipMoneyText = self.prefab.transform:Find("buttombg/tipMoneyText"):GetComponent("Text");
    self.moneyText = self.prefab.transform:Find("buttombg/moneyImg/moneyText"):GetComponent("Text");
    self.closeBtn = self.prefab.transform:Find("closeBtn");

    self.inputNumber.characterLimit = string.len(goodsDataInfo.n)

    local materialKey,goodsKey = 21,22
    if Math_Floor(self.itemId / 100000) == materialKey then
        LoadSprite(Material[self.itemId].img,self.goodsIcon,false)
    elseif Math_Floor(self.itemId / 100000) == goodsKey then
        LoadSprite(Good[self.itemId].img,self.goodsIcon,false)
    end
    self.nameText.text = GetLanguage(self.itemId);
    self.inputNumber.text = 0;
    self.numberScrollbar.maxValue = self.goodsDataInfo.n;
    self.numberScrollbar.value = 0;
    self.moneyText.text = 0;

    --Click event
    self._luabehaviour:AddClick(self.closeBtn.gameObject,self.OnClick_closeBtn,self);

    self.numberScrollbar.onValueChanged:AddListener(function()
        self:scrollbarInfo();
    end);
    self.inputNumber.onValueChanged:AddListener(function()
        self:inputInfo();
    end);
end
--delete
function BuyDetailsItem:OnClick_closeBtn(ins)
    PlayMusEff(1002)
    Event.Brocast("SelectedGoodsItem",ins);
end
--Refresh slider
function BuyDetailsItem:scrollbarInfo()
    local number = self.numberScrollbar.value;
    self.inputNumber.text = number;
    self.tempPrice = GetClientPriceString(number * self.goodsDataInfo.price)
    self.moneyText.text = getPriceString(GetClientPriceString(number * self.goodsDataInfo.price),39,35);
end
--Refresh the input box
function BuyDetailsItem:inputInfo()
    local number = self.inputNumber.text;
    if number ~= "" then
        self.numberScrollbar.value = number;
        self.tempPrice = GetClientPriceString(number * self.goodsDataInfo.price)
        self.moneyText.text = getPriceString(GetClientPriceString(number * self.goodsDataInfo.price),39,35);
    else
        self.numberScrollbar.value = 0;
        self.moneyText.text = 0;
    end
end