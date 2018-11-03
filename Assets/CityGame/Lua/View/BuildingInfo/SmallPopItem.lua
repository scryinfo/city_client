---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/11/1/001 17:52
---

-----------------------------------------------
require "Common/define"
local class = require 'Framework/class'


SmallPopItem = class('SmallPopItem')


SmallPopItem.endPOS=Vector2.New(0,-415)

SmallPopItem.POS=Vector2.New(0,-750)

local prefabTrans;


---初始化方法   数据（读配置表）
function SmallPopItem:initialize(string,prefab,mgr)

    prefabTrans=prefab.transform:GetComponent("RectTransform");
    self.tipText=prefab.transform:Find("textbg/tipText"):GetComponent("Text");

    self.textBgTrans=prefab.transform:Find("textbg"):GetComponent("RectTransform")
    prefabTrans.anchoredPosition=Vector2.New(0,-750)
    self.tipText.text=string
    self.tipTextTrans=prefab.transform:Find("textbg/tipText"):GetComponent("RectTransform")

    prefabTrans:DOAnchorPos(SmallPopItem.endPOS, 0.5);

    self.timenow=UnityEngine.Time.time+2

    UpdateBeat:Add(self._update, self);
end


function SmallPopItem:_update()

    self.textBgTrans.sizeDelta=Vector2.New(self.tipTextTrans.sizeDelta.x+57,75)

    if  UnityEngine.Time.time>self.timenow  then

        prefabTrans.anchoredPosition=Vector2.New(0,-750);

        UpdateBeat:Remove(self._update, self);
    end
end



