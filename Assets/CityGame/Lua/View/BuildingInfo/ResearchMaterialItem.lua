---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/23 18:48
---

ResearchMaterialItem = class("ResearchMaterialItem")

-- 初始化
function ResearchMaterialItem:initialize(prefab, data, index,  buildingId)
    self.prefab = prefab
    data.index = index
    self.data = data
    self.buildingId = buildingId

    self.transform = prefab.transform
    self.iconImage = self.transform:Find("IconImage"):GetComponent("Image")
    self.numText = self.transform:Find("NumText"):GetComponent("Text")
    self.nameText = self.transform:Find("NameText"):GetComponent("Text")
    self.priceText = self.transform:Find("PriceText"):GetComponent("Text")


    self:ShowView()
    self.btn = self.transform:GetComponent("Button")
    self.btn.onClick:AddListener(function ()
        self:_clickPrefab()
    end)
end

function ResearchMaterialItem:ShowView()
    if self.data.index == 1 then   -- 货架选择界面
        self.nameText.text = ResearchConfig[self.data.itemKey.id].name
        LoadSprite(ResearchConfig[self.data.itemKey.id].iconPath, self.iconImage , true)
        self.numText.text = "X" .. tostring(self.data.storeNum)
    elseif self.data.index == 2 then   -- 仓库显示界面
        self.nameText.text = ResearchConfig[self.data.itemKey.id].name
        LoadSprite(ResearchConfig[self.data.itemKey.id].iconPath, self.iconImage , true)
        self.numText.text = "X" .. tostring(self.data.storeNum + self.data.lockedNum)
    elseif self.data.index == 3 or self.data.index == 4 then   -- 货架显示界面
        self.nameText.text = ResearchConfig[self.data.k.id].name
        LoadSprite(ResearchConfig[self.data.k.id].iconPath, self.iconImage , true)
        self.numText.text = "X" .. tostring(self.data.n)
        self.priceText.text = "E" .. GetClientPriceString(self.data.price)
        self.autoImageTF = self.transform:Find("AutoImage")
        self.autoImage = self.transform:Find("AutoImage"):GetComponent("Image")
        self.autoImageText = self.transform:Find("AutoImage/Text"):GetComponent("Text")

        if self.data.autoReplenish then -- 打开了自动补货
            self.autoImageTF.localScale = Vector3.one
            if self.data.lockedNum == 0 then
                self.autoImageText.text = "vacant!"
                local autoImageTextPreferredWidth = self.autoImageText.preferredWidth
                self.autoImageTF.sizeDelta = Vector2.New(autoImageTextPreferredWidth + 60, 40)
                self.autoImage.color = getColorByVector3(Vector3.New(172,0,0))
            else
                self.autoImageTF.sizeDelta = Vector2.New(60, 40)
                self.autoImageText = ""
                self.autoImage.color = getColorByVector3(Vector3.New(0,172,138))
            end
        else
            self.autoImageTF.localScale = Vector3.zero
        end
    end
end

-- 点击item，打开使用界面，使用研究资料以后即可获得eva点数
function ResearchMaterialItem:_clickPrefab()
    if self.data.index == 1 then   -- 货架选择界面
        ct.OpenCtrl("ResearchSaleCtrl",{buildingId = self.buildingId , data = self.data})
    elseif self.data.index == 2 then   -- 仓库显示界面
        local temp = {}
        temp.wareHouse = self.data.storeNum
        temp.sale = self.data.lockedNum
        temp.itemId = self.data.itemKey.id
        temp.myOwner = true
        temp.userFunc = function(num)
            DataManager.DetailModelRpcNoRet(self.buildingId, 'm_userData',self.buildingId, self.data.itemKey.id,num)
        end
        ct.OpenCtrl("UserDataCtrl",temp)
    elseif self.data.index == 3 then   -- 货架选择界面
        ct.OpenCtrl("ResearchSaleCtrl",{buildingId = self.buildingId , data = self.data})
    elseif self.data.index == 4 then   -- 别人上货架购买使用界面
        local temp = {}
        temp.sale = self.data.n
        temp.itemId = self.data.k.id
        temp.myOwner = false
        temp.price = self.data.price
        temp.buyFunc = function(num,price)
            DataManager.DetailModelRpcNoRet(self.buildingId, 'm_buyData', self.buildingId, self.data.k.id, num, price, DataManager.GetMyOwnerID())
        end
        ct.OpenCtrl("UserDataCtrl",temp)
    end
end