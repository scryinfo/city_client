---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/17 16:35
---

OfflineNotificationCtrl = class("OfflineNotificationCtrl", UIPanel)
UIPanel:ResgisterOpen(OfflineNotificationCtrl)

function OfflineNotificationCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.None)
end

function OfflineNotificationCtrl:bundleName()
    return "Assets/CityGame/Resources/View/OfflineNotificationPanel.prefab"
end

function OfflineNotificationCtrl:OnCreate(go)
    UIPanel.OnCreate(self, go)
end

function OfflineNotificationCtrl:Awake()
    local luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")

    luaBehaviour:AddClick(OfflineNotificationPanel.sureBtn, self.OnBack, self)
    luaBehaviour:AddClick(OfflineNotificationPanel.buildingReturnBtn, self.OnBuildingReturn, self)
    luaBehaviour:AddClick(OfflineNotificationPanel.luckyReturnBtn, self.OnLuckyReturn, self)

    self.offlineNotificationSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.offlineNotificationSource.mProvideData = OfflineNotificationCtrl.static.offlineNotificationData
    self.offlineNotificationSource.mClearData = OfflineNotificationCtrl.static.offlineNotificationClearData
end

function OfflineNotificationCtrl:Active()
    UIPanel.Active(self)
end

function OfflineNotificationCtrl:Refresh()
    -- Display interface node-
    self:_setDetailsTitleBgAndText(false, true ,false, false, true, false, false)

    -- Display Data-
    self.homePageItems = {}

    -- Total revenue--
    self.totalBuildingIncome = 0
    for k, v in pairs(self.m_data) do
        if k ~= "forecast" and v.totalIncome ~= 0 then  -- Exclude non-profit building categories
            self.totalBuildingIncome = self.totalBuildingIncome + v.totalIncome
            local go = ct.InstantiatePrefab(OfflineNotificationPanel.offlineNotificationHomepageItem)
            local rect = go.transform:GetComponent("RectTransform")
            go.transform:SetParent(OfflineNotificationPanel.allListScroll)
            rect.transform.localScale = Vector3.one
            rect.transform.localPosition = Vector3.zero
            go:SetActive(true)

            local offlineNotificationHomepageItem = OfflineNotificationHomepageItem:new(go, v, self)
            table.insert(self.homePageItems, offlineNotificationHomepageItem)
        end
    end
    if self.m_data.forecast then  -- 把航班预测的数据放在最下面
        self.totalBuildingIncome = self.totalBuildingIncome + self.m_data.forecast.totalIncome
        local go = ct.InstantiatePrefab(OfflineNotificationPanel.offlineNotificationHomepageItem)
        local rect = go.transform:GetComponent("RectTransform")
        go.transform:SetParent(OfflineNotificationPanel.allListScroll)
        rect.transform.localScale = Vector3.one
        rect.transform.localPosition = Vector3.zero
        go:SetActive(true)

        local offlineNotificationHomepageItem = OfflineNotificationHomepageItem:new(go, self.m_data.forecast, self)
        table.insert(self.homePageItems, offlineNotificationHomepageItem)
    end
    OfflineNotificationPanel.incomeText.text = GetClientPriceString(self.totalBuildingIncome)
end

function OfflineNotificationCtrl:Hide()
    if self.homePageItems then
        self.homePageItems = nil
    end
    UIPanel.Hide(self)
end

---------------------------------------------------Button click event---------------------------------------------------------------------
function OfflineNotificationCtrl:OnBack()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end

function OfflineNotificationCtrl:OnBuildingReturn(go)
    go:_setDetailsTitleBgAndText(false, true, false, false, true, false, false)
    OfflineNotificationPanel.incomeText.text = GetClientPriceString(go.totalBuildingIncome)
end

function OfflineNotificationCtrl:OnLuckyReturn(go)
    go:_setDetailsTitleBgAndText(false, true, false, false, true, false, false)
    OfflineNotificationPanel.incomeText.text = GetClientPriceString(go.totalBuildingIncome)
end
-----------------------------------------------------Sliding multiplexing-----------------------------------------------------------------------
OfflineNotificationCtrl.static.offlineNotificationData = function(transform, idx)
    idx = idx + 1
    if OfflineNotificationCtrl.detailsScrollIndex == 1 then
        OfflineNotificationBuildingpageItem:new(transform, OfflineNotificationCtrl.detailsData[idx])
    elseif OfflineNotificationCtrl.detailsScrollIndex == 2 then
        OfflineNotificationLuckypageItem:new(transform, OfflineNotificationCtrl.detailsData[idx])
    end
end

OfflineNotificationCtrl.static.offlineNotificationClearData = function(transform)

end

function OfflineNotificationCtrl:ShowItems(detailsScrollIndex, data)
    OfflineNotificationCtrl.detailsScrollIndex = detailsScrollIndex
    local detailsPrefabList = {}
    if detailsScrollIndex == 1 then
        OfflineNotificationPanel.incomeText.text = GetClientPriceString(data.totalIncome)
        OfflineNotificationCtrl.detailsData = data.unLineIncome
        for i = 1, #OfflineNotificationCtrl.detailsData do
            table.insert(detailsPrefabList, "View/Items/OfflineNotificationItems/OfflineNotificationBuildingpageItem")
        end
        self:_setDetailsTitleBgAndText(true, true ,false, false, false, true, true)
        OfflineNotificationPanel.detailsScroll:ActiveDiffItemLoop(self.offlineNotificationSource, detailsPrefabList)
    elseif detailsScrollIndex == 2 then
        OfflineNotificationPanel.luckyText.text = data.totalIncome
        OfflineNotificationCtrl.detailsData = data.flightIncome
        for i = 1, #OfflineNotificationCtrl.detailsData do
            table.insert(detailsPrefabList, "View/Items/OfflineNotificationItems/OfflineNotificationLuckypageItem")
        end
        self:_setDetailsTitleBgAndText(false, false ,true, true, false, true, true)
        OfflineNotificationPanel.detailsScroll:ActiveDiffItemLoop(self.offlineNotificationSource, detailsPrefabList)
    end
end

-----------------------------------------------------Interface display-----------------------------------------------------------------------
function OfflineNotificationCtrl:_setDetailsTitleBgAndText(isShow1, isShow2, isShow3, isShow4, isShow5, isShow6, isShow7)
    OfflineNotificationPanel.buildingInfoTitleBg.localScale = isShow1 and Vector3.one or Vector3.zero
    OfflineNotificationPanel.incomeTitleTextTF.localScale = isShow2 and Vector3.one or Vector3.zero
    OfflineNotificationPanel.luckyValueTitleBg.localScale = isShow3 and Vector3.one or Vector3.zero
    OfflineNotificationPanel.luckyTitleTextTF.localScale = isShow4 and Vector3.one or Vector3.zero
    OfflineNotificationPanel.allListTransform.localScale = isShow5 and Vector3.one or Vector3.zero
    OfflineNotificationPanel.detailsTransform.localScale = isShow6 and Vector3.one or Vector3.zero
    OfflineNotificationPanel.scrollBg.localScale = isShow7 and Vector3.one or Vector3.zero

    if isShow5 then
        OfflineNotificationPanel.incomeTitleText.text = "Gross income:"
    else
        OfflineNotificationPanel.incomeTitleText.text = "Income:"
    end
end