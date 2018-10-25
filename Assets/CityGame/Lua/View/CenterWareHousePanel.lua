---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/10/25 10:53
--- 中心仓库
local transform;
local gameObject;

CenterWareHousePanel = {};
local this = CenterWareHousePanel;

--启动事件--
function CenterWareHousePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function CenterWareHousePanel.InitPanel()
    this.backBtn = transform:Find("topRoot/BackButton").gameObject;--返回按钮
    this.content = transform:Find("downRoot/Scroll View/Content").gameObject;
    this.addItem = transform:Find("downRoot/Scroll View/Content/AddItem").gameObject; --扩容按钮
    this.transportBtn = transform:Find("TransportButton").gameObject--运输按钮
end
