---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/11 17:41
---推广公司商品扩展
local transform;
local gameObject;

PromoteGoodsExtensionPanel = {};
local this = PromoteGoodsExtensionPanel;
--启动事件--
function PromoteGoodsExtensionPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function PromoteGoodsExtensionPanel.InitPanel()
    this.xBtn = transform:Find("contentRoot/top/xBtn").gameObject
    this.curve = transform:Find("contentRoot/curve").gameObject     --曲线图
    this.content = transform:Find("contentRoot/Scroll View/Viewport/Content")
    this.time = transform:Find("contentRoot/time/InputField"):GetComponent("InputField")     --时间
    this.content = transform:Find("contentRoot/Scroll View/Viewport/Content"):GetComponent("RectTransform")

end