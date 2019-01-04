---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/21 14:54
---服务器列表
local class = require 'Framework/class'
require('Framework/UI/UIPage')
ServerItem = class('ServerItem')

--初始化方法   数据（读配置表）
function ServerItem:initialize(inluabehaviour, prefab, mgr, goodsDataInfo ,id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.manager = mgr
    self.id = id

    self.serverBtn = self.prefab.transform.gameObject;
    self.bg = self.prefab.transform:Find("bg").gameObject;
    self.tag = self.prefab.transform:Find("tag").gameObject;
    self.serverName = self.prefab.transform:Find("ServerName").gameObject:GetComponent("Text");

    self.bg:SetActive(false);
    self.tag:SetActive(false);
    self.serverName.text = goodsDataInfo.name
    self._luabehaviour:AddClick(self.serverBtn, self.OnServerBtn, self);

end

function ServerItem:OnServerBtn(go)
    Event.Brocast("c_OnServer",go)
end