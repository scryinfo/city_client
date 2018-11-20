---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/11/20/020 10:03
---
require "Common/define"

local transform;

ScienceSellPopPanel = {};
local this = ScienceSellPopPanel;

function ScienceSellPopPanel.Awake(obj)
    transform = obj.transform;

    this.InitPanel();
end

function ScienceSellPopPanel.InitPanel()
    this.iconImage = transform:Find("bg/iconImage"):GetComponent("Image");
    this.levleInp=transform:Find("bg/body/InputField"):GetComponent("InputField")
    this.cutBtn=this.transform:Find("bg/body/InputField/cut")
    this.plusBtn=this.transform:Find("bg/body/InputField/plus")
    this.priceInp=transform:Find("bg/body/PriceInpu"):GetComponent("InputField")

    this.okBtn=this.transform:Find("bg/body/okBtn")
    this.backBtn=this.transform:Find("bg/backBtn")
end
--数据初始化
function ScienceSellPopPanel.InitDate(AdvertisementPosData)
    this.materialData = AdvertisementPosData;
end