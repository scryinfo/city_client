DetailsItem = class('DetailsItem')

local Math_Floor = math.floor
--Initialization method
function DetailsItem:initialize(goodsDataInfo,prefab,inluabehaviour,id)
    self.prefab = prefab
    self.goodsDataInfo = goodsDataInfo
    self._luabehaviour = inluabehaviour
    self.id = id
    self.itemId = goodsDataInfo.key.id
    self.goodsIcon = self.prefab.transform:Find("goodsbg/goodsIcon"):GetComponent("Image")
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text")
    self.inputNumber = self.prefab.transform:Find("InputNumber"):GetComponent("InputField")
    self.numberScrollbar = self.prefab.transform:Find("numberScrollbar"):GetComponent("Slider")
    --self.averageText = self.prefab.transform:Find("buttombg/moneyText"):GetComponent("Text")
    self.inputPrice = self.prefab.transform:Find("buttombg/InputPrice"):GetComponent("InputField")
    self.closeBtn = self.prefab.transform:Find("closeBtn")
    self.ToggleBtn = self.prefab.transform:Find("ToggleBtn"):GetComponent("Toggle")

    --Total score
    self.scoreRootTrans = self.prefab.transform:Find("buttombg/scoreRoot")
    self.scoreText = self.prefab.transform:Find("buttombg/scoreRoot/totalScore/scoreText"):GetComponent("Text")
    self.infoBtn = self.prefab.transform:Find("buttombg/scoreRoot/infoBtn")

    self.inputPrice.text = 0
    self.inputNumber.text = 0
    self.inputNumber.characterLimit = string.len(goodsDataInfo.n)
    self.numberScrollbar.value = 0
    self.numberScrollbar.minValue = 0
    self.numberScrollbar.maxValue = goodsDataInfo.n
    self.nameText.text = GetLanguage(self.itemId)
    self.ToggleBtn.isOn = false

    local materialKey,goodsKey = 21,22
    self.inputPrice.onValueChanged:RemoveAllListeners()
    if Math_Floor(self.itemId / 100000) == materialKey then
        LoadSprite(Material[self.itemId].img,self.goodsIcon,false)
        self.scoreRootTrans.transform.localScale = Vector3.zero
    elseif Math_Floor(self.itemId / 100000) == goodsKey then
        self.scoreText.text = self:_getValuableScore(GetServerPriceNumber(0), self.itemId)
        LoadSprite(Good[self.itemId].img,self.goodsIcon,false)
        self.scoreRootTrans.transform.localScale = Vector3.one
        self.inputPrice.onValueChanged:AddListener(function (inputValue)
            if inputValue == nil or inputValue == "" then
                return
            end
            self.scoreText.text = self:_getValuableScore(GetServerPriceNumber(tonumber(inputValue)), self.itemId)
        end)
    end

    self.numberScrollbar.onValueChanged:AddListener(function ()
        self:scrollbarInfo()
    end)
    self.inputNumber.onValueChanged:AddListener(function ()
        self:inputInfo()
    end)
    self.ToggleBtn.onValueChanged:AddListener(function()
        self:SendMessage()
    end)
    self._luabehaviour:AddClick(self.closeBtn.gameObject,self.OnClick_closeBtn,self)
    self._luabehaviour:AddClick(self.infoBtn.gameObject, function ()
        ct.OpenCtrl("FixedTotalScoreCtrl", {pos = self.infoBtn.transform.position, type = "Goods"})
    end ,self)
end
--delete
function DetailsItem:OnClick_closeBtn(ins)
    PlayMusEff(1002)
    Event.Brocast("SelectedGoodsItem", ins)
end
--Refresh slider
function DetailsItem:scrollbarInfo()
    --Current quantity
    local number = self.numberScrollbar.value
    self.inputNumber.text = number
end
--Refresh the input box
function DetailsItem:inputInfo()
    local number = self.inputNumber.text
    if number ~= "" then
        self.numberScrollbar.value = number
    else
        self.numberScrollbar.value = 0
    end
end

function DetailsItem:_getValuableScore(rentPrice, buildingType)
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
--Whether to enable automatic replenishment
function DetailsItem:SendMessage()
    --if isOn == true then
    --    ct.log("fisher_w31_time","当前isOn = "..tostring(isOn).."，Send message: Turn on automatic replenishment")
    --    Event.Brocast("SetAutoReplenish",self)
    --else
    --    ct.log("fisher_w31_time","当前isOn = "..tostring(isOn).."，Send message: Turn off automatic replenishment")
    --    Event.Brocast("SetAutoReplenish",self)
    --end

    Event.Brocast("SetAutoReplenish",self)
end