TransportItem = class('TransportItem')

local Math_Floor = math.floor
--初始化方法
function TransportItem:initialize(goodsDataInfo,prefab,inluabehaviour,id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour;
    self.id = id;
    self.itemId = goodsDataInfo.key.id;
    self.goodsIcon = self.prefab.transform:Find("goodsbg/goodsIcon"):GetComponent("Image");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.inputNumber = self.prefab.transform:Find("InputNumber"):GetComponent("InputField");
    self.numberScrollbar = self.prefab.transform:Find("numberScrollbar"):GetComponent("Slider");
    self.closeBtn = self.prefab.transform:Find("closeBtn");

    self.inputNumber.text = 0;
    self.inputNumber.characterLimit = string.len(goodsDataInfo.n)
    self.numberScrollbar.value = 0;
    self.numberScrollbar.minValue = 0;
    self.numberScrollbar.maxValue = goodsDataInfo.n
    self.nameText.text = GetLanguage(self.itemId);

    local materialKey,goodsKey = 21,22
    if Math_Floor(self.itemId / 100000) == materialKey then
        LoadSprite(Material[self.itemId].img,self.goodsIcon,false)
    elseif Math_Floor(self.itemId / 100000) == goodsKey then
        LoadSprite(Good[self.itemId].img,self.goodsIcon,false)
    end
    self.numberScrollbar.onValueChanged:AddListener(function ()
        self:scrollbarInfo();
    end)
    self.inputNumber.onValueChanged:AddListener(function ()
        self:inputInfo();
    end)
    self._luabehaviour:AddClick(self.closeBtn.gameObject,self.OnClick_closeBtn,self);
end
--删除
function TransportItem:OnClick_closeBtn(ins)
    PlayMusEff(1002)
    Event.Brocast("SelectedGoodsItem",ins);
end
--刷新滑动条
function TransportItem:scrollbarInfo()
    --当前数量
    local number = self.numberScrollbar.value
    self.inputNumber.text = number;
end
--刷新输入框
function TransportItem:inputInfo()
    local number = self.inputNumber.text
    if number ~= "" then
        self.numberScrollbar.value = number;
    else
        self.numberScrollbar.value = 0;
    end
end