SystemSettingCtrl = class('SystemSettingCtrl',UIPanel)
UIPanel:ResgisterOpen(SystemSettingCtrl) --How to open the registration

local panel
local LuaBehaviour;
--local CityEngineLua=CityEngineLua

function  SystemSettingCtrl:bundleName()
    return "Assets/CityGame/Resources/View/SystemSettingPanel.prefab"
end

function SystemSettingCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--You can go back and hide other panels after the UI opens
end

function SystemSettingCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function SystemSettingCtrl:Refresh()
    
    local Languagenum = UnityEngine.PlayerPrefs.GetInt("Language")
    if Languagenum == 1 then
        panel:InitDate(GetLanguage(14010005))
    elseif Languagenum == 0 then
        panel:InitDate(GetLanguage(14010004))
    elseif Languagenum == 2 then
        panel:InitDate(GetLanguage(14010006))
    elseif Languagenum == 3 then
        panel:InitDate(GetLanguage(14010007))
    end
end

function  SystemSettingCtrl:Hide()
    UIPanel.Hide(self)
end

function SystemSettingCtrl:Close()
    UIPanel.Close(self)
end
function  SystemSettingCtrl:Awake(go)
    self.gameObject = go
    panel=SystemSettingPanel
    LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    LuaBehaviour:AddClick(panel.backBtn.gameObject,self.c_OnClick_backBtn,self);
    LuaBehaviour:AddClick(panel.LanguageBtn.gameObject,self.c_OnClick_changeLanguage,self);
    LuaBehaviour:AddClick(panel.chineseBtn.gameObject,self.c_OnClick_chinese,self);
    LuaBehaviour:AddClick(panel.englishBtn.gameObject,self.c_OnClick_english,self);
    LuaBehaviour:AddClick(panel.JapaneseBtn.gameObject,self.c_OnClick_Japanese,self);
    LuaBehaviour:AddClick(panel.KoreanBtn.gameObject,self.c_OnClick_Korean,self);
    LuaBehaviour:AddClick(panel.MusicBtnyellosw.gameObject,self.c_OnClick_Music,self);
    LuaBehaviour:AddClick(panel.MusicEffectBtnyellow.gameObject,self.c_OnClick_MusicEffect,self);
    LuaBehaviour:AddClick(panel.MusicBtngrey.gameObject,self.c_OnClickMusic,self);
    LuaBehaviour:AddClick(panel.MusicEffectBtngrey.gameObject,self.c_OnClickMusicEffect,self);
    LuaBehaviour:AddClick(panel.outBtn.gameObject,self.c_OnClickout,self);
    LuaBehaviour:AddClick(panel.backBtn1.gameObject,self.c_OnClick_backBtn1,self);
    LuaBehaviour:AddClick(panel.closeLan.gameObject,self.c_OnClick_backBtn2,self);
    --bubble
    LuaBehaviour:AddClick(panel.bubbleShowBtn.gameObject,self.c_OnClick_BubbleClose,self);
    LuaBehaviour:AddClick(panel.bubbleCloseBtn.gameObject,self.c_OnClick_BubbleShow,self);

end
---========================================================click==============================================================================================
--Bubble fully open
function SystemSettingCtrl:c_OnClick_BubbleShow(ins)
    PlayMusEff(1002)
    panel.bubbleCloseBtn.gameObject:SetActive(false)
    Event.Brocast("c_BuildingBubbleShow")
    SaveBuildingBubbleSettings(BuildingBubbleType.show)
end
--Bubbles off
function SystemSettingCtrl:c_OnClick_BubbleClose(ins)
    PlayMusEff(1002)
    panel.bubbleCloseBtn.gameObject:SetActive(true)
    Event.Brocast("c_BuildingBubbleHide")
    SaveBuildingBubbleSettings(BuildingBubbleType.close)
end

--drop out
function SystemSettingCtrl:c_OnClickout(ins)
    PlayMusEff(1002)
    --Sound effects switch after exiting the game
    PlayMus(1000)
    CityEngineLua.LoginOut()
end
--Open music
function SystemSettingCtrl:c_OnClickMusic(ins)
    self.transform.localScale=Vector3.zero
    panel.MusicBtnyellosw.localScale=Vector3.one
    UnityEngine.PlayerPrefs.SetInt("Music",0)
    PlayMusEff(1002)
    PlayMus(1001)
end
--Open sound effect
function SystemSettingCtrl:c_OnClickMusicEffect(ins)
    self.transform.localScale=Vector3.zero
    panel.MusicEffectBtnyellow.localScale=Vector3.one
    UnityEngine.PlayerPrefs.SetInt("MusicEffect",0)
    PlayMusEff(1002)
end
--music
function SystemSettingCtrl:c_OnClick_Music(ins)
    self.transform.localScale=Vector3.zero
    panel.MusicBtngrey.localScale=Vector3.one
    UnityEngine.PlayerPrefs.SetInt("Music",1)
    PlayMusEff(1002)
    PlayMus(1001)
end
--Sound effects
function SystemSettingCtrl:c_OnClick_MusicEffect(ins)
    self.transform.localScale=Vector3.zero
    panel.MusicEffectBtngrey.localScale=Vector3.one
    UnityEngine.PlayerPrefs.SetInt("MusicEffect",1)
    PlayMusEff(1002)
end
--return
function SystemSettingCtrl:c_OnClick_backBtn(ins)
    UIPanel.ClosePage()
    PlayMusEff(1002)
end
--return
function SystemSettingCtrl:c_OnClick_backBtn1(ins)
    if panel.LanguagePanel.localScale.x == 1  then
        panel.LanguagePanel.localScale=Vector3.zero
        return
    end
    UIPanel.ClosePage()
    PlayMusEff(1002)
end
--return
function SystemSettingCtrl:c_OnClick_backBtn2()
    panel.LanguagePanel.localScale=Vector3.zero
    panel.closeLan.localScale=Vector3.zero
end
--Change language
function SystemSettingCtrl:c_OnClick_changeLanguage()
    PlayMusEff(1002)
    panel.LanguagePanel.localScale = Vector3.one
    panel.closeLan.localScale = Vector3.one
end
--Chinese
function SystemSettingCtrl:c_OnClick_chinese()
    PlayMusEff(1002)
    panel.LanguagePanel.localScale=Vector3.zero
    SaveLanguageSettings(LanguageType.Chinese)
    panel:InitDate(GetLanguage(14010004))
    panel.closeLan.localScale=Vector3.zero
    Event.Brocast("c_ChangeLanguage")  --Broadcast switching language status
end
--English
function SystemSettingCtrl:c_OnClick_english()
    PlayMusEff(1002)
    panel.LanguagePanel.localScale=Vector3.zero
    SaveLanguageSettings(LanguageType.English)
    panel:InitDate(GetLanguage(14010005))
    panel.closeLan.localScale=Vector3.zero
    Event.Brocast("c_ChangeLanguage")  ---Broadcast switching language status
end
--Korean
function SystemSettingCtrl:c_OnClick_Korean()
    PlayMusEff(1002)
    panel.LanguagePanel.localScale=Vector3.zero
    SaveLanguageSettings(LanguageType.Korean)
    panel:InitDate(GetLanguage(14010006))
    panel.closeLan.localScale = Vector3.zero
    Event.Brocast("c_ChangeLanguage")  ---Broadcast switching language status
end
--Japanese
function SystemSettingCtrl:c_OnClick_Japanese()
    PlayMusEff(1002)
    panel.LanguagePanel.localScale=Vector3.zero
    SaveLanguageSettings(LanguageType.Japanese)
    panel:InitDate(GetLanguage(14010007))
    panel.closeLan.localScale = Vector3.zero
    Event.Brocast("c_ChangeLanguage")  ---Broadcast switching language status
end











