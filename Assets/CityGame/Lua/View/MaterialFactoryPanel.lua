---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/11 14:30
---
-----
local transform;
MaterialFactoryPanel = {};
local this = MaterialFactoryPanel;

function MaterialFactoryPanel.Awake(obj)
    transform = obj.transform;
    this.InitPanel();
end

function MaterialFactoryPanel.InitPanel()
    this.groupTrans = transform:Find("bottomRoot")
    this.topRootTrans = transform:Find("topRoot")
    this.topItem = BuildingUpperItem:new(transform:Find("topRoot/BuildingUpperItem"))

    this.openBusinessItem = OpenBusinessBtnItem:new(transform:Find("topRoot/OpenBusinessItem"))
end