---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/11/20/020 10:03
---
require "Common/define"

local transform;

ScienceTradePanel = {};
local this = ScienceTradePanel;

function ScienceTradePanel.Awake(obj)
    transform = obj.transform;

    this.InitPanel();
end

function ScienceTradePanel.InitPanel()

    this.backBtn=transform:Find("topRoot/backBtn")
    this.plusBtn=transform:Find("topRoot/plusBtn")

    this.iconImage=transform:Find("leftroot/bg/whitepanel/iconbg/icon"):GetComponent("Image");
    this.nameText=transform:Find("leftroot/bg/whitepanel/iconbg/nameText"):GetComponent("Text");

    this.scoreText=transform:Find("leftroot/bg/whitepanel/botton/hightToot (1)/icon/Text"):GetComponent("Text");
    this.mylevelText=transform:Find("leftroot/bg/whitepanel/botton/hightToot (1)/icon1/Text"):GetComponent("Text");
    this.owenrText=transform:Find("leftroot/bg/whitepanel/botton/hightToot/icon/Text"):GetComponent("Text");
    this.highlevelTetx=transform:Find("leftroot/bg/whitepanel/botton/hightToot/icon1/Text"):GetComponent("Text");

    this.scrollContent=transform:Find("rightRoot/Scroll View/Viewport/Content")
end
--数据初始化
function ScienceTradePanel.InitDate(AdvertisementPosData)
    this.materialData = AdvertisementPosData;
end