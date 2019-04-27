---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/3/29 10:25
---推广公司panel
local transform;
local gameObject;

PromoteCompanyPanel = {};
local this = PromoteCompanyPanel;
--启动事件--
function PromoteCompanyPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function PromoteCompanyPanel.InitPanel()
    this.groupTrans = transform:Find("MainGroup")
    this.back = transform:Find("top/return").gameObject
    this.open = transform:Find("open").gameObject
    this.queue = transform:Find("quene").gameObject
    this.name = transform:Find("top/title/name"):GetComponent("Text")
    this.queneValue = transform:Find("quene/queneImage/queneText/queneValue"):GetComponent("Text")
    this.openBusinessItem = OpenBusinessBtnItem:new(transform:Find("top/OpenBusinessItem"))
end