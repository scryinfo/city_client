---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/3/26 17:19
---

-- 公司管理器
CompanyMgr = class("CompanyMgr")

function CompanyMgr:initialize(ctrl)
    self.ctrl = ctrl
    -- 当前土地显示的项数记录
    self.landTypeNum = 0
    -- 土地item的个数
    self.landTitleItemNumber = 6
    -- 当前建筑显示的项数记录
    self.buildingTypeNum = 0
    -- 建筑item的个数
    self.buildingTitleItemNumber = 8
    -- Eva选择记录的个数
    self.evaRecordData = {}
    -- 当前品牌显示的项数记录
    self.brandTypeNum = 0
    -- 品牌item的个数
    self.brandTitleItemNumber = 5
    -- 当前品牌显示的大小
    self.brandSizeNum = 1
end

-- 获取土地选项item
function CompanyMgr:GetLandTitleItem()
    return self.landTitleItem
end

-- 生成土地选项item
function CompanyMgr:CreateLandTitleItem()
    self.landTitleItem = {}
    for i = 1, self.landTitleItemNumber do
        local function callback(obj)
            self.landTitleItem[i] = LandTitleItem:new(obj, i)
            if i == self.landTitleItemNumber then
                DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_GetGroundInfo')
            end
        end
        DynamicLoadPrefab("Assets/CityGame/Resources/View/Company/LandTitleItem.prefab", CompanyPanel.landTitleContent, nil, callback)
    end
end

-- 获取建筑选项item
function CompanyMgr:GetBuildingTitleItem()
    return self.buildingTitleItem
end

-- 生成建筑选项item
function CompanyMgr:CreateBuildingTitleItem()
    self.buildingTitleItem = {}
    for i = 1, self.buildingTitleItemNumber do
        local function callback(obj)
            self.buildingTitleItem[i] = BuildingTitleItem:new(obj, i)
            if i == self.buildingTitleItemNumber then
                DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_QueryMyBuildings')
            end
        end
        DynamicLoadPrefab("Assets/CityGame/Resources/View/Company/LandTitleItem.prefab", CompanyPanel.buildingTitleContent, nil, callback)
    end
end

-- 获得Eva选项item
function CompanyMgr:GetEvaTitleItem()
    return self.evaTitleItem
end

-- 生成Eva选项item
function CompanyMgr:CreateEvaTitleItem()
    self.evaTitleItem = {}
    for i, v in ipairs(EvaConfig) do
        local function callback(obj)
            self.evaTitleItem[i] = OptionItem:new(obj, 1, i)
            if i == #EvaConfig then
                DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_QueryMyEva')
            end
        end
        DynamicLoadPrefab("Assets/CityGame/Resources/View/Company/EvaTitleItem.prefab", CompanyPanel.optionOneScroll, nil, callback)
    end
end

-- 获取Eva选项item
function CompanyMgr:GetEvaRecordData()
    return self.evaRecordData
end

-- 设置Eva选择记录
function CompanyMgr:SetEvaRecord(index, data)
    self.evaRecordData[index] = data
end

-- 保存Eva数据
function CompanyMgr:SetEvaData(evas)
    self.evasData = evas.eva
end

-- 生成Eva属性item
function CompanyMgr:CreatePropertyItem(propertyTab)
    if not propertyTab then
        return
    end

    -- 清除已经有的属性
    if self.propertyItems then
        for _, a in ipairs(self.propertyItems) do
            UnityEngine.GameObject.Destroy(a.prefab)
        end
    end
    self.propertyItems = {}

    -- 生成新的属性显示
    for _, b in ipairs(propertyTab) do
        for _, v in ipairs(self.evasData) do
            if b.Atype == v.at and b.Btype == v.bt then
                if v.b == -1 then -- 可升级
                    local function callback(obj)
                        local propertyItem = PropertyTrueItem:new(obj, v, b)
                        table.insert(self.propertyItems, propertyItem)
                    end
                    DynamicLoadPrefab("Assets/CityGame/Resources/View/Company/PropertyTrueItem.prefab", CompanyPanel.propertyScroll, nil, callback)
                else -- 不可升级，显示知名度
                    local function callback(obj)
                        local propertyItem = PropertyFalseItem:new(obj, v, b.name)
                        table.insert(self.propertyItems, propertyItem)
                    end
                    DynamicLoadPrefab("Assets/CityGame/Resources/View/Company/PropertyFalseItem.prefab", CompanyPanel.propertyScroll, nil, callback)
                end
                break
            end
        end
    end
end

-- 重置按钮的状态
function CompanyMgr:SetBtnState(index)
    if index == 1 then
        for _, v in ipairs(self.evaTitleItem) do
            v:SetSelect(true)
            v:SetNameTextColor(1)
        end
    elseif index == 2 then
        for _, v in ipairs(CompanyCtrl.optionTwoScript) do
            v:SetSelect(true)
        end
    elseif index == 3 then
        for _, v in ipairs(CompanyCtrl.optionThereScript) do
            v:SetSelect(true)
        end
    end
end

-- 重置Eva按钮的字的颜色
function CompanyMgr:SetBtnNameTextColor()
    for _, v in ipairs(self.evaTitleItem) do
        v:SetNameTextColor(1)
    end
end

-- Eva默认选择
function CompanyMgr:SetEvaDefaultState()
    --CompanyPanel.optionOneRt.anchoredPosition = Vector2.New(0,0)
    self.evaTitleItem[1]:_setContent()
end

-- 更新Eva的数据
--function CompanyMgr:UpdateMyEva(eva)
--    for i, v in ipairs(self.evasData) do
--        if eva.id == v.id then
--            self.evasData[i] = eva
--            break
--        end
--    end
--end

-- 更新Eva属性界面
--function CompanyMgr:UpdateMyEvaProperty(eva)
--    for _, v in ipairs(self.propertyItems) do
--        if eva.id == v.data.id then
--            v.data = eva
--            v:ShowData(v.data.lv, v.data.cexp)
--            break
--        end
--    end
--end

-- 重置Eva属性的小提示
function CompanyMgr:ClsoeTips()
    for _, v in ipairs(self.propertyItems) do
        if v.IsShowTips then
            v:IsShowTips(false)
        end
    end
end

-- 获取品牌选项item
function CompanyMgr:GetBrandTitleItem()
    return self.brandTitleItem
end

-- 生成品牌选项item
function CompanyMgr:CreateBrandTitleItem()
    self.brandTitleItem = {}
    for i = 1, self.brandTitleItemNumber do
        local function callback(obj)
            self.brandTitleItem[i] = BrandTitleItem:new(obj, i)
            if i == self.brandTitleItemNumber then
                DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_QueryMyBrands')
            end
        end
        DynamicLoadPrefab("Assets/CityGame/Resources/View/Company/BrandTitleItem.prefab", CompanyPanel.brandTitleContent, nil, callback)
    end
end

-- 保存品牌数据
function CompanyMgr:SetBrandData(MyAllBrands)
    self.brandData = MyAllBrands
end

-- 品牌默认选择
function CompanyMgr:SetBrandDefaultState()
    --CompanyPanel.optionOneRt.anchoredPosition = Vector2.New(0,0)
    self.brandTitleItem[1]:_setContent()
end

-- 获得品牌大小
function CompanyMgr:GetBrandSizeNum()
    return self.brandSizeNum
end

-- 设置品牌大小
function CompanyMgr:SetBrandSizeNum(brandSizeNum)
    if brandSizeNum == 1 then
        CompanyPanel.sizeBtnText.text = GetLanguage(18040001) -- "Small"
        CompanyPanel.choiceOBtnText.text = GetLanguage(18040002) -- "Medium"
        CompanyPanel.choiceTBtnText.text = GetLanguage(18040003) -- "Large"
    elseif brandSizeNum == 2 then
        CompanyPanel.sizeBtnText.text = GetLanguage(18040002) -- "Medium"
        CompanyPanel.choiceOBtnText.text = GetLanguage(18040001) -- "Small"
        CompanyPanel.choiceTBtnText.text = GetLanguage(18040003) -- "Large"
    elseif brandSizeNum == 3 then
        CompanyPanel.sizeBtnText.text = GetLanguage(18040003) -- "Large"
        CompanyPanel.choiceOBtnText.text = GetLanguage(18040001) -- "Small"
        CompanyPanel.choiceTBtnText.text = GetLanguage(18040002) -- "Medium"
    end
    CompanyPanel.sizeBg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic)
    CompanyPanel.sizeBtnImage:DORotate(Vector3.New(0,0,180),0.1):SetEase(DG.Tweening.Ease.OutCubic)
    self.brandSizeNum = brandSizeNum
end

-- 显示品牌
function CompanyMgr:ShowBrandItem(index)
    self.brandTypeNum = index
    if index == 1 then
        CompanyPanel.brandScrollContent.cellSize = Vector2.New(746, 260)
        self.partBrandData = self.brandData["materialBrand"]
    elseif index == 2 then
        CompanyPanel.brandScrollContent.cellSize = Vector2.New(746, 412)
        self.partBrandData = self.brandData["goodBrand"]
    elseif index == 3 then
        CompanyPanel.brandScrollContent.cellSize = Vector2.New(746, 412)
        self.partBrandData = {}
        for _, v in ipairs(self.brandData["apartmentBrand"]) do
            table.insert(self.partBrandData, v)
        end
        for _, j in ipairs(self.brandData["retailShopBrand"]) do
            table.insert(self.partBrandData, j)
        end
    elseif index == 4 then
        CompanyPanel.brandScrollContent.cellSize = Vector2.New(746, 260)
        self.partBrandData = self.brandData["promotionBrand"]
    elseif index == 5 then
        CompanyPanel.brandScrollContent.cellSize = Vector2.New(746, 260)
        self.partBrandData = self.brandData["labBrand"]
    end
    CompanyCtrl.static.companyMgr.ctrl:ShowBrand(#self.partBrandData)
end

-- 重置品牌标题字的颜色
function CompanyMgr:SetBrandTitleNameTextColor()
    for _, v in ipairs(self.brandTitleItem) do
        v:SetSelect(true)
    end
end

-- 获得当前品牌显示的项数记录
function CompanyMgr:GetBrandTypeNum()
    return self.brandTypeNum
end

-- 获得当前人的公司名字
function CompanyMgr:GetCompanyName()
    return self.companyname
end

-- 设置当前人的公司名字
function CompanyMgr:SetCompanyName(name)
    self.companyname = name
end

-- 获得是否是自己
function CompanyMgr:GetIsOwn()
    return self.isOwn
end

-- 设置是否是自己
function CompanyMgr:SetIsOwn(isOwn)
    self.isOwn = isOwn
end

-- 设置改品牌名字
function CompanyMgr:SetBrandName(modyfyMyBrandName)
    for i, v in pairs(self.brandData) do
        for k, j in ipairs(v) do
            if modyfyMyBrandName.typeId == j.itemId then
                self.brandData[i][k].brandName = modyfyMyBrandName.newBrandName
            end
        end
    end
end

-- 获得当前人的id
function CompanyMgr:GetId()
    return self.nowId
end

-- 设置当前人的id
function CompanyMgr:SetId(nowId)
    self.nowId = nowId
end