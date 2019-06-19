---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/17 16:14
---推广商品Item
PromoteGoodsItem = class('PromoteGoodsItem')
local lastSelete = nil
function PromoteGoodsItem:initialize(prefab,dataInfo,luaBehaviour)
    self.prefab = prefab;
    self.dataInfo = dataInfo;
    self.seleteBtn = self.prefab.transform:Find("seleteBtn").gameObject;
    self.selete = self.prefab.transform:Find("seleteBtn/selete");
    self.icon = self.prefab.transform:Find("iconImg").gameObject:GetComponent("Image");
    self.name = self.prefab.transform:Find("goods/nameBG/nameText").gameObject:GetComponent("Text");
    self.brandScore = self.prefab.transform:Find("goods/detailsBg/scoreBg/brandIcon/brandValue").gameObject:GetComponent("Text");
    self.brand = self.prefab.transform:Find("goods/detailsBg/scoreText").gameObject:GetComponent("Text");

    self.name.text = GetLanguage(dataInfo)
    LoadSprite(Good[dataInfo].img, self.icon)

    if math.floor(dataInfo/1000) == 2251 then
        self.brand.text = GoodsTypeConfig[1].brand[dataInfo].brand
        self.brandScore.text = GoodsTypeConfig[1].brand[dataInfo].brandScore
    elseif math.floor(dataInfo/1000) == 2252 then
        self.brand.text = GoodsTypeConfig[2].brand[dataInfo].brand
        self.brandScore.text = GoodsTypeConfig[2].brand[dataInfo].brandScore
    end

    luaBehaviour:AddClick(self.seleteBtn, self.OnSeleteBtn,self)
end

function PromoteGoodsItem:OnSeleteBtn(go)
    if  lastSelete  then
        lastSelete .localScale = Vector3.zero
    end
    go.selete.localScale = Vector3.one
    lastSelete  = go.selete
    Event.Brocast("c_PromoteGoodsId",go.dataInfo)
end

function PromoteGoodsItem:Close()
    lastSelete = nil
end
