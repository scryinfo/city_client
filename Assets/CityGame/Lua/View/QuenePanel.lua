---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/12/25/025 17:48
---

local transform;

QuenePanel = {};
local this = QuenePanel;

function QuenePanel.Awake(obj)
    transform = obj.transform;
    this.InitPanel();
end

function QuenePanel.InitPanel()
    this.backBtn=transform:Find("topRoot/top/backBtn")
    this.name=transform:Find("topRoot/top/backBtn/Text"):GetComponent("Text");
    this.player=transform:Find("topRoot/top/title/player"):GetComponent("Text");
    this.goods=transform:Find("topRoot/top/title/goods"):GetComponent("Text");
    this.details=transform:Find("topRoot/top/title/details"):GetComponent("Text");
    this.startTime=transform:Find("topRoot/top/title/startTime"):GetComponent("Text");
    this.topicText=transform:Find("topRoot/top/backBtn/Text"):GetComponent("Text");
    this.player=transform:Find("topRoot/top/title/player"):GetComponent("Text");
    this.goods=transform:Find("topRoot/top/title/goods"):GetComponent("Text");
    this.details=transform:Find("topRoot/top/title/details"):GetComponent("Text");
    this.startTime=transform:Find("topRoot/top/title/startTime"):GetComponent("Text");

    this.loopScrol=transform:Find("joinInfoRoot/Scroll"):GetComponent("ActiveLoopScrollRect")

    this.loopScrols=transform:Find("joinInfoRoot/Scroll"):GetComponent("LoopVerticalScrollRect")

---********************************************************************LandInfo**************************************************************************

end

