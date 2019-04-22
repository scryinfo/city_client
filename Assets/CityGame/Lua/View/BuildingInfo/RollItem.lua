
RollItem = class('RollItem')


---初始化方法   数据（读配置表）
function RollItem:initialize(prefab,luaBehaviour,data,ctrl)
    self.prefab=prefab

    --self.ima=prefab.transform:Find("Image"):GetComponent("Image");

    luaBehaviour:AddClick(prefab.gameObject,self.c_OnClick_roll,self);
    self:Refresh(data)

    end
    ---==========================================================================================点击函数=============================================================================
    --开箱
    function RollItem:c_OnClick_roll(ins)
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId,"m_ReqLabRoll",ins.data.lineId)
    end
    ---==========================================================================================业务逻辑=============================================================================

    function RollItem:updateData(data)
        self.data=data
    end

    function RollItem:updateUI(data)
        --LoadSprite()
    end

function RollItem:Refresh(data)
        self:updateData(data)
        self:updateUI(data)
end


