---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/5/16 17:00
---Raw material plant construction information
materialFactoryItem = class('materialFactoryItem')

function materialFactoryItem:initialize(dataInfo,prefab,luaBehaviour,isOther)
    self.dataInfo = dataInfo
    self.prefab = prefab

    self.materialIntroduceBtn = prefab.transform:Find("materialIntroduceBtn")
    self.materialText = prefab.transform:Find("materialIntroduceBtn/materialText"):GetComponent("Text")
    self.basisProduceRateTextBtn = prefab.transform:Find("basisProduceRateText"):GetComponent("Text")
    self.produceBounusTextBtn = prefab.transform:Find("basisProduceRateText/symbol/produceBounusText"):GetComponent("Text")

    self:language()

    luaBehaviour:AddClick(self.materialIntroduceBtn.gameObject,self._clickMaterialIntroduceBtn,self)
    luaBehaviour:AddClick(self.basisProduceRateTextBtn.gameObject,self._clickBasisProduceRateTextBtn,self)
    luaBehaviour:AddClick(self.produceBounusTextBtn.gameObject,self._clickProduceBounusTextBtn,self)

    --Temporarily close this click
    self.materialIntroduceBtn:GetComponent("Button").interactable = false
    --Whether it is the building owner, if not, all buttons cannot be clicked
    if isOther ~= DataManager.GetMyOwnerID() then
        self.basisProduceRateTextBtn:GetComponent("Button").interactable = false
        self.produceBounusTextBtn:GetComponent("Button").interactable = false
    end
end
--multi-language
function materialFactoryItem:language()
    self.materialText.text = GetLanguage(30020001)
    self.basisProduceRateTextBtn.text = GetLanguage(30020002)
    self.produceBounusTextBtn.text = GetLanguage(30020003)
end
function materialFactoryItem:_clickMaterialIntroduceBtn(ins)
    local data = {}
    data.buildingType = BuildingType.MaterialFactory
    data.dataInfo = ins.dataInfo.material
    ct.OpenCtrl("BuildingGoodsTypeCtrl",data)
end
function materialFactoryItem:_clickBasisProduceRateTextBtn(ins)
    local stringKey = 30020004
    Event.Brocast("openTipBox",stringKey,ins.basisProduceRateTextBtn.transform.localPosition,ins.basisProduceRateTextBtn.transform)
end
function materialFactoryItem:_clickProduceBounusTextBtn(ins)
    local stringKey = 30020005
    Event.Brocast("openTipBox",stringKey,ins.produceBounusTextBtn.transform.localPosition,ins.produceBounusTextBtn.transform)
end