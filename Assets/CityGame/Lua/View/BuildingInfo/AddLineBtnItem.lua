AddLineBtnItem = class('AddLineBtnItem')
function AddLineBtnItem:initialize(viewRect, data, toggleGroup)
    self.viewRect = viewRect
    self.data = data
    self.toggle = viewRect:GetComponent("Toggle")
    self.toggle.group = toggleGroup
    self.chooseTran = viewRect:Find("choose")
    self.nameText = viewRect:Find("nameText"):GetComponent("Text")

    --self.nameText.text = GetLanguage(data.languageId)
    self:_language()
    self.toggle.onValueChanged:AddListener(function(isOn)
        self:showState(isOn)
        if isOn then
            self.data.backFunc(self.data.typeId)
        end
    end)
end
--Externally set toggle status
function AddLineBtnItem:setToggleIsOn(isOn)
    self.toggle.isOn = isOn
    self:showState(isOn)
end
--Display status, selected or unselected
function AddLineBtnItem:showState(select)
    if select then
        self.chooseTran.localScale = Vector3.one
    else
        self.chooseTran.localScale = Vector3.zero
    end
end
--Get typeId externally
function AddLineBtnItem:getTypeId()
    return self.data.typeId
end
--
function AddLineBtnItem:_language()
    self.nameText.text = GetLanguage(self.data.languageId)
end