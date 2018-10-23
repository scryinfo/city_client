---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/4 9:53
---住宅更改租金界面

-----
-----


HouseChangeRentCtrl = class('HouseChangeRentCtrl',UIPage)

function HouseChangeRentCtrl:initialize()
    UIPage.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function HouseChangeRentCtrl:bundleName()
    return "HouseChangeRent"
end

function HouseChangeRentCtrl:OnCreate(obj )
    UIPage.OnCreate(self, obj)
end

function HouseChangeRentCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self:_initData()

    local dialog = self.gameObject:GetComponent('LuaBehaviour')
    dialog:AddClick(self.closeBtn, self._onClickCloseBtn, self);
    dialog:AddClick(self.confirmBtn, self._onClickConfim, self);
end

function HouseChangeRentCtrl:Refresh()

end
---寻找组件
function HouseChangeRentCtrl:_getComponent(go)
    self.closeBtn = go.transform:Find("root/closeBtn").gameObject;
    self.currentRentalText = go.transform:Find("root/currentRentalText").gameObject:GetComponent("Text");
    self.rentInput = go.transform:Find("root/rentInput").gameObject:GetComponent("InputField");
    self.confirmBtn = go.transform:Find("root/confirmBtn").gameObject;
    self.effectiveDateText = go.transform:Find("root/effectiveDateText").gameObject:GetComponent("Text");
    self.suggestRect = go.transform:Find("root/suggestRect").gameObject:GetComponent("RectTransform");
    self.suggestRentalText = go.transform:Find("root/suggestRentalText").gameObject:GetComponent("Text");
end
---初始化
function HouseChangeRentCtrl:_initData()
    local blackColor = "#4B4B4B"
    local rentalStr = string.format("%s<color=%s>%s</color>", getPriceString(self.m_data.currentRental, 24, 18), blackColor, "/D")
    self.currentRentalText.text = rentalStr;

    local suggestStr = string.format("%sE<color=%s>%s</color>", getPriceString(self.m_data.suggestRental, 20, 18), blackColor, "/D")
    self.suggestRentalText.text = suggestStr;

    local trueTextW = self.suggestRentalText.preferredWidth;
    local pos = self.suggestRect.anchoredPosition;
    self.suggestRect.anchoredPosition = Vector2.New(70 + 164 - trueTextW, pos.y);

    self.effectiveDateText.text = self.m_data.effectiveDate
end

function HouseChangeRentCtrl:_onClickConfim(obj)
    log("cycle_w6_houseAndGround", "HouseChangeRentCtrl:_onClickConfim")
    --向服务器发送请求，改变租金

    obj:Hide();
end

function HouseChangeRentCtrl:_onClickCloseBtn(obj)
    log("cycle_w6_houseAndGround", "HouseChangeRentCtrl:_onClickCloseBtn")
    obj:Hide();
end