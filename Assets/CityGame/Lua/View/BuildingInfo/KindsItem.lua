KindsItem = class('KindsItem')
local ctrl = nil
---Initialization method data (read configuration table)
function KindsItem:initialize(prefab,luaBehaviour,data,ctr)
    self.prefab = prefab
    self.ima = prefab.transform:Find("Image"):GetComponent("Image")
    luaBehaviour:AddClick(prefab,self.c_OnClick_change,self)
    if ctrl == nil then
        ctrl = ctr
    end
    self:saveData(data)
end

function KindsItem:updateData(data)
    self:saveData(data)
end

function KindsItem:c_OnClick_change(ins)
    PlayMusEff(1002)
    ctrl:changAparance(ins.data,ins.data.id)
end

function KindsItem:saveData(data)
    self.ima.transform.localScale = Vector3.zero
    self.data = data
    local arr = split(data.path,",")
    self.id = data.id
    self.type = arr[2]
    if arr[1] ~= "" then
        LoadSprite(arr[1],self.ima)
    end
end

