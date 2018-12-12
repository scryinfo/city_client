---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/25 9:57
---
ExchangeWareHouseItem = class('ExchangeWareHouseItem')
ExchangeWareHouseItem.static.BUY_CAPACITYCOLOR = "#4D69B2"  --购买时显示库存剩余量的颜色

--初始化方法
function ExchangeWareHouseItem:initialize(data, viewRect)
    self.viewRect = viewRect;
    self.data = data;

    local viewTrans = self.viewRect;
    self.sizeText = viewTrans:Find("sizeBg/Text"):GetComponent("Text")
    self.sellTran = viewTrans:Find("sell")
    self.sellRemainCountText = viewTrans:Find("sell/remainCountText"):GetComponent("Text")  --当前货物在仓库中有多少
    self.buyTran = viewTrans:Find("buy")
    self.buyCapacityText = viewTrans:Find("buy/capacityText"):GetComponent("Text")  --库存量
    self.buyCapacitySlider = viewTrans:Find("buy/capacitySlider"):GetComponent("Slider")
    self.buildingTypeText = viewTrans:Find("buildingTypeText"):GetComponent("Text")
    self.buildingNameText = viewTrans:Find("buildingNameText"):GetComponent("Text")
    self.iconImg = viewTrans:Find("icon"):GetComponent("Image")
    self.clickBtn = viewTrans:Find("bgBtn"):GetComponent("Button")

    self:_initData()

    self.clickBtn.onClick:RemoveAllListeners();
    self.clickBtn.onClick:AddListener(function ()
        self:_clickBtn()
    end)
end

--初始化界面
function ExchangeWareHouseItem:_initData()
    local data = self.data
    if data.isSell then
        self.sellTran.localScale = Vector3.one
        self.buyTran.localScale = Vector3.zero
        self.sellRemainCountText.text = data.totalCount
    else
        self.buyTran.localScale = Vector3.one
        self.sellTran.localScale = Vector3.zero
        local totalCount = PlayerBuildingBaseData[data.buildingTypeId].storeCapacity
        self.buyCapacityText.text = string.format("<color=%s>%d</color>/%d", ExchangeWareHouseItem.static.BUY_CAPACITYCOLOR, totalCount - data.remainCapacity, totalCount)
        self.buyCapacitySlider.maxValue = totalCount
        self.buyCapacitySlider.value = totalCount - data.remainCapacity
    end
    self.sizeText.text = PlayerBuildingBaseData[data.buildingTypeId].sizeName  --Large Medium Small
    self.buildingTypeText.text = PlayerBuildingBaseData[data.buildingTypeId].typeName  --eg: Factory
    self.buildingNameText.text = data.buildingName  --eg: Buddy polly

end

--点击打开详情
function ExchangeWareHouseItem:_clickBtn()
    --关闭当前界面，并传输数据到买卖界面
    UIPage.ClosePage();
    --ct.OpenCtrl("ExchangeDetailCtrl", self.data)

    Event.Brocast("c_onExchangeChooseWareHouseBack", self.data);
end