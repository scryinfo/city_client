---
---Details item
---
AddLineDetailItemNew = class('AddLineDetailItemNew')
function AddLineDetailItemNew:initialize(viewRect, data, toggleGroup)
    self.viewRect = viewRect
    self.data = data
    self.bgBtn = viewRect:Find("bgBtn"):GetComponent("Button")
    self.iconImg = viewRect:Find("iconImg"):GetComponent("Image")
    self.nameText = viewRect:Find("nameText"):GetComponent("Text")
    self.disableImg = viewRect:Find("disableImg"):GetComponent("Image")
    self.stateRoot = viewRect:Find("stateRoot")
    self.stateText = viewRect:Find("stateRoot/stateText"):GetComponent("Text")
    self.chooseImgTran = viewRect:Find("chooseImg")

    local stateData = AddProductionLineCtrl.GetItemState(data.itemId)
    --If it is displayable
    if stateData.enableShow then
        self.disableImg.transform.localScale = Vector3.zero
    else
        self.disableImg.transform.localScale = Vector3.one
    end
    self.stateData = stateData

    local tempData
    --if data.itemType == 0 then
    --    tempData = Material[data.itemId]
    --else
    --    tempData = Good[data.itemId]
    --end
    NewAddProductionLineCtrl.SetBuildingIconSpite(data.itemId, self.iconImg)
    self.bgBtn.onClick:RemoveAllListeners()
    self.bgBtn.onClick:AddListener(function()
        self:_clickFunc()
    end)
    self:_language()
    self:setToggleIsOn(false)
end

--Externally set toggle status
function AddLineDetailItemNew:setToggleIsOn(isOn)
    if isOn ~= true or isOn ~= false then
        ct.log("")
    end
    self.select = isOn
    self:showState(isOn)
end
--
function AddLineDetailItemNew:_selectDetail()
    self.select = true
    self:showState(true)
    self.data.backFunc(self)  --Show the middle line
end
--display
function AddLineDetailItemNew:showState(select)
    if select == true then
        self.chooseImgTran.localScale = Vector3.one
    else
        self.chooseImgTran.localScale = Vector3.zero
    end
end
--Clear selected state
function AddLineDetailItemNew:cleanState()
    self:setToggleIsOn(false)
end
--
function AddLineDetailItemNew:getItemId()
    return self.data.itemId
end
--
function AddLineDetailItemNew:getItemPos()
    return self.viewRect.transform.position
end
--
function AddLineDetailItemNew:getEnableShow()
    return self.stateData.enableShow
end
--
function AddLineDetailItemNew:_language()
    self.nameText.text = GetLanguage(self.data.itemId)
end
--
function AddLineDetailItemNew:_clickFunc()
    if self.select == nil or self.select == false then
        self:_selectDetail()
    end
end
--
function AddLineDetailItemNew:close()
    --self.data = nil
    --self = nil
end