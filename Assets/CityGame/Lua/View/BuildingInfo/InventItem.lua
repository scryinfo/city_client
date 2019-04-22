
InventItem = class('InventItem')


---初始化方法   数据（读配置表）
function InventItem:initialize(prefab,luaBehaviour,data,ctr)
    self.prefab=prefab
    --self.ima=prefab.transform:Find("Image"):GetComponent("Image");
    self.text=prefab.transform:Find("Text"):GetComponent("Text");

    luaBehaviour:AddClick(prefab,self.c_OnClick_addLine,self);
    self:Refresh(data)
    self.ctrl = ctr
end
---==========================================================================================点击函数=============================================================================
--添加发明
function InventItem:c_OnClick_addLine(ins)
        local data={ins = ins,func = function(Ins)
            local count = Ins.ctrl.count
            DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_ReqLabAddLine',tonumber(ins.type),count)
        end  }

        ct.OpenCtrl("InventPopCtrl",data)
end
---==========================================================================================业务逻辑=============================================================================

function InventItem:updateData(data)
    self.type=data.type
    self.name=data.name
    self.path=data.iconPath
end

function InventItem:updateUI(data)
    --LoadSprite()
    self.text.text=data.name
end

function InventItem:Refresh(data)
    self:updateData(data)
    self:updateUI(data)
end
