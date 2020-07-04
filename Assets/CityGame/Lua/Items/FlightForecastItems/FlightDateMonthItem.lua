---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/5/27 11:37
---
FlightDateMonthItem = class('FlightDateMonthItem', FlightDateBase)

--Initialization method
function FlightDateMonthItem:initialize(viewRect, data)
    self.viewRect = viewRect.transform
    self.data = data
    self.rect = viewRect.transform:GetComponent("RectTransform")
    local trans = self.viewRect

    self.btn = trans:Find("unSelect/btn"):GetComponent("Button")
    self.select = trans:Find("select")
    self.selectValue = trans:Find("select/Text"):GetComponent("Text")
    self.unSelect = trans:Find("unSelect")
    self.unSelectValue = trans:Find("unSelect/Text"):GetComponent("Text")

    self.selectValue.text = data.value
    self.unSelectValue.text = data.value

    self.btn.onClick:RemoveAllListeners()
    self.btn.onClick:AddListener(function ()
        self:btnFunc()
    end)
end
----
--function FlightDateMonthItem:setState(isSelect)
--    if isSelect == true then
--        self.select.localScale = Vector3.one
--        self.unSelect.localScale = Vector3.zero
--    else
--        self.select.localScale = Vector3.zero
--        self.unSelect.localScale = Vector3.one
--    end
--    self.isSelect = isSelect
--end
----
--function FlightDateMonthItem:btnFunc()
--    self.select.localScale = Vector3.one
--    self.unSelect.localScale = Vector3.zero
--    self.data.callBack(self)
--end
----
--function FlightDateMonthItem:Close()
--
--end

