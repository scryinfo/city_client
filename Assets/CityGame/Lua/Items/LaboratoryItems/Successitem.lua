--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ljw.
--- DateTime: 2019/5/23 15:53
---

Successitem = class('Successitem')

---初始化方法   数据（读配置表）
function Successitem:initialize(prefab,luaBehaviour,data,ctrl)
    self.prefab=prefab
    local transform = prefab.transform

    self:Refresh(data)
end
---==========================================================================================点击函数=============================================================================

---==========================================================================================业务逻辑=============================================================================

function Successitem:updateData(data)
    self.data=data
end

function Successitem:updateUI(data)
    --LoadSprite()
end

function Successitem:Refresh(data)
    self:updateData(data)
    self:updateUI(data)
end