
InventGoodItem = class('InventGoodItem')


---初始化方法   数据（读配置表）
function InventGoodItem:initialize(data,prefab,luaBehaviour)
    self.prefab=prefab

    --self.ima=prefab.transform:Find("Image"):GetComponent("Image");
    self.deleteBtn=prefab.transform:Find("Button")

    luaBehaviour:AddClick(self.deleteBtn.gameObject,self.c_OnClick_Delete,self);
    self:Refresh(data)
end
---==========================================================================================点击函数=============================================================================
--删除
function InventGoodItem:c_OnClick_Delete(ins)
  --  DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_ReqLabDeleteLine',ins.data.id)
    ct.OpenCtrl("RollCtrl" , ins.data)
end
---==========================================================================================业务逻辑=============================================================================

function InventGoodItem:updateData(data)
    self.data=data
end

function InventGoodItem:updateUI(data)
    --LoadSprite()
end

function InventGoodItem:Refresh(data)
    self:updateData(data)
    self:updateUI(data)
end
