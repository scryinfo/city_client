---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/6/20 17:27
---

NoviceTutorialCtrl = class("NoviceTutorialCtrl", UIPanel)

UIPanel:ResgisterOpen(NoviceTutorialCtrl)

function NoviceTutorialCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function NoviceTutorialCtrl:bundleName()
    return "Assets/CityGame/Resources/View/NoviceTutorialPanel.prefab"
end

function NoviceTutorialCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function NoviceTutorialCtrl:Awake()
    local luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")

    luaBehaviour:AddClick(NoviceTutorialPanel.backBtn, self.OnBack, self)

    --
    self.tutorialVideoSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.tutorialVideoSource.mProvideData = NoviceTutorialCtrl.static.tutorialVideoData
    self.tutorialVideoSource.mClearData = NoviceTutorialCtrl.static.tutorialVideoClearData

    self.tutorialChoiceItems = {}
    for i = 1, #NoviceTutorialConfig do
        local function callback(obj)
            self.tutorialChoiceItems[i] = TutorialChoiceItem:new(obj, i, self)
            if i == 1 then
                self.tutorialChoiceItems[1]:_onClickBtn()
            end
        end
        DynamicLoadPrefab("Assets/CityGame/Resources/View/NoviceTutorial/TutorialChoiceItem.prefab", NoviceTutorialPanel.choiceScroll, nil, callback)
    end
end

function NoviceTutorialCtrl:Active()
    UIPanel.Active(self)

    -- 多语言适配
    NoviceTutorialPanel.titleText.text = "ROOKIE TUTORIAL" --GetLanguage(31010001)
end

function NoviceTutorialCtrl:Refresh()
    if self.tutorialChoiceItems[1] then
        self.tutorialChoiceItems[1]:_onClickBtn()
    end
end

function NoviceTutorialCtrl:Hide()
    UIPanel.Hide(self)
end

---------------------------------------------------------------按钮点击事件---------------------------------------------------------
function NoviceTutorialCtrl:OnBack(go)
    PlayMusEff(1002)
    UIPanel.ClosePage()
end

function NoviceTutorialCtrl:_setBtnState(choiceBtn)
    if self.selectBtn then
        self.selectBtn:SetSelect(true)
    end
    choiceBtn:SetSelect(false)
    self.selectBtn = choiceBtn
end

-------------------------------------------------------------- 滑动复用相关 --------------------------------------------------------
-- Eva选项2信息显示
NoviceTutorialCtrl.static.tutorialVideoData = function(transform, idx)
    idx = idx + 1
    TutorialVideoItem:new(transform, NoviceTutorialCtrl.data[idx])
end

NoviceTutorialCtrl.static.tutorialVideoClearData = function(transform)
end

-- 刷新Eva滑动选项2的信息
function NoviceTutorialCtrl:ShowVideo(itemNumber)
    NoviceTutorialCtrl.data = NoviceTutorialConfig[itemNumber].videos
    NoviceTutorialPanel.urlScroll:ActiveLoopScroll(self.tutorialVideoSource, #NoviceTutorialCtrl.data, "View/NoviceTutorial/TutorialVideoItem")
end