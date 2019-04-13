---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/11 16:22
---推广公司建筑扩展
local transform;
local gameObject;

PromoteBuildingExtensionPanel = {};
local this = PromoteBuildingExtensionPanel;
--启动事件--
function PromoteBuildingExtensionPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function PromoteBuildingExtensionPanel.InitPanel()
    this.xBtn = transform:Find("contentRoot/top/xBtn").gameObject
    this.supermarket = transform:Find("contentRoot/supermarket")    --零售店
    this.house = transform:Find("contentRoot/house")    --住宅
    this.time = transform:Find("contentRoot/time/InputField"):GetComponent("InputField")     --时间

end