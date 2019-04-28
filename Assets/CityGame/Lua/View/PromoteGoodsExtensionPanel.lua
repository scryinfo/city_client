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
    this.curve = transform:Find("contentRoot/curveBg").gameObject     --曲线图
    this.popularity = transform:Find("contentRoot/curveBg/popularity"):GetComponent("Text")     --加成
    this.queue = transform:Find("contentRoot/queue").gameObject     --确定(自己)
    this.myTime = transform:Find("contentRoot/time")     --时间(自己)
    this.time = transform:Find("contentRoot/time/InputField"):GetComponent("InputField")     --时间
    this.title = transform:Find("contentRoot/title/tltleText"):GetComponent("Text")     --推广加成
    this.otherTimeBg = transform:Find("contentRoot/otherTime")    --别人打开的时间
    this.otherTime = transform:Find("contentRoot/otherTime/time/InputField"):GetComponent("InputField")     --别人打开的时间
    this.slider = transform:Find("contentRoot/otherTime/Slider"):GetComponent("Slider")
    this.content = transform:Find("contentRoot/Scroll View/Viewport/Content"):GetComponent("RectTransform")
    this.select = transform:Find("contentRoot/select"):GetComponent("Text")
    this.moneyBg = transform:Find("contentRoot/moneyBg")   --别人打开的money
    this.money = transform:Find("contentRoot/moneyBg/moneyImage/moneyText"):GetComponent("Text")   --money
    this.otherQueue = transform:Find("contentRoot/moneyBg/queue").gameObject   --确定(别人)

end