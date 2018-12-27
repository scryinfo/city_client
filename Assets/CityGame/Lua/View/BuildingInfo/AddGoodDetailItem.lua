AddGoodDetailItem = class('AddGoodDetailItem')
function AddGoodDetailItem:initialize(viewRect, data, toggleGroup)
    self.viewRect = viewRect
    self.data = data
    self.toggle = viewRect:GetComponent("Toggle")
    self.toggle.group = toggleGroup

    self.iconImg = viewRect:Find("iconImg"):GetComponent("Image")
    self.nameText = viewRect:Find("nameText"):GetComponent("Text")
    self.disableImg = viewRect:Find("disableImg"):GetComponent("Image")
    self.stateRoot = viewRect:Find("stateRoot")
    self.stateText = viewRect:Find("stateRoot/stateText"):GetComponent("Text")
    self.infoBtn = viewRect:Find("infoBtn")
    self.chooseImgTran = viewRect:Find("chooseImg")

    local tempData
    if data.itemType == 0 then
        tempData = Material[data.itemId]
    else
        tempData = Good[data.itemId]
    end
    self.nameText.text = tempData.name

    self.toggle.onValueChanged:RemoveAllListeners()
    self.toggle.onValueChanged:AddListener(function(isOn)
        self:showState(isOn)
        if isOn then
            self.data.backFunc(self.data.itemId, self.viewRect.transform.position)  --显示中间的线路
        end
    end)
end
--根据itemId去查状态
function AddGoodDetailItem:_showState(itemId)

end

--外部设置toggle状态
function AddGoodDetailItem:setToggleIsOn(isOn)
    self.toggle.isOn = isOn
    self:showState(isOn)
end
--显示
function AddGoodDetailItem:showState(select)
    if select then
        self.chooseImgTran.localScale = Vector3.one
    else
        self.chooseImgTran.localScale = Vector3.zero
    end
end
--清除选中状态
function AddGoodDetailItem:cleanState()
    if self.toggle.isOn then
        self:setToggleIsOn(false)
    end
end