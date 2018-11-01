---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/25/025 16:11
---

require "Common/define"

local transform;

AdvertisementPosPanel = {};
local this = AdvertisementPosPanel;

function AdvertisementPosPanel.Awake(obj)
    transform = obj.transform;

    this.InitPanel();
end

function AdvertisementPosPanel.InitPanel()
    this.rightRootTran = transform:Find("rightRoot");
    this.leftRootTran = transform:Find("leftRoot");
    this.topRootTran = transform:Find("topRoot");

    this.buildingTypeNameText = transform:Find("topRoot/titleBg/buildingTypeNameText"):GetComponent("Text");
    this.nameText = transform:Find("topRoot/titleBg/nameText"):GetComponent("Text");
    this.changeNameBtn = transform:Find("topRoot/titleBg/changeNameBtn");
    this.backBtn = transform:Find("topRoot/backBtn");
    this.infoBtn = transform:Find("topRoot/infoBtn");

    this.scrollcon=transform:Find("leftRoot/manage/Scroll View/Viewport/Content")
    this.manageBtn=transform:Find("leftRoot/manage/head")

    --自已进入
    this.resizeGO=transform:Find("rightRoot/resize")
    this.confirmBtn=transform:Find("rightRoot/resize/okBtn");
    --他人进入
    this.buyGo=transform:Find("rightRoot/Buy")
    this.confirmBtn1=transform:Find("rightRoot/Buy/body/okBtn");
    this.numInp=transform:Find("rightRoot/Buy/body/numInput"):GetComponent("InputField")
    this.numSlider=transform:Find("rightRoot/Buy/body/numSlider"):GetComponent("Slider")
    this.maxInp=transform:Find("rightRoot/Buy/body/maxInput"):GetComponent("InputField")
    this.maxSlider=transform:Find("rightRoot/Buy/body/maxSlider"):GetComponent("Slider")
end
--数据初始化
function AdvertisementPosPanel.InitDate(AdvertisementPosData)
    this.materialData = AdvertisementPosData;
end

--numSlider