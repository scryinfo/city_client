---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/10/25 17:41
---删除商品提示框
local transform;
local gameObject;

MessageTooltipPanel = {};
local this = MessageTooltipPanel;

function MessageTooltipPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function MessageTooltipPanel.InitPanel()
    this.madeBy = transform:Find("MessageTooltip/MadeByBG/MadeBy"):GetComponent("Text");--商品来自于
    this.playerName = transform:Find("MessageTooltip/PlayerNameBG/PlayerName"):GetComponent("Text");--玩家名字
    this.okBtn = transform:Find("MessageTooltip/OKButton").gameObject;
    this.xBtn = transform:Find("MessageTooltip/XButton").gameObject;
end
