---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/31/031 16:23
---

local transform;
--local gameObject;

ConfirmPopPanel = {};
local this = ConfirmPopPanel;

--Start event
function ConfirmPopPanel.Awake(obj)
  --  gameObject = obj;
    transform = obj.transform;

    this.InitPanle();
end
--Initialize the interface
function ConfirmPopPanel.InitPanle()
    this.confirmBtn = transform:Find("root/confimBtn")
    this.closeBtn = transform:Find("root/closeBtn")

    this.titleText = transform:Find("root/titleText"):GetComponent("Text");
    this.mainText=transform:Find("root/mainContentText"):GetComponent("Text");
    this.tipText=transform:Find("root/tipContentText"):GetComponent("Text");

end
function ConfirmPopPanel.OnDestroy()

end
