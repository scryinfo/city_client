---
---type item
---
AddLineTypeItemNew = class('AddLineTypeItemNew')
function AddLineTypeItemNew:initialize(viewRect, data, toggleGroup)
    self.viewRect = viewRect
    self.data = data
    self.bgBtn = viewRect:Find("bgBtn"):GetComponent("Button")
    self.chooseTran = viewRect:Find("choose")
    self.nameText = viewRect:Find("nameText"):GetComponent("Text")

    self.data.createDetail(self.data.typeId)  --先生成items
    self:_language()
    self.bgBtn.onClick:AddListener(function()
        self:_btnClickFunc()
    end)
end
--外部设置显示状态
function AddLineTypeItemNew:setToggleIsOn(isOn)
    self.select = isOn
    self:showState(isOn)
end
--显示状态，选中或者未选中
function AddLineTypeItemNew:showState(select)
    if select == true then
        self.chooseTran.localScale = Vector3.one
    else
        self.chooseTran.localScale = Vector3.zero
    end
end
--外部获取typeId
function AddLineTypeItemNew:getTypeId()
    return self.data.typeId
end
--
function AddLineTypeItemNew:_language()
    self.nameText.text = GetLanguage(self.data.languageId)
end
--点击按钮
function AddLineTypeItemNew:_btnClickFunc()
    if self.select == nil or self.select == false then
        self.data.selectFunc(self)
        --ct.log("system","-------------------选中了type："..self.data.typeId)
    end
end
--
function AddLineTypeItemNew:_selectType()
    self.select = true
    self:showState(true)
    self.data.selectFunc(self)
    --ct.log("system","-------------------选中了type："..self.data.typeId)
end