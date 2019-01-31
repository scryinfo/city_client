DETAILSBoxCtrl = class('DETAILSBoxCtrl',UIPanel);
UIPanel:ResgisterOpen(DETAILSBoxCtrl)

local itemId
function DETAILSBoxCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.Normal);
end

function DETAILSBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/DETAILSBoxPanel.prefab";
end

function DETAILSBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

function DETAILSBoxCtrl:Awake(go)
    self.gameObject = go;
    local details = self.gameObject:GetComponent('LuaBehaviour');
    details:AddClick(DETAILSBoxPanel.XBtn.gameObject,self.OnClick_XBtn,self);
    details:AddClick(DETAILSBoxPanel.confirmBtn.gameObject,self.OnClick_confirmBtn,self);
    Event.AddListener("refreshUiInfo",self.RefreshUiInfo,self)

    --
    details:AddClick(DETAILSBoxPanel.infoBtn.gameObject, function ()
        --DETAILSBoxPanel.infoRootBtn.transform.localScale = Vector3.one
        ct.OpenCtrl("FixedTotalScoreCtrl", {pos = DETAILSBoxPanel.infoBtn.transform.position, type = "Goods"})
    end ,self)
    details:AddClick(DETAILSBoxPanel.infoRootBtn.gameObject, function ()
        DETAILSBoxPanel.infoRootBtn.transform.localScale = Vector3.zero
    end ,self)
    DETAILSBoxPanel.priceInput.onValueChanged:AddListener(function(inputValue)
        if inputValue == nil or inputValue == "" then
            return
        end
        if DETAILSBoxPanel.scoreText.transform.localScale == Vector3.zero or self.itemId == nil then
            return
        end

        DETAILSBoxPanel.scoreText.text = self:_getValuableScore(GetServerPriceNumber(tonumber(inputValue)), self.itemId)
    end)
end

function DETAILSBoxCtrl:_getValuableScore(rentPrice, buildingType)
    local value = (1 - (rentPrice / TempBrandConfig[buildingType])) *100
    value = math.floor(value)
    if value <= 0 then
        return "000"
    end
    if value > 0 and value < 10 then
        return "00"..tostring(value)
    end
    if value >= 10 and value < 100 then
        return "0"..tostring(value)
    end
    if value >= 100 then
        return "100"
    end
end

function DETAILSBoxCtrl:Active()
    UIPanel.Active(self)
    DETAILSBoxPanel.name.text = GetLanguage(27010004)
    DETAILSBoxPanel.numberInput.onValueChanged:AddListener(function()
        self:numberInputInfo();
    end)
    DETAILSBoxPanel.numberSlider.onValueChanged:AddListener(function()
        self:numberSliderInfo();
    end)
end

function DETAILSBoxCtrl:OnClick_XBtn(obj)
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
function DETAILSBoxCtrl:Hide()
    --Event.RemoveListener("refreshUiInfo",self.RefreshUiInfo,self)
    UIPanel.Hide(self)
end

function DETAILSBoxCtrl:Refresh()
    --self.obj = self.m_data
    --self.uiInfo = self.m_data.goodsDataInfo
    self.itemId = self.m_data.itemId
    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(self.itemId / 100000) == materialKey then
        DETAILSBoxPanel.playerGoodInfo.localScale = Vector3.zero
        DETAILSBoxPanel.playerMaterialInfo.localScale = Vector3.one
        DETAILSBoxPanel.materialNameText.text = Material[self.itemId].name
        panelMgr:LoadPrefab_A(Material[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                DETAILSBoxPanel.materialIcon.sprite = texture
            end
        end)

        DETAILSBoxPanel.scoreText.transform.localScale = Vector3.zero
        DETAILSBoxPanel.infoBtn.transform.localScale = Vector3.zero
        DETAILSBoxPanel.infoRootBtn.transform.localScale = Vector3.zero
    elseif math.floor(self.itemId / 100000) == goodsKey then
        DETAILSBoxPanel.playerGoodInfo.localScale = Vector3.one
        DETAILSBoxPanel.playerMaterialInfo.localScale = Vector3.zero
        DETAILSBoxPanel.GoodNameText.text = Good[self.itemId].name

        DETAILSBoxPanel.scoreText.transform.localScale = Vector3.one
        DETAILSBoxPanel.infoBtn.transform.localScale = Vector3.one
        DETAILSBoxPanel.infoRootBtn.transform.localScale = Vector3.zero
        --DETAILSBoxPanel.playerName.text =
        --DETAILSBoxPanel.companyNameText.text =
        --DETAILSBoxPanel.headImg =
        panelMgr:LoadPrefab_A(Good[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                DETAILSBoxPanel.goodsIcon.sprite = texture
            end
        end)
    end
    --DETAILSBoxPanel.GoodNameText.text = self.m_data.name
    DETAILSBoxPanel.numberInput.text = self.m_data.num
    DETAILSBoxPanel.numberSlider.maxValue = self.m_data.num
    DETAILSBoxPanel.numberSlider.value = self.m_data.num
    DETAILSBoxPanel.priceInput.text = GetClientPriceString(self.m_data.price)
end
--修改数量价格
function DETAILSBoxCtrl:OnClick_confirmBtn(ins)
    PlayMusEff(1002)
    local number = DETAILSBoxPanel.numberSlider.value
    if DETAILSBoxPanel.priceInput.text == "" or GetServerPriceNumber(DETAILSBoxPanel.priceInput.text) == 0 then
        Event.Brocast("SmallPop", "出价格式小数精度不能低于0.0001",300)
        return
    end
    local price = GetServerPriceNumber(DETAILSBoxPanel.priceInput.text)

    if number ~= ins.m_data.num and price ~= ins.m_data.price then
        local num = ins.m_data.num - number
        Event.Brocast("m_ReqShelfDel",ins.m_data.buildingId,ins.itemId,num)
        Event.Brocast("m_ReqModifyShelf",ins.m_data.buildingId,ins.itemId,number,price);
        UIPanel.ClosePage()
        Event.Brocast("SmallPop",GetLanguage(27010005),300)
        return;
    end
    if number == ins.m_data.num and price == ins.m_data.price then
        UIPanel.ClosePage()
        return;
    end
    if number ~= ins.m_data.num and price == ins.m_data.price then
        local num = ins.m_data.num - number
        Event.Brocast("m_ReqShelfDel",ins.m_data.buildingId,ins.itemId,num)
        UIPanel.ClosePage()
        Event.Brocast("SmallPop",GetLanguage(27010005),300)
        return;
    end
    if number == ins.m_data.num and price ~= ins.m_data.price then
        Event.Brocast("m_ReqModifyShelf",ins.m_data.buildingId,ins.itemId,number,price);
        UIPanel.ClosePage()
        Event.Brocast("SmallPop",GetLanguage(27010005),300)
        return;
    end
end
--刷新滑动条
function DETAILSBoxCtrl:numberInputInfo()
    local number = DETAILSBoxPanel.numberInput.text
    if number ~= "" then
        DETAILSBoxPanel.numberSlider.value = number
    else
        DETAILSBoxPanel.numberSlider.value = 0
    end
end
--刷新输入框
function DETAILSBoxCtrl:numberSliderInfo()
    DETAILSBoxPanel.numberInput.text = DETAILSBoxPanel.numberSlider.value;
end
