---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/4/4 16:01
---

OptionItem = class("OptionItem")
OptionItem.static.NomalNameColor = Vector3.New(51, 51, 51) -- 默认的名字颜色
OptionItem.static.SelectNameColor = Vector3.New(255, 255, 255) -- 被选中的名字颜色

-- 初始化
function OptionItem:initialize(prefab, OptionIndex, index)
    self.prefab = prefab
    self.optionIndex = OptionIndex
    self.index = index
    --self.ctrl = ctrl

    local transform = prefab.transform
    self.nameText = transform:Find("Text"):GetComponent("Text")
    self.btn = transform:GetComponent("Button")

    self:SetSelect(true)
    if OptionIndex == 1 then
        self.nameText.text = EvaConfig[index].name
    elseif OptionIndex == 2 then
        local optionOne = CompanyCtrl.static.companyMgr:GetEvaRecordData()[1]
        self.nameText.text = EvaConfig[optionOne].option[index].name
        if CompanyCtrl.static.companyMgr.ctrl.isClickEva then
            self:_setContent()
        end
    elseif OptionIndex == 3 then
        local recordData = CompanyCtrl.static.companyMgr:GetEvaRecordData()
        self.nameText.text = EvaConfig[recordData[1]].option[recordData[2]].option[index].name
        if CompanyCtrl.static.companyMgr.ctrl.isClickEva then
            self:_setContent()
        end
    end

    self.btn.onClick:RemoveAllListeners()
    self.btn.onClick:AddListener(function ()
        self:_setContent()
    end)
end

-- 设置是否选中
function OptionItem:SetSelect(isSelect)
    self.btn.interactable = isSelect
end

-- 设置文本颜色
function OptionItem:SetNameTextColor(index)
    local color
    if index == 1 then
        color = OptionItem.static.NomalNameColor
    elseif index == 2 then
        color = OptionItem.static.SelectNameColor
    end
    self.nameText.color = getColorByVector3(color)
end

-- 点击记录获取数据
function OptionItem:_setContent()
    CompanyCtrl.static.companyMgr:SetBtnState(self.optionIndex)
    self:SetSelect(false)
    CompanyCtrl.static.companyMgr:SetEvaRecord(self.optionIndex, self.index)
    if self.optionIndex == 1 then
        CompanyCtrl.static.companyMgr:SetBtnNameTextColor()
        self:SetNameTextColor(2)
        if EvaConfig[self.index].option then
            CompanyCtrl.static.companyMgr.ctrl:ShowOptionTwo(#EvaConfig[self.index].option)

            -- 界面相应显示刷新
            --CompanyPanel.optionRootRt.offsetMin = Vector2.New(0,-200)
            CompanyPanel.optionRootRt.sizeDelta = Vector2.New(1602, 230)
            CompanyPanel.bg2Rt.sizeDelta = Vector2.New(1586, 94)
            CompanyPanel.optionTwoT.localScale = Vector3.one
            CompanyPanel.optionThereT.localScale = Vector3.zero
            CompanyPanel.propertyRootRt.offsetMax = Vector2.New(0, -243)
        else
            -- 显示属性
            CompanyCtrl.static.companyMgr.ctrl:ShowOptionTwo(0)
            CompanyCtrl.static.companyMgr:CreatePropertyItem(EvaConfig[self.index].property)
            CompanyCtrl.static.companyMgr.ctrl.isClickEva = false

            -- 界面相应显示刷新
            --CompanyPanel.optionRootRt.offsetMin = Vector2.New(0,-100)
            CompanyPanel.optionRootRt.sizeDelta = Vector2.New(1602, 142)
            CompanyPanel.bg2Rt.sizeDelta = Vector2.New(0, 0)
            CompanyPanel.optionTwoT.localScale = Vector3.zero
            CompanyPanel.optionThereT.localScale = Vector3.zero
            CompanyPanel.propertyRootRt.offsetMax = Vector2.New(0, -155)
        end
        CompanyCtrl.static.companyMgr.ctrl:ShowOptionThere(0)
    elseif self.optionIndex == 2 then
        local optionOne = CompanyCtrl.static.companyMgr:GetEvaRecordData()[1]
        if EvaConfig[optionOne].option[self.index].option then
            CompanyCtrl.static.companyMgr.ctrl:ShowOptionThere(#EvaConfig[optionOne].option[self.index].option)

            -- 界面相应显示刷新
            --CompanyPanel.optionRootRt.offsetMin = Vector2.New(0,-300)
            CompanyPanel.optionRootRt.sizeDelta = Vector2.New(1602, 312)
            CompanyPanel.bg2Rt.sizeDelta = Vector2.New(1586, 175)
            CompanyPanel.optionTwoT.localScale = Vector3.one
            CompanyPanel.optionThereT.localScale = Vector3.one
            CompanyPanel.propertyRootRt.offsetMax = Vector2.New(0, -325)
        else
            -- 显示属性
            CompanyCtrl.static.companyMgr.ctrl:ShowOptionThere(0)
            CompanyCtrl.static.companyMgr:CreatePropertyItem(EvaConfig[optionOne].option[self.index].property)
            CompanyCtrl.static.companyMgr.ctrl.isClickEva = false
        end
    elseif self.optionIndex == 3 then
        -- 显示属性
        CompanyCtrl.static.companyMgr.ctrl.isClickEva = false
        local recordData = CompanyCtrl.static.companyMgr:GetEvaRecordData()
        CompanyCtrl.static.companyMgr:CreatePropertyItem(EvaConfig[recordData[1]].option[recordData[2]].option[recordData[3]].property)
    end
end