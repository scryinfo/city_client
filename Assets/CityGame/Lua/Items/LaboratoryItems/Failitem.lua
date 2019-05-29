---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ljw.
--- DateTime: 2019/5/23 15:53
---

Failitem = class('Failitem')


---初始化方法   数据（读配置表）
function Failitem:initialize(prefab,luaBehaviour,data,ctrl)
    self.prefab=prefab
    local transform = prefab.transform
    self.closeBtn = prefab.transform:Find("closeBtn")

    luaBehaviour:AddClick(self.closeBtn.gameObject,self._closeFunc,self)
    self:Refresh(data)
end
---========================================================================================点击函数=============================================================================
function Failitem:_closeFunc(ins)
    destroy(ins.prefab.gameObject)
    RollPanel.resultRoot.localScale = Vector3.zero
end
---==========================================================================================业务逻辑=============================================================================

function Failitem:updateData(data)
    self.data=data
end

function Failitem:updateUI(data)
    --LoadSprite()
end

function Failitem:Refresh(data)
    self:updateData(data)
    self:updateUI(data)
end


