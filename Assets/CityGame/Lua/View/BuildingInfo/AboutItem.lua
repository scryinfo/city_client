---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/12/21/021 18:22
---

AboutItem = class('AboutItem')

local fontPath="Atlas/GuidBook/main/button-"
---初始化方法   数据（读配置表）
function AboutItem:initialize(prefab,luabehaviour,name)
    self.name = name;
    self.Image=prefab.transform:GetComponent("Image")
    local path=split(name,",")
    --self.Image.sprite=

    --self.nameText=prefab.transform:Find("Text"):GetComponent("Text");
    --
    --self.nameText.text=name
    luabehaviour:AddClick(prefab, self.OnClick_Add, self);
end
---添加
function AboutItem:OnClick_Add(ins)
    ct.OpenCtrl("DetailGuidCtrl",ins)
end

