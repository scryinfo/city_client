---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/12/22/022 11:05
---

BuidBtnItem = class('BuidBtnItem')

---Initialization method data (read configuration table)
function BuidBtnItem:initialize(prefab,luabehaviour,detailCtrl)
    self.prefab=prefab
    self.detailCtrl=detailCtrl
    self.nameText=prefab.transform:Find("Text"):GetComponent("Text");

    luabehaviour:AddClick(prefab, self.OnClick_Add, self);
end

function BuidBtnItem:updateData(topicName,name)
    self.topicName=topicName
    self.name = name

    self.nameText.text=GetLanguage(tonumber(name))
end

---Add to
function BuidBtnItem:OnClick_Add(ins)
    DetailGuidPanel.detailText.text=GetLanguage(tonumber(ins.name))
    DetailGuidPanel.detailIma.localScale=Vector3.one
    DetailGuidPanel.scroll.localScale=Vector3.zero
    --Refresh
   ins.detailCtrl:updateIntroduce(ins.topicName,ins.name)
    PlayMusEff(1002)
end