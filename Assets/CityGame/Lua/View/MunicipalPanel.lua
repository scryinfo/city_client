---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/23/023 11:20
---


require "Common/define"

local transform;

MunicipalPanel = {};
local this = MunicipalPanel;

function MunicipalPanel.Awake(obj)
    transform = obj.transform;
    --this.InitPanel();
    this.InitPanel();
end

function MunicipalPanel.InitPanel()
    this.rightRootTran = transform:Find("rightRoot");
    this.leftRootTran = transform:Find("leftRoot");
    this.middleRootTran = transform:Find("middleRoot");
    this.topRootTran = transform:Find("topRoot");
    this.buildingTypeNameText = transform:Find("topRoot/titleBg/buildingTypeNameText"):GetComponent("Text");
    this.nameText = transform:Find("topRoot/titleBg/nameText"):GetComponent("Text");
    this.changeNameBtn = transform:Find("topRoot/titleBg/changeNameBtn");
    this.backBtn = transform:Find("topRoot/backBtn");
    this.infoBtn = transform:Find("topRoot/infoBtn");
end
--数据初始化
function MunicipalPanel.InitDate(MunicipalData)
    this.materialData = MunicipalData;
end