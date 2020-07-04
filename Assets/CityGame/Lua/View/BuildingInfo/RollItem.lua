
RollItem = class('RollItem')


---Initialization method data (read configuration table)
function RollItem:initialize(prefab,luaBehaviour,data,ctrl)
    self.prefab=prefab
    local transform = prefab.transform
    self.data = data
    self.oddsText=findByName(transform,"Text"):GetComponent("Text")

    luaBehaviour:AddClick(prefab.gameObject,self.c_OnClick_roll,self);
    self:Refresh(data)
end
---==========================================================================================Click function=============================================================================
--Business logic...
function RollItem:c_OnClick_roll(ins)
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId,"m_ReqLabRoll",ins.data.lineId)
end
---==========================================================================================Business logic=============================================================================

function RollItem:updateData(data)
    self.data=data
    self:updateUI(data)
end

function RollItem:updateUI(data)
    --LoadSprite()
    self.oddsText.text = tostring(data.odds) .. "%"
end

function RollItem:Refresh(data)
    self:updateData(data)

end


