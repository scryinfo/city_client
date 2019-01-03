---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/22 16:52
---城市信息
local transform;
local gameObject;

CityInfoPanel = {};
local this = CityInfoPanel;

--启动事件--
function CityInfoPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function CityInfoPanel.InitPanel()
    this.backBtn = transform:Find("top/backBtn").gameObject;--返回按钮
    this.time = transform:Find("top/time/timeText").gameObject:GetComponent("Text"); -- 时间
    this.content = transform:Find("left/Scroll View/Viewport/Content").gameObject:GetComponent("RectTransform");

    this.basicInfo = transform:Find("right/basicInfoItem").gameObject;--总览
    this.cityName = transform:Find("right/basicInfoItem/rightTop/icon/cityName").gameObject:GetComponent("Text"); -- 城市名字
    this.citySize = transform:Find("right/basicInfoItem/rightTop/data/citySize").gameObject:GetComponent("Text"); -- 城市规模
    this.citizenNum = transform:Find("right/basicInfoItem/rightTop/data/citizen").gameObject:GetComponent("Text"); -- 市民数量
    this.man = transform:Find("right/basicInfoItem/rightTop/data/man").gameObject:GetComponent("Text"); -- 男玩家数量
    this.woMan = transform:Find("right/basicInfoItem/rightTop/data/woman").gameObject:GetComponent("Text"); -- 女玩家数量
    this.cityFund = transform:Find("right/basicInfoItem/rightTop/bonuspool/bonuspoolText/Text").gameObject:GetComponent("Text"); -- 城市资金
    this.line = transform:Find("right/basicInfoItem/graph/GameObject/LineChartPanel/Image/Scroll View/Viewport/Content/GameObject"):GetComponent("LineChart");

    this.citizen = transform:Find("right/CitizenItem").gameObject;--市民
    this.btn = transform:Find("right/CitizenItem/averageadultwage/btn").gameObject

    this.right =transform:Find("right").gameObject:GetComponent("RectTransform");

end