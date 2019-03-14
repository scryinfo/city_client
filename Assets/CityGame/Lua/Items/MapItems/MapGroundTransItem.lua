---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---
MapGroundTransItem = class('MapGroundTransItem', MapBubbleBase)

--
function MapGroundTransItem:_childInit()
    self.scaleRoot = self.viewRect.transform:Find("root")  --需要缩放的部分

    self.groundSell = self.viewRect.transform:Find("root/groundSell")
    self.groundRent = self.viewRect.transform:Find("root/groundRent")

    self.sellBtn = self.viewRect.transform:Find("groundSell/sellBtn"):GetComponent("Button")
    self.sellText01 = self.viewRect.transform:Find("groundSell/sellBtn/Text"):GetComponent("Text")
    self.rentBtn = self.viewRect.transform:Find("groundRent/rentBtn"):GetComponent("Button")
    self.rentText02 = self.viewRect.transform:Find("groundRent/rentBtn/Text"):GetComponent("Text")

    self.sellBtn.onClick:AddListener(function ()
        self:_openGroundTransPage()
    end)
    self.rentBtn.onClick:AddListener(function ()
        self:_openGroundTransPage()
    end)

    self:initData(self.data)
end
--
function MapGroundTransItem:initData(data)
    self.data = data
    self:_setBubbleState(data.groundState)
end
--
function MapGroundTransItem:_setBubbleState(state)
    if state == GroundTransState.Sell then
        self.groundSell.localScale = Vector3.one
        self.groundRent.localScale = Vector3.zero
        --self.sellText01.text = GetLanguage()
        self.sellText01.text = "SELL"
    elseif state == GroundTransState.Rent then
        self.groundRent.localScale = Vector3.one
        self.groundSell.localScale = Vector3.zero
        --self.rentText02.text = GetLanguage()
        self.rentText02.text = "RENT"
    end
end
--
function MapGroundTransItem:_openGroundTransPage()
    if self.data == nil then
        return
    end
    --出租:日租金，租期
    --出售:价格
    --位置信息，头像，用户名
end
--