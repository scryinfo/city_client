---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/3/29 17:37
---

BuildingTitleItem = class("BuildingTitleItem")
BuildingTitleItem.static.NomalNameColor = Vector3.New(51, 51, 51) -- 默认的名字颜色
BuildingTitleItem.static.SelectNameColor = Vector3.New(255, 255, 255) -- 被选中的名字颜色
BuildingTitleItem.static.NomalNumberColor = Vector3.New(153, 153, 153) -- 默认的数量颜色
BuildingTitleItem.static.SelectNumberColor = Vector3.New(91, 162, 249) -- 被选中的数量颜色
BuildingTitleItem.static.NomalNumberBgColor = Vector3.New(238, 238, 238) -- 默认的数量背景色
BuildingTitleItem.static.SelectNumberBgColor = Vector3.New(255, 255, 255) -- 被选中的数量背景色

-- 初始化
function BuildingTitleItem:initialize(prefab, data)
    self.prefab = prefab
    self.data = data - 1
    --self.isSelect = false

    local transform = prefab.transform

    self.buildingSelectBtn = transform:GetComponent("Button")
    self.nameText = transform:Find("NameText"):GetComponent("Text")
    self.numberText = transform:Find("NumberText"):GetComponent("Text")
    self.bgImage = transform:Find("Bg"):GetComponent("Image")
    self:SetName()
    self:SetNumber()
    self:SetSelect(true)

    self.buildingSelectBtn.onClick:RemoveAllListeners()
    self.buildingSelectBtn.onClick:AddListener(function ()
        self:_setContent()
    end)
end

-- 设置类型名字
function BuildingTitleItem:SetName()
    if self.data == 0 then
        self.nameText.text = "全部"
    elseif self.data == 1 then
        self.nameText.text = "原料厂"
    elseif self.data == 2 then
        self.nameText.text = "加工厂"
    elseif self.data == 3 then
        self.nameText.text = "零售店"
    elseif self.data == 4 then
        self.nameText.text = "住宅"
    elseif self.data == 5 then
        self.nameText.text = "研究所"
    elseif self.data == 6 then
        self.nameText.text = "推广公司"
    elseif self.data == 7 then
        self.nameText.text = "仓库"
        self.prefab:SetActive(false)
    end
end

-- 设置类型个数
function BuildingTitleItem:SetNumber(number)
    if number then
        self.numberText.text = number
    else
        self.numberText.text = "0"
    end
end

-- 设置是否选中
function BuildingTitleItem:SetSelect(isSelect)
    self.buildingSelectBtn.interactable = isSelect
    local nameTextV3 = isSelect and BuildingTitleItem.static.NomalNameColor or BuildingTitleItem.static.SelectNameColor
    local numberTextV3 = isSelect and BuildingTitleItem.static.NomalNumberColor or BuildingTitleItem.static.SelectNumberColor
    local bgV3 = isSelect and BuildingTitleItem.static.NomalNumberBgColor or BuildingTitleItem.static.SelectNumberBgColor
    self.nameText.color = getColorByVector3(nameTextV3)
    self.numberText.color = getColorByVector3(numberTextV3)
    self.bgImage.color = getColorByVector3(bgV3)
end

-- 点击刷新
function BuildingTitleItem:_setContent()
    --self.isSelect = not self.isSelect
    CompanyCtrl.static.companyMgr.buildingTypeNum = self.data -- self.isSelect and self.data or 0
    self:SetSelect(false)
    DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_QueryMyBuildings')
end