---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/5/17 16:21
---Residential building information  --Directly copied retailStoreItem
houseBuildingInfoItem = class('houseBuildingInfoItem')

function houseBuildingInfoItem:initialize(dataInfo,prefab,luaBehaviour,isOther)
    self.dataInfo = dataInfo
    self.prefab = prefab

    self.scoreBtn = prefab.transform:Find("score")
    self.scoreText = prefab.transform:Find("score/scoreText"):GetComponent("Text")
    self.retailStoreIntroduceBtn = prefab.transform:Find("retailStoreIntroduceBtn")
    self.retailStoreText = prefab.transform:Find("retailStoreIntroduceBtn/retailStoreText"):GetComponent("Text")
    self.basicQualityTextBtn = prefab.transform:Find("basicQualityText"):GetComponent("Text")
    self.symbol = prefab.transform:Find("basicQualityText/symbol")
    self.qualityAdditionTextBtn = prefab.transform:Find("basicQualityText/symbol/qualityAdditionText"):GetComponent("Text")
    self.popolarityTextBtn = prefab.transform:Find("popolarityText"):GetComponent("Text")

    self:getBuildingScore()
    self:language()

    luaBehaviour:AddClick(self.basicQualityTextBtn.gameObject,self._clickBasicQualityTextBtn,self)
    luaBehaviour:AddClick(self.qualityAdditionTextBtn.gameObject,self._clickQualityAdditionTextBtn,self)
    luaBehaviour:AddClick(self.popolarityTextBtn.gameObject,self._clickPopolarityTextBtn,self)

    --Whether it is the building owner, if not, all buttons cannot be clicked
    if isOther ~= DataManager.GetMyOwnerID() then
        self.scoreBtn:GetComponent("Button").interactable = false
        self.retailStoreIntroduceBtn:GetComponent("Button").interactable = false
        self.basicQualityTextBtn:GetComponent("Button").interactable = false
        self.qualityAdditionTextBtn:GetComponent("Button").interactable = false
        self.popolarityTextBtn:GetComponent("Button").interactable = false
    end
end
function houseBuildingInfoItem:getBuildingScore()
    --Popularity score
    --local famousScore = self.dataInfo.score[1].val / self.dataInfo.score[3].val * 100
    local famousScore = self.dataInfo.score[3].val
    --Quality score
    --local qualityScore = self.dataInfo.score[4].val * (1 + self.dataInfo.score[5].val) / self.dataInfo.score[6].val * 100
    local qualityScore = self.dataInfo.score[6].val
    --Total building score
    self.scoreText.text = math.ceil((famousScore + qualityScore) / 2)
    --Current building quality
    --self.buildingQuality = self.dataInfo.score[4].val * (1 + self.dataInfo.score[5].val)
    self.buildingQuality = self.dataInfo.score[6].val
end
function houseBuildingInfoItem:language()
    self.symbol.transform.localScale = Vector3.zero
    self.retailStoreText.text = GetLanguage(30050006)
    --self.basicQualityTextBtn.text = GetLanguage(30040002).." "..self.buildingQuality.."(".."+"..self.dataInfo.score[5].val / 100 .."%"..")"
    self.basicQualityTextBtn.text = GetLanguage(30040002).." "..self.buildingQuality  --temp
    self.qualityAdditionTextBtn.transform.localScale = Vector3.zero
    self.popolarityTextBtn.text = GetLanguage(30040003).." "..self.dataInfo.score[3].val
end
function houseBuildingInfoItem:_clickBasicQualityTextBtn(ins)
    local stringKey = 30040004
    Event.Brocast("openTipBox",stringKey,ins.basicQualityTextBtn.transform.localPosition,ins.basicQualityTextBtn.transform)
end
function houseBuildingInfoItem:_clickQualityAdditionTextBtn(ins)
    local stringKey = 27010005
    Event.Brocast("openTipBox",stringKey,ins.qualityAdditionTextBtn.transform.localPosition,ins.qualityAdditionTextBtn.transform)
end
function houseBuildingInfoItem:_clickPopolarityTextBtn(ins)
    local stringKey = 30040005
    Event.Brocast("openTipBox",stringKey,ins.popolarityTextBtn.transform.localPosition,ins.popolarityTextBtn.transform)
end