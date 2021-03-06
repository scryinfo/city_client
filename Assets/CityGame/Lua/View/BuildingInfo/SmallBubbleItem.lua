---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/3/6/006 10:55
---

SmallBubbleItem = class('SmallBubbleItem')

local ctrl
---初始化方法   数据（读配置表）
function SmallBubbleItem:initialize(prefab,luaBehaviour,data,ctr)
    ctrl=ctr
    self.prefab=prefab
    self.ima = prefab.transform:Find("icon"):GetComponent("Image")
    self.frame = prefab.transform:Find("frame")
    self.text = prefab.transform:Find("Text"):GetComponent("Text")
    luaBehaviour:AddClick(prefab,self.c_OnClick_choose,self)
    self:saveData(data)
    self.text.text = GetLanguage(data.nameID)
end

function SmallBubbleItem:updateData(data)
    self:saveData(data)
end

function SmallBubbleItem:c_OnClick_choose(ins)
    if ctrl.select then
        ctrl.select.localScale=Vector3.zero
    end
    ctrl.select=ins.frame
    ctrl.bubbleId=ins.id
    ins.frame.localScale=Vector3.one
end

function SmallBubbleItem:saveData(data)
    self.path=data.path
    self.id=data.id

    if self.id==1 then
        self.frame.localScale=Vector3.one
        ctrl.select=self.frame
        ctrl.bubbleId=1

    else
        self.frame.localScale=Vector3.zero
    end

    LoadSprite(data.path,self.ima)
end