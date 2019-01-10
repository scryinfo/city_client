---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/1 11:07
---通讯录
local class = require 'Framework/class'
require('Framework/UI/UIPage')
AddressListItem = class('AddressListItem')

--初始化方法   数据（读配置表）
function AddressListItem:initialize(DataInfo,prefab,mgr)
    self.prefab = prefab;
    self.dataInfo = DataInfo;
    self.manager = mgr;
    self.id = DataInfo.id
    self.onClick = true  --第一次点击

    self.bg = self.prefab.transform:Find("bg").gameObject:GetComponent("Button");
    self.name = self.prefab.transform:Find("name").gameObject:GetComponent("Text");
    self.box = self.prefab.transform:Find("box").gameObject;

    self.name.text = DataInfo.name

    self.box:SetActive(false);
    self.bg.onClick:AddListener(function()
        self:OnAddressListBG(self);
    end)
end

function AddressListItem:OnAddressListBG(go)
    Event.Brocast("c_OnAddressListBG",go)
end