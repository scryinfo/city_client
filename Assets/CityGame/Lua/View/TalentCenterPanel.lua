---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/12/21 11:41
---人才中心
local transform
TalentCenterPanel = {}
local this = TalentCenterPanel

function TalentCenterPanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function TalentCenterPanel.InitPanel()
    this.rightRootTran = transform:Find("rightRoot")
    this.leftRootTran = transform:Find("leftRoot")
    this.topRootTran = transform:Find("topRoot")
    this.buildingNameText = transform:Find("topRoot/titleBg/buildingTypeNameText"):GetComponent("Text")
    this.nameText = transform:Find("topRoot/titleBg/nameText"):GetComponent("Text")
    this.changeNameBtn = transform:Find("topRoot/titleBg/changeNameBtn")
    this.backBtn = transform:Find("topRoot/backBtn")
    this.input= transform:Find("topRoot/InputField"):GetComponent("InputField")

end