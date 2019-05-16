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
    this.Music = MusicManger.GetMusicAudioSource()
    this.MusicEffect= MusicManger.GetMusicEffectAudioSource()

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
---
    this.LanguageBtn = transform:Find("Panel/bodyRoot/bg/body/LanguagetBtn/musicyellow");
    this.LanguageText = transform:Find("Panel/bodyRoot/bg/body/LanguagetBtn/Text"):GetComponent("Text")
    this.LanguageBtnText = transform:Find("Panel/bodyRoot/bg/body/LanguagetBtn/musicyellow/Text"):GetComponent("Text")

    this.LanguagePanel = transform:Find("Panel/bodyRoot/bg/languange")

    this.chineseBtnText = transform:Find("Panel/bodyRoot/bg/languange/bg/Scroll View/Viewport/Content/Chinese/Text"):GetComponent("Text")
    this.chineseBtn = transform:Find("Panel/bodyRoot/bg/languange/bg/Scroll View/Viewport/Content/Chinese")

    this.englishBtnText = transform:Find("Panel/bodyRoot/bg/languange/bg/Scroll View/Viewport/Content/English/Text"):GetComponent("Text")
    this.englishBtn = transform:Find("Panel/bodyRoot/bg/languange/bg/Scroll View/Viewport/Content/English")
---气泡
    this.bubbleBtn = transform:Find("Panel/bodyRoot/bg/body/bubbleBtn/musicyellow");
    this.bubbleText = transform:Find("Panel/bodyRoot/bg/body/bubbleBtn/Text"):GetComponent("Text")
    this.bubbleBtnText = transform:Find("Panel/bodyRoot/bg/body/bubbleBtn/musicyellow/Text"):GetComponent("Text")

    this.bubblePanel = transform:Find("Panel/bodyRoot/bg/bubble")

    this.allBigBtnText = transform:Find("Panel/bodyRoot/bg/bubble/bg/Scroll View/Viewport/Content/allBig/Text"):GetComponent("Text")
    this.allBigBtn = transform:Find("Panel/bodyRoot/bg/bubble/bg/Scroll View/Viewport/Content/allBig")

    this.allSmallBtnText = transform:Find("Panel/bodyRoot/bg/bubble/bg/Scroll View/Viewport/Content/allSmall/Text"):GetComponent("Text")
    this.allSmallBtn = transform:Find("Panel/bodyRoot/bg/bubble/bg/Scroll View/Viewport/Content/allSmall")

    this.allCloseBtnText = transform:Find("Panel/bodyRoot/bg/bubble/bg/Scroll View/Viewport/Content/allClose/Text"):GetComponent("Text")
    this.allCloseBtn = transform:Find("Panel/bodyRoot/bg/bubble/bg/Scroll View/Viewport/Content/allClose")
end
--数据初始化
function SystemSettingPanel:InitDate(string)
        this.titleText.text=GetLanguage(14010001)
        this.outText.text=GetLanguage(14010005)
        this.MusicText.text=GetLanguage(14010003)
        this.MusicEffectBtnText.text=GetLanguage(14010002)
        this.LanguageText.text=GetLanguage(14010004)
        this.LanguageBtnText.text=GetLanguage(14010008,string)
        this.chineseBtnText.text=GetLanguage(14010006)
        this.englishBtnText.text=GetLanguage(14010007)
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