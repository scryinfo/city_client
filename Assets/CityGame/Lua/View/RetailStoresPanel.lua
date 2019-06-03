---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/11 14:30
---
-----
local transform;
RetailStoresPanel = {};
local this = RetailStoresPanel;

function RetailStoresPanel.Awake(obj)
    transform = obj.transform;
    this.InitPanel();
end

function RetailStoresPanel.InitPanel()
    this.groupTrans = transform:Find("bottomRoot")
    this.topRootTrans = transform:Find("topRoot")
    this.topItem = BuildingUpperItem:new(transform:Find("topRoot/BuildingUpperItem"))

    this.openBusinessItem = OpenBusinessBtnItem:new(transform:Find("topRoot/OpenBusinessItem"))
    this.bubbleMessageBtn = transform:Find("BubbleMessageBtn").gameObject

end