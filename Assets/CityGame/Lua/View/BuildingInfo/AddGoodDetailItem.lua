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
    --如果是可展示状态
    if stateData.enableShow then
        self.disableImg.transform.localScale = Vector3.zero
    else
        self.disableImg.transform.localScale = Vector3.one
    end

    local tempData
    local type = ct.getType(UnityEngine.Sprite)
    if data.itemType == 0 then
        tempData = Material[data.itemId]
        self.nameText.text = GetLanguage(data.itemId)
        panelMgr:LoadPrefab_A(Material[data.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.iconImg.sprite = texture
            end
        end)
    else
        tempData = Good[data.itemId]
        self.nameText.text = GetLanguage(data.itemId)
        panelMgr:LoadPrefab_A(Good[data.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.iconImg.sprite = texture
            end
        end)
    end
    self.numberText.text = AdjustProductionLineCtrl.getGoodInventoryNum(data.itemId)

    self.toggle.onValueChanged:RemoveAllListeners()
    self.toggle.onValueChanged:AddListener(function(isOn)
        self:showState(isOn)
        if isOn then
            self.data.backFunc(self.data.itemId, self.viewRect.transform.position,stateData.enableShow)  --显示中间的线路
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
--
function AddGoodDetailItem:getItemId()
    return self.data.itemId
end

function AddGoodDetailItem:getItemPos()
    return self.viewRect.transform.position
end