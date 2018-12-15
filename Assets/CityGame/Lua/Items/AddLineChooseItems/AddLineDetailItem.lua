---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/5 10:34
---类型详细物品item
AddLineDetailItem = class('AddLineDetailItem')
function AddLineDetailItem:initialize(viewRect, data, toggleGroup)
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

    self.toggle.onValueChanged:RemoveAllListeners()
    self.toggle.onValueChanged:AddListener(function(isOn)
        self:showState(isOn)
        if isOn then
            self.data.backFunc(self.data.itemId, self.viewRect.transform.position)  --显示中间的线路
        end
    end)

    --如果是可展示状态
    if data.enableShow then
        self.disableImg.transform.localScale = Vector3.zero
    else
        self.disableImg.transform.localScale = Vector3.one
    end
    if data.itemState == AddLineDetailItemState.InventIng then
        self.stateRoot.localScale = Vector3.one
        self.stateText.text = "Be inventing..."
    elseif data.itemState == AddLineDetailItemState.ToBeInvented then
        self.stateRoot.localScale = Vector3.one
        self.stateText.text = "To be invented..."
    elseif data.itemState == AddLineDetailItemState.ResearchIng then
        self.stateRoot.localScale = Vector3.one
        self.stateText.text = "Be researching..."
    elseif data.itemState == AddLineDetailItemState.HasInvented then
        self.stateRoot.localScale = Vector3.one
        self.stateText.text = "Has been invented..."
    elseif data.itemState == AddLineDetailItemState.Default then
        self.stateRoot.localScale = Vector3.zero
    end

    local tempData
    if data.itemType == 0 then
        tempData = Material[data.itemId]
    else
        tempData = Good[data.itemId]
    end
    self.nameText.text = tempData.name
end
--外部设置toggle状态
function AddLineDetailItem:setToggleIsOn(isOn)
    self.toggle.isOn = isOn
    self:showState(isOn)
end
--显示
function AddLineDetailItem:showState(select)
    if select then
        self.chooseImgTran.localScale = Vector3.one
    else
        self.chooseImgTran.localScale = Vector3.zero
    end
end
--清除选中状态
function AddLineDetailItem:cleanState()
    if self.toggle.isOn then
        self:setToggleIsOn(false)
    end
end