
local transform;

RetailStoresPanel = {};
local this = RetailStoresPanel;

function RetailStoresPanel.Awake(obj)
    transform = obj.transform;
    --this.InitPanel();
    --this.rightRootTran = transform:Find("rightRoot");
    --this.leftRootTran = transform:Find("leftRoot");
    --this.topRootTran = transform:Find("topRoot");
    local inputf = transform:Find("topRoot/titleBg/nameInputField")
    if inputf then
        this.nameInputField = inputf.gameObject:GetComponent("InputField");
    end
    this.InitPanel();
end

function RetailStoresPanel.InitPanel()
    this.rightRootTran = transform:Find("rightRoot");
    this.leftRootTran = transform:Find("leftRoot");
    this.topRootTran = transform:Find("topRoot");
    this.buildingTypeNameText = transform:Find("topRoot/titleBg/buildingTypeNameText"):GetComponent("Text");
    this.nameText = transform:Find("topRoot/titleBg/nameText"):GetComponent("Text");
    this.changeNameBtn = transform:Find("topRoot/titleBg/changeNameBtn");
    this.backBtn = transform:Find("topRoot/backBtn");
    this.headImgBtn = transform:Find("topRoot/headBg/headImgBtn");
    this.buildInfo = transform:Find("buildInfo");
    this.stopIconROOT = transform:Find("stopIconROOT");
end
--数据初始化
function RetailStoresPanel.InitDate(materialData)
    this.materialData = materialData;
end