require "Common/define"

ChooseWarehouseCtrl = {};
local this = ChooseWarehouseCtrl;

local ChooseWarehouse;
local gameObject;

function ChooseWarehouseCtrl.New()
    return this;
end
function ChooseWarehouseCtrl.Awake()
    panelMgr:CreatePanel('ChooseWarehouse',this.OnCreate);
end
function ChooseWarehouseCtrl.OnCreate(obj)
    gameObject = obj;

    ChooseWarehouse = gameObject:GetComponent('LuaBehaviour');
    ChooseWarehouse:AddClick(ChooseWarehousePanel.returnBtn,this.OnReturnBtn);
    ChooseWarehouse:AddClick(ChooseWarehousePanel.searchBtn,this.OnSearchBtn);
end
function ChooseWarehouseCtrl.OnReturnBtn(go)

end
function ChooseWarehouseCtrl.OnSearchBtn(go)

end