---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/2/19/019 9:54
---

FiveFaceItem = class('FiveFaceItem')

local ctrl = nil
local path="Assets/CityGame/Resources/Atlas/Avtar/panelSource/icon-"
---Initialization method data (read configuration table)
function FiveFaceItem:initialize(prefab,luaBehaviour,data,ctr)
    self.prefab = prefab
    self.text = prefab.transform:Find("name"):GetComponent("Text")
    self.ima = prefab.transform:Find("icon"):GetComponent("Image")
    self.select = prefab.transform:Find("select")
    self.select.localScale = Vector3.zero
    if data.id == 1 then
        ctr.select = self.select
        ctr.select.localScale = Vector3.one
    end
    if ctrl == nil then
        ctrl = ctr
    end
    luaBehaviour:AddClick(prefab,self.c_OnClick_switchKind,self)
    self:saveData(data)
end
---Add to
function FiveFaceItem:updateData(data)
    self:saveData(data)
end

--Select the left effect [without modification]
function FiveFaceItem:c_OnClick_switchKind(ins)
    PlayMusEff(1002)
    if ctrl ~= nil then
        ctrl:switchKinds(ins.kinds)
        ctrl.select.localScale = Vector3.zero
        ctrl.select = ins.select
        ctrl.select.localScale = Vector3.one
    end
end

--Refresh the data [without modification]
function FiveFaceItem:saveData(data)
    self.id = data.id
    self.text.text = GetLanguage(data.name)
    self.kinds = data.kinds
    local pat = split(data.kinds[1].path,",")
    LoadSprite(path..pat[2]..".png",self.ima,true)
end