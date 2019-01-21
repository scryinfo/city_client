---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/4 9:53
---住宅更改租金界面
HouseSetRentalDialogPageCtrl = class('HouseSetRentalDialogPageCtrl',UIPanel)
UIPanel:ResgisterOpen(HouseSetRentalDialogPageCtrl)
HouseSetRentalDialogPageCtrl.static.BlackColor = "#474747"

function HouseSetRentalDialogPageCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function HouseSetRentalDialogPageCtrl:bundleName()
    return "Assets/CityGame/Resources/View/HouseSetRentalDialogPagePanel.prefab"
end

function HouseSetRentalDialogPageCtrl:OnCreate(obj )
    UIPanel.OnCreate(self, obj)
end

function HouseSetRentalDialogPageCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)

    local luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    luaBehaviour:AddClick(self.closeBtn.gameObject, self._onClickCloseBtn, self)
    luaBehaviour:AddClick(self.confirmBtn.gameObject, self._onClickConfim, self)
    luaBehaviour:AddClick(self.refreshBtn.gameObject, self._onClickRefreshBtn, self)
end

function HouseSetRentalDialogPageCtrl:Refresh()
    self:_initData()
end
---寻找组件
function HouseSetRentalDialogPageCtrl:_getComponent(go)
    self.confirmBtn = go.transform:Find("root/confirmBtn")
    self.closeBtn = go.transform:Find("root/closeBtn")
    self.refreshBtn = go.transform:Find("root/refreshBtn")
    self.input = go.transform:Find("root/input"):GetComponent("InputField")

    self.scoreText = go.transform:Find("root/totalScore/scoreText"):GetComponent("Text")
    self.roomDesTextRect = go.transform:Find("root/roomDesText"):GetComponent("Text")
    self.roomCountText = go.transform:Find("root/roomDesText/roomCountText"):GetComponent("Text")
end
---初始化
function HouseSetRentalDialogPageCtrl:_initData()
    if self.m_data == nil then
        return
    end
    self.m_data.rent = self.m_data.rent or 0
    self.input.text = tostring(self.m_data.rent)
    self.scoreText.text = self:_getValuableScore(self.m_data.rent, self.m_data.buildingTypeId)

    self.roomCountText.text = string.format("%d<color=%s>/%d</color>", self.m_data.renter, HouseSetRentalDialogPageCtrl.static.BlackColor, self.m_data.totalCount)
    local trueTextW = self.roomDesTextRect.preferredWidth + 8
    self.roomDesTextRect.rectTransform.sizeDelta = Vector2.New(trueTextW, self.roomDesTextRect.rectTransform.sizeDelta.y)
end

function HouseSetRentalDialogPageCtrl:_onClickConfim(ins)
    local inputValue = ins.input.text
    if inputValue == "" then
        return
    end

    --向服务器发送请求，改变租金
    Event.Brocast("m_ReqHouseChangeRent", ins.m_data.buildingId, inputValue)
    ins:_onClickCloseBtn(ins)
end

function HouseSetRentalDialogPageCtrl:_onClickCloseBtn(ins)
    ins:Hide()
end
--刷新总分
function HouseSetRentalDialogPageCtrl:_onClickRefreshBtn(ins)
    local inputValue = ins.input.text
    if inputValue == "" then
        ins.input.text = "0"
        inputValue = 0
    end
    ins.scoreText.text = ins:_getValuableScore(inputValue, ins.m_data.buildingTypeId)
end

function HouseSetRentalDialogPageCtrl:_getValuableScore(rentPrice, buildingType)
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