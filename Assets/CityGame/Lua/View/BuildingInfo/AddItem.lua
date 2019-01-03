---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/27/027 10:44
---


require('Framework/UI/UIPage')
local class = require 'Framework/class'

AddItem = class('AddItem')

---初始化方法   数据（读配置表）
function AddItem:initialize(prefabData,prefab,inluabehaviour, mgr, id)
    self.prefab = prefab;
    self.prefabData = prefabData;
    self._luabehaviour = inluabehaviour
    self.manager = mgr
    self.id = id
    self.ItemList=mgr.addItemList

    self.addBtn=self.prefab.transform:Find("Image")--添加按钮
    self.parent=prefab.transform

    self.angleRoot=prefab.transform:Find("bg/angleRoot")
    self.titleText=prefab.transform:Find("bg/conText"):GetComponent("Text");
    self.numText=prefab.transform:Find("bg/numImage/Text"):GetComponent("Text");
    self.timeText=prefab.transform:Find("bg/timeImage/Text"):GetComponent("Text");

    self._luabehaviour:AddClick(self.addBtn.gameObject, self.OnClick_Add, self);

end
---添加
function AddItem:OnClick_Add(go)
    -- go.manager.transform=go.parent
    if   go.manager.current then
        go.manager.current.angleRoot.localScale=Vector3.zero
    end
    go.angleRoot.localScale=Vector3.one
    go.manager.current=go
end

function AddItem:updateTime()
    if self.remainTime then
         self.remainTime=self.remainTime-1
        local remainTime= convertTimeForm(self.remainTime)
        self.timeText.text=remainTime.hour+24*remainTime.day.. ":"..remainTime.min..":"..remainTime.sec --"h"
    end
end
