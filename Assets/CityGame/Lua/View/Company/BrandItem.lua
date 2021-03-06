---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/5/11 17:51
---

-- 公司、我的品牌、品牌类型显示，可以点击，显示该类品牌
BrandItem = class("BrandItem")
BrandItem.static.brandIcon = -- icon显示配置
{
    [13] = "Assets/CityGame/Resources/Atlas/Company/SuperMarket_3x3.png",
    [14] = "Assets/CityGame/Resources/Atlas/Company/HomeHouse_3X3.png",
    [1613] = "Assets/CityGame/Resources/Atlas/Company/SuperMarket_3x3.png",
    [1614] = "Assets/CityGame/Resources/Atlas/Company/HomeHouse_3X3.png",
    [1651] = "Assets/CityGame/Resources/Atlas/Company/icon-food.png",
    [1652] = "Assets/CityGame/Resources/Atlas/Company/icon-clothes.png",
    [155] = "Assets/CityGame/Resources/Atlas/Company/icon-goods.png",
    [156] = "Assets/CityGame/Resources/Atlas/Company/icon-eva1.png",
}

-- 初始化
function BrandItem:initialize(prefab, data)
    self.prefab = prefab
    self.data = data

    local transform = prefab.transform
    self.iconImage = transform:Find("IconImage"):GetComponent("Image")
    self.titleText = transform:Find("TitleText"):GetComponent("Text")
    self.brandNameText = transform:Find("BrandNameText"):GetComponent("Text")
    self.contentText = transform:Find("ContentText"):GetComponent("Text")
    self.renameBtnT = transform:Find("RenameBtn")
    self.renameBtn = transform:Find("RenameBtn"):GetComponent("Button")
    self.qualityImage = transform:Find("QualityImage")
    self.reputationImage = transform:Find("ReputationImage")
    transform:Find("QualityImage/QualityTitleText"):GetComponent("Text").text = GetLanguage(18040008)
    self.qualityText = transform:Find("QualityImage/QualityText"):GetComponent("Text")
    transform:Find("ReputationImage/ReputationText"):GetComponent("Text").text = GetLanguage(18040009)
    self.reputationText = transform:Find("ReputationImage/ReputationText"):GetComponent("Text")

    self.brandTypeNum = CompanyCtrl.static.companyMgr:GetBrandTypeNum()
    -- 显示不同建筑的图片
    local imgPath
    if self.brandTypeNum == 1 then
        imgPath = Material[data.itemId].img
    elseif self.brandTypeNum == 2 then
        imgPath = Good[data.itemId].img
    else
        imgPath = BrandItem.static.brandIcon[data.itemId]
    end
    LoadSprite(imgPath, self.iconImage, true)
    if self.brandTypeNum == 1 or self.brandTypeNum == 2 then
        self.iconImage.transform.localScale = Vector3.New(0.5, 0.5, 1)
    else
        self.iconImage.transform.localScale = Vector3.New(1, 1, 1)
    end

    -- 品牌名字
    local str = data.brandName
    if str == nil then
        str = CompanyCtrl.static.companyMgr:GetCompanyName()
    end
    self.brandNameText.text = str

    -- 品牌效果
    --self.contentText.text = "生产速度：10个/s"

    -- 给品牌重命名
    if CompanyCtrl.static.companyMgr:GetIsOwn() then
        self.renameBtn.onClick:RemoveAllListeners()
        self.renameBtn.onClick:AddListener(function ()
            self:_ReName()
        end)
        self.renameBtnT.localScale = Vector3.one
    else
        self.renameBtnT.localScale = Vector3.zero
    end

    if self.brandTypeNum == 2 or self.brandTypeNum == 3 then
        self.qualityImage.localScale = Vector3.one
        self.reputationImage.localScale = Vector3.one
    else
        self.qualityImage.localScale = Vector3.zero
        self.reputationImage.localScale = Vector3.zero
    end

    self.evaBaseValueData = {}
    for _, v in ipairs(EvaBaseData) do
        if v.Atype == self.data.itemId then
            self.evaBaseValueData[v.Btype] = v.basevalue
        end
    end
    self:ShowContent()
end

-- 给品牌重命名
function BrandItem:_ReName()
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(18040005)
    data.tipInfo = GetLanguage(18040006)
    data.btnCallBack = function(text)
        if text == nil or text == "" then
            Event.Brocast("SmallPop", "输入为空",80)
            return
        end
        DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_ModyfyMyBrandName', { pId = DataManager.GetMyOwnerID(),typeId = self.data.itemId, newBrandName = text})
    end
    ct.OpenCtrl("CompanyInputCtrl", data)
end

function BrandItem:ShowContent()
    local brandSizeNum = CompanyCtrl.static.companyMgr:GetBrandSizeNum()
    if brandSizeNum == 1 then
        brandSizeNum = 100
    elseif brandSizeNum == 2 then
        brandSizeNum = 400
    elseif brandSizeNum == 3 then
        brandSizeNum = 900
    end
    --local basevalue = 1
    for i, v in ipairs(self.data.eva) do
        if v.bt == "Quality" then
            if v.at < 2100000 then -- 建筑品质加成
                self.qualityText.text = string.format( "%.2f", (1 + EvaUp[v.lv].add / 100000) * self.evaBaseValueData[v.bt] * brandSizeNum)
            else -- 商品品质值
                self.qualityText.text = string.format( "%.2f",EvaUp[v.lv].add / 1000 * self.evaBaseValueData[v.bt])
            end
        elseif v.bt == "Brand" then
            self.reputationText.text = tostring(v.b)
        elseif v.bt == "ProduceSpeed" then
            self.titleText.text = "ProduceSpeed"
            self.contentText.text = math.floor((1 / ((1 + EvaUp[v.lv].add / 100000) * self.evaBaseValueData[v.bt])) / brandSizeNum) .. "s/个"
        elseif v.bt == "PromotionAbility" then
            self.titleText.text = "PromotionAbility"
            self.contentText.text = math.floor((1 + EvaUp[v.lv].add / 100000) * self.evaBaseValueData[v.bt] * brandSizeNum) .. "s/个"
        elseif v.bt == "InventionUpgrade" then
            self.titleText.text = "InventionUpgrade"
            self.contentText.text = math.floor(((1 + EvaUp[v.lv].add / 100000) * (self.evaBaseValueData[v.bt] / 100000)) * 100 * brandSizeNum) .. "%"
        elseif v.bt == "EvaUpgrade" then
            self.titleText.text = "EvaUpgrade"
            self.contentText.text = math.floor(((1 + EvaUp[v.lv].add / 100000) * (self.evaBaseValueData[v.bt] / 100000)) * 100 * brandSizeNum) .. "%"
        elseif v.bt == "WarehouseUpgrade" then
            self.titleText.text = "WarehouseUpgrade"
            self.contentText.text = math.floor((1 + EvaUp[v.lv].add / 100000) * self.evaBaseValueData[v.bt] * brandSizeNum)
        end
    end
end

function BrandItem:ChangeName(modyfyMyBrandName)
    if modyfyMyBrandName.typeId == self.data.itemId then
        self.brandNameText.text = modyfyMyBrandName.newBrandName
    end
end