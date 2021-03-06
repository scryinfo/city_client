DETAILSBoxCtrl = class('DETAILSBoxCtrl',UIPanel);
UIPanel:ResgisterOpen(DETAILSBoxCtrl)

local Math_Floor = math.floor
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
    value = Math_Floor(value)
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
    UIPanel.Hide(self)
end

function DETAILSBoxCtrl:Refresh()
    if self.m_data.isOther == true then
        DETAILSBoxPanel.confirmBtn.transform.localScale = Vector3.zero
        DETAILSBoxPanel.numberSlider.interactable = false
        DETAILSBoxPanel.priceInput.interactable = false
        DETAILSBoxPanel.numberInput.interactable = false
    else
        DETAILSBoxPanel.confirmBtn.transform.localScale = Vector3.one
        DETAILSBoxPanel.numberSlider.interactable = true
        DETAILSBoxPanel.priceInput.interactable = true
        DETAILSBoxPanel.numberInput.interactable = true
    end
    self.itemId = self.m_data.itemId
    local materialKey,goodsKey = 21,22
    if Math_Floor(self.itemId / 100000) == materialKey then
        DETAILSBoxPanel.playerGoodInfo.localScale = Vector3.zero
        DETAILSBoxPanel.playerMaterialInfo.localScale = Vector3.one
        DETAILSBoxPanel.materialNameText.text = GetLanguage(Material[self.itemId].name)
        LoadSprite(Material[self.itemId].img,DETAILSBoxPanel.materialIcon,false)
        DETAILSBoxPanel.scoreText.transform.localScale = Vector3.zero
        DETAILSBoxPanel.infoBtn.transform.localScale = Vector3.zero
        DETAILSBoxPanel.infoRootBtn.transform.localScale = Vector3.zero
    elseif Math_Floor(self.itemId / 100000) == goodsKey then
        DETAILSBoxPanel.playerGoodInfo.localScale = Vector3.one
        DETAILSBoxPanel.playerMaterialInfo.localScale = Vector3.zero
        DETAILSBoxPanel.GoodNameText.text = Good[self.itemId].name
        DETAILSBoxPanel.scoreText.transform.localScale = Vector3.one
        DETAILSBoxPanel.infoBtn.transform.localScale = Vector3.one
        DETAILSBoxPanel.infoRootBtn.transform.localScale = Vector3.zero
        --DETAILSBoxPanel.playerName.text =
        --DETAILSBoxPanel.companyNameText.text =
        --DETAILSBoxPanel.headImg =
        LoadSprite(Good[self.itemId].img,DETAILSBoxPanel.goodsIcon,false)
    end
    --DETAILSBoxPanel.GoodNameText.text = self.m_data.name
    DETAILSBoxPanel.numberInput.text = self.m_data.num
    DETAILSBoxPanel.numberSlider.maxValue = self.m_data.num
    DETAILSBoxPanel.numberSlider.value = self.m_data.num
    DETAILSBoxPanel.priceInput.text = GetClientPriceString(self.m_data.price)
end
--Modify quantity price
function DETAILSBoxCtrl:OnClick_confirmBtn(ins)
    PlayMusEff(1002)
    local number = DETAILSBoxPanel.numberSlider.value
    if DETAILSBoxPanel.priceInput.text == "" or GetServerPriceNumber(DETAILSBoxPanel.priceInput.text) == 0 then
        Event.Brocast("SmallPop", GetLanguage(22030003),300)
        return
    end
    local price = GetServerPriceNumber(DETAILSBoxPanel.priceInput.text)
    --If it is currently a raw material factory
    if ins.m_data.buildingType == 1 then
        if number ~= ins.m_data.num and price ~= ins.m_data.price then
            local num = ins.m_data.num - number
            Event.Brocast("m_ReqMaterialShelfDel",ins.m_data.buildingId,ins.itemId,num)
            Event.Brocast("m_ReqMaterialModifyShelf",ins.m_data.buildingId,ins.itemId,number,price);
            UIPanel.ClosePage()
            return
        end
        if number == ins.m_data.num and price == ins.m_data.price then
            UIPanel.ClosePage()
            return
        end
        if number ~= ins.m_data.num and price == ins.m_data.price then
            local num = ins.m_data.num - number
            Event.Brocast("m_ReqMaterialShelfDel",ins.m_data.buildingId,ins.itemId,num)
            UIPanel.ClosePage()
            return
        end
        if number == ins.m_data.num and price ~= ins.m_data.price then
            Event.Brocast("m_ReqMaterialModifyShelf",ins.m_data.buildingId,ins.itemId,number,price);
            UIPanel.ClosePage()
            return
        end
        --If it is a processing plant
    elseif ins.m_data.buildingType == 4 then
        if number ~= ins.m_data.num and price ~= ins.m_data.price then
            local num = ins.m_data.num - number
            Event.Brocast("m_ReqProcessShelfDel",ins.m_data.buildingId,ins.itemId,num,ins.m_data.goodsDataInfo.k.producerId,ins.m_data.goodsDataInfo.k.qty)
            Event.Brocast("m_ReqProcessModifyShelf",ins.m_data.buildingId,ins.itemId,number,price,ins.m_data.goodsDataInfo.k.producerId,ins.m_data.goodsDataInfo.k.qty);
            UIPanel.ClosePage()
            return
        end
        if number == ins.m_data.num and price == ins.m_data.price then
            UIPanel.ClosePage()
            return
        end
        if number ~= ins.m_data.num and price == ins.m_data.price then
            local num = ins.m_data.num - number
            Event.Brocast("m_ReqProcessShelfDel",ins.m_data.buildingId,ins.itemId,num,ins.m_data.goodsDataInfo.k.producerId,ins.m_data.goodsDataInfo.k.qty)
            UIPanel.ClosePage()
            return
        end
        if number == ins.m_data.num and price ~= ins.m_data.price then
            Event.Brocast("m_ReqProcessModifyShelf",ins.m_data.buildingId,ins.itemId,number,price,ins.m_data.goodsDataInfo.k.producerId,ins.m_data.goodsDataInfo.k.qty);
            UIPanel.ClosePage()
            return
        end
    elseif ins.m_data.buildingType == 6 then
        if number ~= ins.m_data.num and price ~= ins.m_data.price then
            local num = ins.m_data.num - number
            Event.Brocast("m_ReqRetailShelfDel",ins.m_data.buildingId,ins.itemId,num,ins.m_data.goodsDataInfo.k.producerId,ins.m_data.goodsDataInfo.k.qty)
            Event.Brocast("m_ReqRetailModifyShelf",ins.m_data.buildingId,ins.itemId,number,price,ins.m_data.goodsDataInfo.k.producerId,ins.m_data.goodsDataInfo.k.qty);
            UIPanel.ClosePage()
            return
        end
        if number == ins.m_data.num and price == ins.m_data.price then
            UIPanel.ClosePage()
            return
        end
        if number ~= ins.m_data.num and price == ins.m_data.price then
            local num = ins.m_data.num - number
            Event.Brocast("m_ReqRetailShelfDel",ins.m_data.buildingId,ins.itemId,num,ins.m_data.goodsDataInfo.k.producerId,ins.m_data.goodsDataInfo.k.qty)
            UIPanel.ClosePage()
            return
        end
        if number == ins.m_data.num and price ~= ins.m_data.price then
            Event.Brocast("m_ReqRetailModifyShelf",ins.m_data.buildingId,ins.itemId,number,price,ins.m_data.goodsDataInfo.k.producerId,ins.m_data.goodsDataInfo.k.qty);
            UIPanel.ClosePage()
            return
        end
    end
end
--Refresh slider
function DETAILSBoxCtrl:numberInputInfo()
    local number = DETAILSBoxPanel.numberInput.text
    if number ~= "" then
        DETAILSBoxPanel.numberSlider.value = number
    else
        DETAILSBoxPanel.numberSlider.value = 0
    end
end
--Refresh the input box
function DETAILSBoxCtrl:numberSliderInfo()
    DETAILSBoxPanel.numberInput.text = DETAILSBoxPanel.numberSlider.value;
end
