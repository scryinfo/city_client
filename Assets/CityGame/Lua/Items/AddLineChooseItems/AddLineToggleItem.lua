---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/5 10:34
---类型item
AddLineToggleItem = class('AddLineToggleItem')
function AddLineToggleItem:initialize(viewRect, data, toggleGroup)
    self.viewRect = viewRect
    self.data = data
    self.toggle = viewRect:GetComponent("Toggle")
    self.toggle.group = toggleGroup
    self.chooseTran = viewRect:Find("choose")
    self.nameText = viewRect:Find("nameText"):GetComponent("Text")

    self.nameText.text = data.name
    self.toggle.onValueChanged:AddListener(function(isOn)
        self:showState(isOn)
        self.data.backFunc(self.data.typeId)
    end)
end
--显示状态，选中或者未选中
function AddLineToggleItem:showState(select)
    if select then
        self.chooseTran.localScale = Vector3.one
    else
        self.chooseTran.localScale = Vector3.zero
    end
end