require "Common/define"

local transform;

MaterialPanel = {};
local this = MaterialPanel;

function MaterialPanel.Awake(obj)
    transform = obj.transform;
    this.InitPanel();
end

function MaterialPanel.InitPanel()
    this.rightRootTran = transform:Find("rightRoot");
    this.leftRootTran = transform:Find("leftRoot");
    this.topRootTran = transform:Find("topRoot");
    this.buildingTypeNameText = transform:Find("topRoot/titleBg/buildingTypeNameText"):GetComponent("Text");
    this.nameText = transform:Find("topRoot/titleBg/nameText"):GetComponent("Text");
    this.changeNameBtn = transform:Find("topRoot/titleBg/changeNameBtn");
    this.backBtn = transform:Find("topRoot/backBtn");
    this.infoBtn = transform:Find("topRoot/infoBtn");
end
--数据初始化
function MaterialPanel.InitDate(materialData)
    this.materialData = materialData;
end
