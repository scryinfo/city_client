SystemSettingCtrl = class('SystemSettingCtrl',UIPage)
UIPage:ResgisterOpen(SystemSettingCtrl) --注册打开的方法

local LuaBehaviour;

function  SystemSettingCtrl:bundleName()
    return "SystemSettingPanel"
end

function SystemSettingCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
end
local panel
--启动事件--
function SystemSettingCtrl:OnCreate(obj)
    panel=SystemSettingPanel
    self.Music=UnityEngine.GameObject.FindGameObjectWithTag("Music").transform:GetComponent("AudioSource")
    self.MusicEffect=UnityEngine.GameObject.FindGameObjectWithTag("Musiceffect").transform:GetComponent("AudioSource")
    UIPage.OnCreate(self,obj)
    LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    LuaBehaviour:AddClick(panel.backBtn.gameObject,self.c_OnClick_backBtn,self);
    LuaBehaviour:AddClick(panel.LanguageBtn.gameObject,self.c_OnClick_changeLanguage,self);
    LuaBehaviour:AddClick(panel.chineseBtn.gameObject,self.c_OnClick_chinese,self);
    LuaBehaviour:AddClick(panel.englishBtn.gameObject,self.c_OnClick_english,self);
    LuaBehaviour:AddClick(panel.MusicBtnyellosw.gameObject,self.c_OnClick_Music,self);
    LuaBehaviour:AddClick(panel.MusicEffectBtnyellow.gameObject,self.c_OnClick_MusicEffect,self);
    LuaBehaviour:AddClick(panel.MusicBtngrey.gameObject,self.c_OnClickMusic,self);
    LuaBehaviour:AddClick(panel.MusicEffectBtngrey.gameObject,self.c_OnClickMusicEffect,self);
    LuaBehaviour:AddClick(panel.outBtn.gameObject,self.c_OnClickout,self);


end

function SystemSettingCtrl:Refresh()
    local Languagenum=UnityEngine.PlayerPrefs.GetInt("Language")
    if Languagenum==0 then
        panel:InitDate(GetLanguage(1000008))
    elseif Languagenum==1 then
        panel:InitDate(GetLanguage(1000007))
    end



end
--退出
function SystemSettingCtrl:c_OnClickout(ins)
    UIPage.ClosePage();
    ct.OpenCtrl("LoginCtrl")

end
--开音乐
function SystemSettingCtrl:c_OnClickMusic(ins)
    self.transform.localScale=Vector3.zero
    panel.MusicBtnyellosw.localScale=Vector3.one
    ins.Music:Play()
    UnityEngine.PlayerPrefs.SetInt("Music",0)
end
--开音效
function SystemSettingCtrl:c_OnClickMusicEffect(ins)
    self.transform.localScale=Vector3.zero
    panel.MusicEffectBtnyellow.localScale=Vector3.one
    ins.MusicEffect:Play()
    UnityEngine.PlayerPrefs.SetInt("MusicEffect",0)
end
--音乐
function SystemSettingCtrl:c_OnClick_Music(ins)
        self.transform.localScale=Vector3.zero
        panel.MusicBtngrey.localScale=Vector3.one
        ins.Music:Stop();
    UnityEngine.PlayerPrefs.SetInt("Music",1)
end
--音效
function SystemSettingCtrl:c_OnClick_MusicEffect(ins)
    self.transform.localScale=Vector3.zero
    panel.MusicEffectBtngrey.localScale=Vector3.one
    ins.MusicEffect:Stop();
    UnityEngine.PlayerPrefs.SetInt("MusicEffect",1)
end

--返回
function SystemSettingCtrl:c_OnClick_backBtn()
    UIPage.ClosePage();
end

--改变语言
function SystemSettingCtrl:c_OnClick_changeLanguage()
    panel.LanguagePanel.localScale=Vector3.one
end

--中文
function SystemSettingCtrl:c_OnClick_chinese()
    panel.LanguagePanel.localScale=Vector3.zero
    SaveLanguageSettings(LanguageType.Chinese)
    panel:InitDate(GetLanguage(1000007))
end
--英文
function SystemSettingCtrl:c_OnClick_english()
    panel.LanguagePanel.localScale=Vector3.zero
    SaveLanguageSettings(LanguageType.English)
    panel:InitDate(GetLanguage(1000008))
end


