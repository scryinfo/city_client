SmallProductionLineItem = class('SmallProductionLineItem')

--初始化方法
function SmallProductionLineItem:initialize(goodsDataInfo,prefab,inluabehaviour,mgr,id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour;
    self.manager = mgr;
    self.id = id;

    self.companyNameText = self.prefab.transform:Find("Top/companyNameText"):GetComponent("Text");  --品牌名字
    self.modificationBtn = self.prefab.transform:Find("Top/modificationBtn");  --修改名字
    self.minText = self.prefab.transform:Find("Top/minText"):GetComponent("Text");  --没分钟多少个
    self.nameText = self.prefab.transform:Find("Top/nameText"):GetComponent("Text");  --原料名字
    self.timeText = self.prefab.transform:Find("Top/timeIcon/timeText"):GetComponent("Text");  --时间
    self.time_Slider = self.prefab.transform:Find("Top/time_Slider"):GetComponent("Slider");
    self.XBtn = self.prefab.transform:Find("Top/XBtn");
    self.goodsIcon = self.prefab.transform:Find("goodsIcon");

    self.tipsText = self.prefab.transform:Find("Productionbg/tipsText"):GetComponent("RectTransform");
    self.inputNumber = self.prefab.transform:Find("Productionbg/inputNumber"):GetComponent("InputField");
    self.pNumberScrollbar = self.prefab.transform:Find("Productionbg/numberScrollbar"):GetComponent("Slider");
    self.productionNumber = self.prefab.transform:Find("Productionbg/houseIcon/numberText"):GetComponent("Text");
    self.staffNumberText = self.prefab.transform:Find("Staffbg/numberbg/numberText"):GetComponent("Text");
    self.sNumberScrollbar = self.prefab.transform:Find("Staffbg/numberScrollbar"):GetComponent("Slider");

    self:RefreshUiInfo()

    self.pNumberScrollbar.onValueChanged:AddListener(function()
        self:pNumberScrollbarInfo();
    end)
    self.sNumberScrollbar.onValueChanged:AddListener(function()
        self:sNumberScrollbarInfo();
    end)
    self.inputNumber.onValueChanged:AddListener(function()
        self:inputInfo();
    end)
end
--初始化UI信息
function SmallProductionLineItem:RefreshUiInfo()
    self.nameText.text = self.goodsDataInfo.name
    self.itemId = self.goodsDataInfo.itemId
    self.timeText.text = "00:00:00"
    self.time_Slider.maxValue = 100;
    self.time_Slider.value = 0;
    self.inputNumber.text = 0;
    self.pNumberScrollbar.maxValue = 100;
    self.pNumberScrollbar.value = 0;
    self.productionNumber.text = 0;
    self.staffNumberText.text = 0;
    self.sNumberScrollbar.maxValue = 100;
    self.sNumberScrollbar.value = 0;
end

--刷新滑动条
function SmallProductionLineItem:pNumberScrollbarInfo()
    self.inputNumber.text = self.pNumberScrollbar.value;
end
function SmallProductionLineItem:sNumberScrollbarInfo()
    self.staffNumberText.text = self.sNumberScrollbar.value;
end
--刷新输入框
function SmallProductionLineItem:inputInfo()
    local number = self.inputNumber.text;
    if number ~= "" then
        self.pNumberScrollbar.value = number;
    else
        self.pNumberScrollbar.value = 0;
    end
end