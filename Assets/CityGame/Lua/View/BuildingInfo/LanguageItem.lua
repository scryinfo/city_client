---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/5/22 17:04
--- 多语言item
local class = require 'Framework/class'
require('Framework/UI/UIPage')
LanguageItem = class('LanguageItem')
local last = nil

--初始化方法   数据（读配置表）
function LanguageItem:initialize(prefab,data,id,LuaBehaviour)
    self.prefab = prefab
    self.data = data
    self.id = id
    self.LuaBehaviour = LuaBehaviour
    self.unselected = self.prefab.transform:Find("unselected").gameObject
    self.unName = self.prefab.transform:Find("unselected/name"):GetComponent("Text")
    self.selected = self.prefab.transform:Find("selected")
    self.name = self.prefab.transform:Find("selected/name"):GetComponent("Text")
    LuaBehaviour:AddClick(self.unselected, self.OnUnselected,self);

    self.unName.text = GetLanguage(data.name)
    self.name.text = GetLanguage(data.name)
end

function LanguageItem:OnUnselected(go)
    PlayMusEff(1002)
    if last then
        last.localScale = Vector3.zero
    end
    go.selected.localScale = Vector3.one
    last = go.selected
    if go.data.id == 0 then
        SaveLanguageSettings(LanguageType.Chinese)
        LoginPanel.languageText.text = GetLanguage(10020010)
    elseif go.data.id == 1 then
        SaveLanguageSettings(LanguageType.English)
        LoginPanel.languageText.text = GetLanguage(10020011)
    elseif go.data.id == 2 then
        SaveLanguageSettings(LanguageType.Korean)
        LoginPanel.languageText.text = GetLanguage(10020012)
    elseif go.data.id == 3 then
        SaveLanguageSettings(LanguageType.Japanese)
        LoginPanel.languageText.text = GetLanguage(10020013)
    end
    Event.Brocast("c_ChangeLanguage")  --广播切换语言状态
end

function LanguageItem:Set(ins)
    ins.selected.localScale = Vector3.one
    last = ins.selected
end