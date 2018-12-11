---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/28 15:12
---城市信息原料界面
local transform;
local gameObject;

CityMaterialPanel = {};
local this = CityMaterialPanel;

--启动事件--
function CityMaterialPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function CityMaterialPanel.InitPanel()
    this.backBtn = transform:Find("top/backBtn").gameObject;--返回按钮
    this.time = transform:Find("top/time/timeText").gameObject:GetComponent("Text"); -- 时间
    this.materialScroll = transform:Find("down/scrollRoot/scroll"):GetComponent("ActiveLoopScrollRect")
    this.down = transform:Find("down").gameObject:GetComponent("RectTransform")
    this.toggle = transform:Find("toggle").gameObject:GetComponent("RectTransform")
    this.title = transform:Find("toggle/title"):GetComponent("GridSort");
    this.company = transform:Find("down/cityinfoName"):GetComponent("GridSort");
    this.content = transform:Find("down/scrollRoot/scroll/content").gameObject:GetComponent("VerticalLayoutGroup")
    this.materialLoop = transform:Find("down/scrollRoot/scroll"):GetComponent("LoopVerticalScrollRect")
   -- this.cityName = transform:Find("down/cityinfoName"):GetComponent("GridSort")

end
