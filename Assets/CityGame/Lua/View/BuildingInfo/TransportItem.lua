TransportItem = class('TransportItem')

--初始化方法
function TransportItem:initialize(goodsDataInfo,prefab,inluabehaviour,mgr,id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour;
    self.manager = mgr;
    self.id = id;
    self.goodsIcon = self.prefab.transform:Find("goodsbg/goodsIcon");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.inputNumber = self.prefab.transform:Find("InputNumber"):GetComponent("InputField");
    self.numberScrollbar = self.prefab.transform:Find("numberScrollbar"):GetComponent("Slider");
    self.closeBtn = self.prefab.transform:Find("closeBtn");

    self.inputNumber.text = 0;
    self.inputNumber.characterLimit = string.len(goodsDataInfo.number)
    self.numberScrollbar.value = 0;
    self.numberScrollbar.minValue = 0;
    self.numberScrollbar.maxValue = goodsDataInfo.number
    self.nameText.text = goodsDataInfo.name

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
    Event.Brocast("c_temporaryifNotGoods",ins.id);
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