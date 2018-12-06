---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/15 14:51
--- 没有消息面板
local transform;
local gameObject;

NoMessagePanel = {};
local this = NoMessagePanel;

--启动事件--
function NoMessagePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function NoMessagePanel.InitPanel()
    this.bgBtn = transform:Find("bg").gameObject;--背景
    this.xBtn = transform:Find("left/XButton").gameObject;
    this.content = transform:Find("left/Content").gameObject:GetComponent("Text");
end