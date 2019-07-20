---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/7/20 16:04
---公司流水建筑item
local class = require 'Framework/class'
require('Framework/UI/UIPage')
CompanyBuildingItem = class('CompanyBuildingItem')

local lastBg

--初始化方法   数据（读配置表）
function CompanyBuildingItem:initialize(inluabehaviour, prefab, goodsDataInfo)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour

    self.bg = self.prefab.transform:Find("bg").gameObject
    self.unSelectBg = self.prefab.transform:Find("unSelectBg")
    self.unSelect = self.prefab.transform:Find("unSelectBg/Text"):GetComponent("Text");
    self.selectBg = self.prefab.transform:Find("selectBg")
    self.select = self.prefab.transform:Find("selectBg/Text"):GetComponent("Text");

    self.unSelect.text = GetLanguage(goodsDataInfo.name)
    self.select.text = GetLanguage(goodsDataInfo.name)

    self._luabehaviour:AddClick(self.bg, self.OnBg, self);
end

function CompanyBuildingItem:OnBg(go)
    PlayMusEff(1002)
    if lastBg then
        lastBg.unSelectBg.localScale = Vector3.one
        lastBg.selectBg.localScale = Vector3.zero
    end
    go.unSelectBg.localScale = Vector3.zero
    go.selectBg.localScale = Vector3.one
    lastBg = go
end