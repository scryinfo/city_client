require "Common/define"

local transform;

MaterialPanel = {};
local this = MaterialPanel;

function MaterialPanel.Awake(obj)
    transform = obj.transform;
    --this.InitPanel();
    this.rightRootTran = transform:Find("rightRoot");
    this.leftRootTran = transform:Find("leftRoot");
    this.topRootTran = transform:Find("topRoot");
    local inputf = transform:Find("topRoot/titleBg/nameInputField")
    if inputf then
        this.nameInputField = inputf.gameObject:GetComponent("InputField");
    end
end

function MaterialPanel.InitPanel()
--[[--MaterialPanel
    this.companyName = transform:Find("Factory_name/Company_name").gameObject;
    --DetailsPanel
    this.warehouseBtn = transform:Find("DetailsPanel/Warehouse_Btn").gameObject;
    this.productionBtn = transform:Find("DetailsPanel/Production_Btn").gameObject;
    this.shelfBtn = transform:Find("DetailsPanel/Shelf_Btn").gameObject;
    --StaffPanel
]]--[[    this.AjustBtn = transform:Find("StaffPanel/DetailsWage/AJUST_Btn").gameObject;
    this.PerStaff_text = transform:Find("StaffPanel/DetailsWage/PerStaff/PerStaff_text").gameObject;
    this.Daily_text = transform:Find("StaffPanel/DetailsWage/Daily/Daily_text").gameObject;
    this.Satisfaction_text = transform:Find("StaffPanel/Satisfaction/Satisfaction_text").gameObject;]]--[[
    --Slider
    this.warehouseValue = transform:Find("DetailsPanel/Warehouse_Line").gameObject;
    this.productionValue = transform:Find("DetailsPanel/Production_Line").gameObject;]]
end
--数据初始化
function MaterialPanel.InitDate(materialData)
    this.materialData = materialData;
end
