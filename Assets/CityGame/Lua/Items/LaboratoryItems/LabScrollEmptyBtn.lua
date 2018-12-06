---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/19 10:24
---
LabScrollEmptyBtn = class('LabScrollEmptyBtn')

function LabScrollEmptyBtn:initialize(viewRect, func)
    self.viewRect = viewRect

    self.labAddBtn = viewRect:GetComponent("Button")
    self.labAddBtn.onClick:RemoveAllListeners()
    self.labAddBtn.onClick:AddListener(function ()
        func()
    end)
end