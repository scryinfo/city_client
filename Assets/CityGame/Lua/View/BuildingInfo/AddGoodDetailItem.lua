AddGoodDetailItem = class('AddGoodDetailItem')
function AddGoodDetailItem:initialize(viewRect, data, toggleGroup)
    self.viewRect = viewRect
    self.data = data
    self.toggle = viewRect:GetComponent("Toggle")
    self.toggle.group = toggleGroup
    --self.itemId = data.itemId
    self.iconImg = viewRect:Find("iconImg"):GetComponent("Image")
    self.nameText = viewRect:Find("nameText"):GetComponent("Text")
    self.disableImg = viewRect:Find("disableImg"):GetComponent("Image")
    self.stateRoot = viewRect:Find("stateRoot")
    self.stateText = viewRect:Find("stateRoot/stateText"):GetComponent("Text")
    self.infoBtn = viewRect:Find("infoBtn")
    self.numberText = viewRect:Find("inventory/numberText"):GetComponent("Text")
    self.chooseImgTran = viewRect:Find("chooseImg")

    local stateData = AddProductionLineCtrl.GetItemState(data.itemId)
    --If it is displayable
    if stateData.enableShow then
        self.disableImg.transform.localScale = Vector3.zero
    else
        self.disableImg.transform.localScale = Vector3.one
    end

    local tempData
    if data.itemType == 0 then
        tempData = Material[data.itemId]
    else
        tempData = Good[data.itemId]
    end
    AddProductionLineMgr.SetBuildingIconSpite(tempData.img, self.iconImg)
    --self.numberText.text = HomeProductionLineItem.GetInventoryNum(data.itemId)
    self.toggle.onValueChanged:RemoveAllListeners()
    self.toggle.onValueChanged:AddListener(function(isOn)
        self:showState(isOn)
        if isOn == true then
            self.data.backFunc(self.data.itemId, self.viewRect.transform.position,stateData.enableShow)  --Show the middle line
        end
    end)
    self:_language()
end
--Check status based on itemId
function AddGoodDetailItem:_showState(itemId)

end

--Externally set toggle status
function AddGoodDetailItem:setToggleIsOn(isOn)
    self.toggle.isOn = isOn
    self:showState(isOn)
end
--display
function AddGoodDetailItem:showState(select)
    if select == true then
        self.chooseImgTran.localScale = Vector3.one
    else
        self.chooseImgTran.localScale = Vector3.zero
    end
end
--Clear selected state
function AddGoodDetailItem:cleanState()
    if self.toggle.isOn == true then
        self:setToggleIsOn(false)
    end
end
--
function AddGoodDetailItem:getItemId()
    return self.data.itemId
end
--
function AddGoodDetailItem:getItemPos()
    return self.viewRect.transform.position
end
--
function AddGoodDetailItem:_language()
    self.nameText.text = GetLanguage(self.data.itemId)
end