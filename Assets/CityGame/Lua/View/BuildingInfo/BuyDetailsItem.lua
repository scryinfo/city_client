BuyDetailsItem = class('BuyDetailsItem')

--初始化方法
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

    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(self.itemId / 100000) == materialKey then
        self.nameText.text = Material[self.itemId].name
        panelMgr:LoadPrefab_A(Material[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.goodsIcon.sprite = texture
            end
        end)
    elseif math.floor(self.itemId / 100000) == goodsKey then
        self.nameText.text = Good[self.itemId].name
        panelMgr:LoadPrefab_A(Good[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.goodsIcon.sprite = texture
            end
        end)
    end
    self.inputNumber.text = 0;
    self.numberScrollbar.maxValue = self.goodsDataInfo.n;
    self.numberScrollbar.value = 0;
    self.moneyText.text = 0;

    --点击事件
    self._luabehaviour:AddClick(self.closeBtn.gameObject,self.OnClick_closeBtn,self);

    self.numberScrollbar.onValueChanged:AddListener(function()
        self:scrollbarInfo();
    end);
    self.inputNumber.onValueChanged:AddListener(function()
        self:inputInfo();
    end);
end
--删除
function BuyDetailsItem:OnClick_closeBtn(ins)
    Event.Brocast("c_tempTabNotGoods",ins.id);
end
--刷新滑动条
function BuyDetailsItem:scrollbarInfo()
    local number = self.numberScrollbar.value;
    self.inputNumber.text = number;
    self.moneyText.text = number * self.goodsDataInfo.price;
end
--刷新输入框
function BuyDetailsItem:inputInfo()
    local number = self.inputNumber.text;
    if number ~= "" then
        self.numberScrollbar.value = number;
        self.moneyText.text = number * self.goodsDataInfo.price;
    else
        self.numberScrollbar.value = 0;
        self.moneyText.text = 0;
    end
end