---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/6/3 18:29
---

EvaJoinCtrl = class("EvaJoinCtrl", UIPanel)
UIPanel:ResgisterOpen(EvaJoinCtrl)
EvaJoinCtrl.static.NumberColor = "#09FCFD" -- 介绍特殊颜色
EvaJoinCtrl.static.languageTab = -- 多语言配置表
{
    --{}
}

function EvaJoinCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function EvaJoinCtrl:bundleName()
    return "Assets/CityGame/Resources/View/EvaJoinPanel.prefab"
end

function EvaJoinCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function EvaJoinCtrl:Awake()
    local transform = self.gameObject.transform
    local luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")
    self.goEvaBtn = transform:Find("GoEvaBtn")
    local closeBtn = transform:Find("CloseBtn")
    transform:Find("EvaContentText"):GetComponent("Text").text = string.format("<color=%s><b>%s</b></color>%s", EvaJoinCtrl.static.NumberColor,"Eva", GetLanguage(31010002))
    transform:Find("GoEvaBtn/Text"):GetComponent("Text").text = GetLanguage(31010010)
    transform:Find("EvaTitleText"):GetComponent("Text").text = GetLanguage(31010001)
    transform:Find("EvaText1"):GetComponent("Text").text = GetLanguage(23010001)
    transform:Find("EvaContentText1"):GetComponent("Text").text = GetLanguage(31010044)
    transform:Find("EvaText2"):GetComponent("Text").text = GetLanguage(23010002)
    transform:Find("EvaContentText2"):GetComponent("Text").text = GetLanguage(31010044)
    transform:Find("EvaText3"):GetComponent("Text").text = GetLanguage(23010003)
    transform:Find("EvaContentText3"):GetComponent("Text").text = GetLanguage(31010045)
    transform:Find("EvaText4"):GetComponent("Text").text = GetLanguage(23010004)
    transform:Find("EvaContentText4"):GetComponent("Text").text = GetLanguage(31010045)
    transform:Find("EvaText5"):GetComponent("Text").text = GetLanguage(23010005)
    transform:Find("EvaContentText5"):GetComponent("Text").text = GetLanguage(31010046)
    transform:Find("EvaText6"):GetComponent("Text").text = GetLanguage(23010006)
    transform:Find("EvaContentText6"):GetComponent("Text").text = GetLanguage(31010047)
    transform:Find("EvaText7"):GetComponent("Text").text = GetLanguage(23010006)
    transform:Find("EvaContentText7"):GetComponent("Text").text = GetLanguage(31010001) .. GetLanguage(31010031)

    luaBehaviour:AddClick(self.goEvaBtn.gameObject, self.OnGoEva, self)
    luaBehaviour:AddClick(closeBtn.gameObject, self.OnClose, self)
end

-- 跳转Eva界面
function EvaJoinCtrl:OnGoEva(go)
    PlayMusEff(1002)
    UIPanel.ClosePage()
    ct.OpenCtrl("EvaCtrl")
end

-- 显示GoEva
function EvaJoinCtrl:OnClose(go)
    PlayMusEff(1002)
    self.transform.localScale = Vector3.zero
    go.goEvaBtn:DOScale(Vector3.New(1,1,1),0.5):SetEase(DG.Tweening.Ease.OutCubic)
end