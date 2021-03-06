---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ljw.
--- DateTime: 2019/5/23 15:53
---

Failitem = class('Failitem')


---Initialization method data (read configuration table)
function Failitem:initialize(prefab,luaBehaviour,data,ctrl)
    self.prefab=prefab
    local transform = prefab.transform
    self.closeBtn = prefab.transform:Find("closeBtn")
    self.failText = prefab.transform:Find("Image/Text")

    luaBehaviour:AddClick(self.closeBtn.gameObject,self._closeFunc,self)
    self:Refresh(data)
end
---========================================================================================Click function=============================================================================
function Failitem:_closeFunc(ins)
    destroy(ins.prefab.gameObject)
    RollPanel.resultRoot.localScale = Vector3.zero
end
---==========================================================================================Business logic=============================================================================

function Failitem:updateData(data)
    self.data=data
end

function Failitem:updateUI(data)
    --LoadSprite()
end

function Failitem:Refresh(data)
    self.failText = GetLanguage(28040023)
    self:updateData(data)
    self:updateUI(data)
end


