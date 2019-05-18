---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/5/16 17:00
---原料厂建筑信息
materialFactoryItem = class('materialFactoryItem')

function materialFactoryItem:initialize(dataInfo,prefab,luaBehaviour)
    self.dataInfo = dataInfo
    self.prefab = prefab

    self.materialIntroduceBtn = prefab.transform:Find("materialIntroduceBtn")
    self.materialText = prefab.transform:Find("materialIntroduceBtn/materialText"):GetComponent("Text")
    self.basisProduceRateTextBtn = prefab.transform:Find("basisProduceRateText"):GetComponent("Text")
    self.produceBounusTextBtn = prefab.transform:Find("basisProduceRateText/symbol/produceBounusText"):GetComponent("Text")

    self:language()
    luaBehaviour:AddClick(self.basisProduceRateTextBtn.gameObject,self._clickBasisProduceRateTextBtn,self)
    luaBehaviour:AddClick(self.produceBounusTextBtn.gameObject,self._clickproduceBounusTextBtn,self)
end
--多语言
function materialFactoryItem:language()
    self.materialText.text = "原材料"
    self.basisProduceRateTextBtn.text = "基本的生产速度"
    self.produceBounusTextBtn.text = "生产加成"
end
function materialFactoryItem:_clickBasisProduceRateTextBtn(ins)
    local stringKey = 27010005
    Event.Brocast("openTipBox",stringKey,ins.basisProduceRateTextBtn.transform.localPosition,ins.basisProduceRateTextBtn.transform)
end
function materialFactoryItem:_clickproduceBounusTextBtn(ins)
    local stringKey = 27010005
    Event.Brocast("openTipBox",stringKey,ins.produceBounusTextBtn.transform.localPosition,ins.produceBounusTextBtn.transform)
end