---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/7/29 14:56
--- 调查队列线
SurveyQueneItem = class('SurveyQueneItem')

--初始化方法   数据（读配置表）
function SurveyQueneItem:initialize(inluabehaviour, prefab, goodsDataInfo,building,index)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.building = building
    self.id = goodsDataInfo.id
    self.index = index

    self.icon = self.prefab.transform:Find("icon/iconImage/Image"):GetComponent("Image")
    self.time = self.prefab.transform:Find("icon/time/Text"):GetComponent("Text")
    self.num = self.prefab.transform:Find("slider/Text"):GetComponent("Text")
    self.delete = self.prefab.transform:Find("delete").gameObject
    self.deleteText = self.prefab.transform:Find("delete/Text"):GetComponent("Text")
    self.top = self.prefab.transform:Find("top").gameObject
    self.topText = self.prefab.transform:Find("top/Text"):GetComponent("Text")
    self.name = self.prefab.transform:Find("icon/name/Text"):GetComponent("Text")

    LoadSprite(ResearchConfig[goodsDataInfo.itemId].iconPath, self.icon, true)
    if index == 1 then
        self.top.transform.localScale = Vector3.zero
    end
    --self.time.text = GetLanguage()
    --self.deleteText.text = GetLanguage()
    --self.topText.text = GetLanguage()
    self.num.text = "0/" .. goodsDataInfo.targetCount
    self.name.text = GetLanguage(ResearchConfig[goodsDataInfo.itemId].name)

    self._luabehaviour:AddClick(self.delete, self.OnDelete, self)
    self._luabehaviour:AddClick(self.top, self.OnTop, self)

end

function SurveyQueneItem:OnDelete(go)
    PlayMusEff(1002)
    DataManager.DetailModelRpcNoRet(go.building, 'm_delSurveyLine',go.building,go.id)
end

function SurveyQueneItem:OnTop(go)
    PlayMusEff(1002)
    DataManager.DetailModelRpcNoRet(go.building, 'm_topSurveyLine',go.building,go.id)
end