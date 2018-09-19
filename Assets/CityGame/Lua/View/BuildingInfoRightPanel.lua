---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/4 16:56
---
local transform

BuildingInfoRightPanel = {};
local this = BuildingInfoRightPanel;

function BuildingInfoRightPanel.Awake(obj)
    transform = obj.transform;

    this.InitPanel();
    logDebug("右侧信息界面 Awake lua--->>"..transform.name);
end

function BuildingInfoRightPanel.InitPanel()
    this.sizeText = transform:Find("bg/infoRoot/size/text").gameObject:GetComponent("Text");  --建筑大小
    this.buildTimeText = transform:Find("bg/infoRoot/buildTime/text").gameObject:GetComponent("Text");  --建造时间
    this.usedTimeText = transform:Find("bg/infoRoot/usedTime/text").gameObject:GetComponent("Text");  --已经使用的时间
    this.oldPercentText = transform:Find("bg/infoRoot/oldPercent/text").gameObject:GetComponent("Text");  --折旧度

    this.initPanelFinish = true
end

--设置父物体以及位置
function BuildingInfoRightPanel.SetParentTran(parentTran)
    transform:SetParent(parentTran)
    transform.localPosition = Vector3.zero
end

--显示右部的信息
function BuildingInfoRightPanel.InitData(buildRightData)
    this.sizeText.text = buildRightData.width.."x"..buildRightData.height
    this.buildTimeText.text = buildRightData.buildTime
    this.usedTimeText.text = buildRightData.usedTime
    this.oldPercentText.text = buildRightData.oldPercent
end

--界面信息改变 --已经使用的时间&折旧度
function BuildingInfoRightPanel.UpdateInfo(updateInfo)
    this.oldPercentText.text = updateInfo.oldPercent
    this.usedTimeText.text = updateInfo.usedTime
end
