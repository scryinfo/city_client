DETAILSBoxCtrl = class('DETAILSBoxCtrl',UIPage);

local itemId
function DETAILSBoxCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.Normal);
end

function DETAILSBoxCtrl:bundleName()
    return "DETAILSBoxPanel";
end

function DETAILSBoxCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    local details = self.gameObject:GetComponent('LuaBehaviour');
    details:AddClick(DETAILSBoxPanel.XBtn.gameObject,self.OnClick_XBtn,self);
    details:AddClick(DETAILSBoxPanel.confirmBtn.gameObject,self.OnClick_confirmBtn,self);

    DETAILSBoxPanel.numberInput.onValueChanged:AddListener(function()
        self:numberInputInfo();
    end)
    DETAILSBoxPanel.numberSlider.onValueChanged:AddListener(function()
        self:numberSliderInfo();
    end)

    Event.AddListener("refreshUiInfo",self.RefreshUiInfo,self)
end

function DETAILSBoxCtrl:Awake(go)
    self.gameObject = go;
end

function DETAILSBoxCtrl:OnClick_XBtn(obj)
    obj:Hide();
end

function DETAILSBoxCtrl:Refresh()
    --self.obj = self.m_data
    --self.uiInfo = self.m_data.goodsDataInfo
    self.itemId = self.m_data.itemId
    DETAILSBoxPanel.nameText.text = self.m_data.name
    DETAILSBoxPanel.numberInput.text = self.m_data.num
    DETAILSBoxPanel.numberSlider.maxValue = self.m_data.num
    DETAILSBoxPanel.numberSlider.value = self.m_data.num
    DETAILSBoxPanel.priceInput.text = self.m_data.price..".0000"
end
--修改数量价格
function DETAILSBoxCtrl:OnClick_confirmBtn(ins)
    local number = DETAILSBoxPanel.numberSlider.value
    local price = tonumber(DETAILSBoxPanel.priceInput.text)

    if number ~= ins.m_data.num and price ~= ins.m_data.price then
        local num = ins.m_data.num - number
        Event.Brocast("m_ReqShelfDel",ins.m_data.buildingId,ins.itemId,num)
        Event.Brocast("m_ReqModifyShelf",ins.m_data.buildingId,ins.itemId,number,price);
        ins:Hide();
        Event.Brocast("SmallPop","修改成功",300)
        return;
    end
    if number == ins.m_data.num and price == ins.m_data.price then
        ins:Hide();
        return;
    end
    if number ~= ins.m_data.num and price == ins.m_data.price then
        local num = ins.m_data.num - number
        Event.Brocast("m_ReqShelfDel",ins.m_data.buildingId,ins.itemId,num)
        ins:Hide();
        Event.Brocast("SmallPop","数量修改成功",300)
        return;
    end
    if number == ins.m_data.num and price ~= ins.m_data.price then
        Event.Brocast("m_ReqModifyShelf",ins.m_data.buildingId,ins.itemId,number,price);
        ins:Hide();
        Event.Brocast("SmallPop","价格修改成功",300)
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
--刷新UI显示
function DETAILSBoxCtrl:refreshUiInfo(msg)
    self.moneyText.text = getPriceString("E"..msg.price..".0000",35,25)
    self.numberText.text = msg.item.n
end