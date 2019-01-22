---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/12/5/005 10:56
---
require "Common/define"

local transform;

SystemSettingPanel = {};
local this = SystemSettingPanel;

function SystemSettingPanel.Awake(obj)
    transform = obj.transform;
    this.InitPanel();
end

function SystemSettingPanel.InitPanel()
    this.Music=UnityEngine.GameObject.FindGameObjectWithTag("Music").transform:GetComponent("AudioSource")
    this.MusicEffect=UnityEngine.GameObject.FindGameObjectWithTag("Musiceffect").transform:GetComponent("AudioSource")

    this.titleText=transform:Find("Panel/topRoot/bg/Text"):GetComponent("Text")
    this.backBtn = transform:Find("Panel/topRoot/bg/closeBtn");
    this.backBtn1 = transform:Find("BG/Image");
    this.backBtn2 = transform:Find("BG/Image (1)");
    this.closeLan=transform:Find("Panel/bodyRoot/bg/body/closePage")

    this.outBtn = transform:Find("Panel/bodyRoot/bg/bottom/outBtn");
    this.outText= transform:Find("Panel/bodyRoot/bg/bottom/outBtn/Text"):GetComponent("Text")
---

    this.MusicBtnyellosw = transform:Find("Panel/bodyRoot/bg/body/MusicBtn/musicyellow");
    this.MusicBtngrey = transform:Find("Panel/bodyRoot/bg/body/MusicBtn/musicgrey");
    this.MusicText = transform:Find("Panel/bodyRoot/bg/body/MusicBtn/Text"):GetComponent("Text")

    this.MusicEffectBtnyellow = transform:Find("Panel/bodyRoot/bg/body/MusicEffectBtn/musicyellow");
    this.MusicEffectBtngrey = transform:Find("Panel/bodyRoot/bg/body/MusicEffectBtn/musicgrey");
    this.MusicEffectBtnText = transform:Find("Panel/bodyRoot/bg/body/MusicEffectBtn/Text"):GetComponent("Text")

    this.LanguageBtn = transform:Find("Panel/bodyRoot/bg/body/LanguagetBtn/musicyellow");
    this.LanguageText = transform:Find("Panel/bodyRoot/bg/body/LanguagetBtn/Text"):GetComponent("Text")
    this.LanguageBtnText = transform:Find("Panel/bodyRoot/bg/body/LanguagetBtn/musicyellow/Text"):GetComponent("Text")
----
    this.LanguagePanel = transform:Find("Panel/bodyRoot/bg/body/languange")

    this.chineseBtnText = transform:Find("Panel/bodyRoot/bg/body/languange/bg/Scroll View/Viewport/Content/Chinese/Text"):GetComponent("Text")
    this.chineseBtn = transform:Find("Panel/bodyRoot/bg/body/languange/bg/Scroll View/Viewport/Content/Chinese")

    this.englishBtnText = transform:Find("Panel/bodyRoot/bg/body/languange/bg/Scroll View/Viewport/Content/English/Text"):GetComponent("Text")
    this.englishBtn = transform:Find("Panel/bodyRoot/bg/body/languange/bg/Scroll View/Viewport/Content/English")

end
--数据初始化
function SystemSettingPanel:InitDate(string)
        this.titleText.text=GetLanguage(14010001)
        this.outText.text=GetLanguage(14010010)
        this.MusicText.text=GetLanguage(14010003)
        this.MusicEffectBtnText.text=GetLanguage(14010002)
        this.LanguageText.text=GetLanguage(14010004)
        this.LanguageBtnText.text=GetLanguage(14010005,string)
        this.chineseBtnText.text=GetLanguage(14010006)
        this.englishBtnText.text=GetLanguage(14010008)
     local music=UnityEngine.PlayerPrefs.GetInt("Music")
    local musicEffect=UnityEngine.PlayerPrefs.GetInt("MusicEffect")
    if music==0 then
        this.MusicBtnyellosw.localScale=Vector3.one
        this.MusicBtngrey.localScale=Vector3.zero
        this.Music:Play()
    else
        this.MusicBtnyellosw.localScale=Vector3.zero
        this.MusicBtngrey.localScale=Vector3.one
        this.Music:Stop()
    end
    if musicEffect==0 then
        this.MusicEffectBtnyellow.localScale=Vector3.one
        this.MusicEffectBtngrey.localScale=Vector3.zero
        this.Music:Play()
    else
        this.MusicEffectBtnyellow.localScale=Vector3.zero
        this.MusicEffectBtngrey.localScale=Vector3.one
        this.MusicEffect:Stop()
    end
end