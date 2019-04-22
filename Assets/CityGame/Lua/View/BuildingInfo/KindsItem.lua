
KindsItem = class('KindsItem')

local ctrl
---初始化方法   数据（读配置表）
function KindsItem:initialize(prefab,luaBehaviour,data,ctr)
    self.prefab=prefab
    self.ima=prefab.transform:Find("Image"):GetComponent("Image");

    luaBehaviour:AddClick(prefab,self.c_OnClick_change,self);
    self:saveData(data)
    ctrl=ctr

end


function KindsItem:updateData(data)
    self:saveData(data)
end

function KindsItem:c_OnClick_change(ins)
    ctrl:changAparance(ins.data)
end


function KindsItem:saveData(data)
    self.data=data
    local arr=split(data.path,",")
    self.id=data.id
    self.type=arr[2]
    if arr[1]=="" then
        self.ima.transform.localScale=Vector3.zero
    else
        self.ima.transform.localScale=Vector3.one
        LoadSprite(arr[1],self.ima)
    end
end

