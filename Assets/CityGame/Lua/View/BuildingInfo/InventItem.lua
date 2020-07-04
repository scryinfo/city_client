
InventItem = class('InventItem')


---Initialization method data (read configuration table)
function InventItem:initialize(prefab,luaBehaviour,data,ctr)
    self.prefab = prefab
    local transform = prefab.transform
    self.icon = transform:Find("icon"):GetComponent("Image")
    self.goodName = transform:Find("icon/Text"):GetComponent("Text")
    self.bgIcon = transform:Find("bgIcon"):GetComponent("Image")

    self.ctrl = ctr
    luaBehaviour:AddClick(prefab,self.c_OnClick_addLine,self);
    self:Refresh(data)
end
---==========================================================================================Click function=============================================================================
--Add invention
function InventItem:c_OnClick_addLine(ins)
        ins.buildInfo = ins.ctrl.m_data.info
        local data={ins = ins,func = function(Ins)
            local count = Ins.ctrl.count
            if count == nil then
                return
            end
            if count <= 0 then
                return
            end
            DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_ReqLabAddLine',tonumber(ins.type),count)
        end  }

        ct.OpenCtrl("InventPopCtrl",data)
end
---==========================================================================================Business logic=============================================================================

function InventItem:updateData(data)
    self.type=data.type
    self.name=data.name
    self.path=data.iconPath

    self:updateUI(data)
end

function InventItem:updateUI(data)
    LoadSprite(data.iconPath, self.icon,true)
    LoadSprite(data.bgIconPath, self.bgIcon,true)
    self.goodName.text= GetLanguage(tonumber(data.name))
end

function InventItem:Refresh(data)
    self:updateData(data)
    self:updateUI(data)
end
