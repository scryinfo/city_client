---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/2/18/018 12:02
---


local transform;

AvtarPanel = {};
local this = AvtarPanel;

function AvtarPanel.Awake(obj)
    transform = obj.transform;
    this.InitPanel();
end

function AvtarPanel.InitPanel()
    this.backBtn = transform:Find("topRoot/backBtn")
    this.cofirmBtn = transform:Find("topRoot/confirmBtn")
    this.randomBtn = transform:Find("randomBtn")

    this.showContent=transform:Find("showContent/bg")
    this.fiveContent=transform:Find("fiveScroll/Viewport/Content")
    this.kindsContent=transform:Find("kindsScroll/Viewport/Content")
    this.maleBtn=transform:Find("kindsScroll/male")
    this.feMaleBtn=transform:Find("kindsScroll/faMale")

    this.maleSelect=transform:Find("kindsScroll/male/select")
    this.feMaleSelect=transform:Find("kindsScroll/faMale/select")

end
--数据初始化
function AvtarPanel.InitDate(MunicipalData)
    this.materialData = MunicipalData;
end