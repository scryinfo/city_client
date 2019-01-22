DetailsItem = class('DetailsItem')

--初始化方法
function DetailsItem:initialize(goodsDataInfo,prefab,inluabehaviour,mgr,id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour;
    self.manager = mgr;
    self.id = id;
    self.itemId = goodsDataInfo.key.id;
    self.goodsIcon = self.prefab.transform:Find("goodsbg/goodsIcon"):GetComponent("Image");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.inputNumber = self.prefab.transform:Find("InputNumber"):GetComponent("InputField");
    self.numberScrollbar = self.prefab.transform:Find("numberScrollbar"):GetComponent("Slider");
    self.averageText = self.prefab.transform:Find("buttombg/moneyText"):GetComponent("Text");
    self.inputPrice = self.prefab.transform:Find("buttombg/InputPrice"):GetComponent("InputField");
    self.closeBtn = self.prefab.transform:Find("closeBtn");

    self.inputPrice.text = 0;
    self.inputNumber.text = 0;
    self.inputNumber.characterLimit = string.len(goodsDataInfo.n)
    self.numberScrollbar.value = 0;
    self.numberScrollbar.minValue = 0;
    self.numberScrollbar.maxValue = goodsDataInfo.n

    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(self.itemId / 100000) == materialKey then
        self.nameText.text = GetLanguage(self.itemId);
        panelMgr:LoadPrefab_A(Material[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.goodsIcon.sprite = texture
            end
        end)
    elseif math.floor(self.itemId / 100000) == goodsKey then
        self.nameText.text = GetLanguage(self.itemId);
        panelMgr:LoadPrefab_A(Good[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.goodsIcon.sprite = texture
            end
        end)
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
function DetailsItem:OnClick_closeBtn(ins)
    PlayMusEff(1002)
    Event.Brocast("c_temporaryifNotGoods", ins.id)
end
--刷新滑动条
function DetailsItem:scrollbarInfo()
    --当前数量
    local number = self.numberScrollbar.value
    self.inputNumber.text = number;
end
--刷新输入框
function DetailsItem:inputInfo()
    local number = self.inputNumber.text
    if number ~= "" then
        self.numberScrollbar.value = number;
    else
        self.numberScrollbar.value = 0;
    end
end