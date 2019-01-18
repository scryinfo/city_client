---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/16 15:48
---
LabScientificLineCtrl = class('LabScientificLineCtrl',UIPage)
UIPage:ResgisterOpen(LabScientificLineCtrl)

LabScientificLineCtrl.static.EmptyBtnPath = "View/Items/LaboratoryItems/EmptyBtn"  --按钮的预制
LabScientificLineCtrl.static.LabResearchItemPath = "View/Items/LaboratoryItems/LabResearchItem"  --研究
LabScientificLineCtrl.static.LabInventionItemPath = "View/Items/LaboratoryItems/LabInventionItem"  --发明
LabScientificLineCtrl.static.LabRemainStaffColor = "#4a7ff6"  --员工颜色

function LabScientificLineCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function LabScientificLineCtrl:bundleName()
    return "Assets/CityGame/Resources/View/LabScientificLinePanel.prefab"
end

function LabScientificLineCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function LabScientificLineCtrl:Awake(go)
    self.gameObject = go
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(LabScientificLinePanel.backBtn.gameObject, function()
        UIPage.ClosePage()
    end)
    self.luaBehaviour:AddClick(LabScientificLinePanel.researchBtn.gameObject, function()
        self:_researchLineOpen()
    end)
    self.luaBehaviour:AddClick(LabScientificLinePanel.inventionBtn.gameObject, function()
        self:_inventionLineOpen()
    end)

    Event.AddListener("c_OpenChangeStaffTip", self._openTip, self)  --打开更改员工悬框

    --滑动复用部分
    self.researchSource = UnityEngine.UI.LoopScrollDataSource.New()  --研究
    self.researchSource.mProvideData = LabScientificLineCtrl.static.researchProvideData
    self.researchSource.mClearData = LabScientificLineCtrl.static.researchClearData
    self.inventionSource = UnityEngine.UI.LoopScrollDataSource.New()  --发明
    self.inventionSource.mProvideData = LabScientificLineCtrl.static.inventionProvideData
    self.inventionSource.mClearData = LabScientificLineCtrl.static.inventionClearData
end

function LabScientificLineCtrl:Refresh()
    self:_initPanelData()
end

function LabScientificLineCtrl:Hide()
    self.gameObject:SetActive(false)
    self.isActived = false
end

function LabScientificLineCtrl:_initPanelData()
    LabScientificLineCtrl.static.researchItems = {}
    LabScientificLineCtrl.static.inventionItems = {}
    if self.m_data then
        self.buildingId = self.m_data.insId
        LabScientificLineCtrl.static.buildingId = self.buildingId
    end
    LabScientificLinePanel.changeStaffCountBtn.transform.localScale = Vector3.zero

    DataManager.DetailModelRpc(self.buildingId, 'm_GetScientificData', function (researchLines, inventionLines, maxWorkerNum, remainWorker, type)
        self.remainWorker = remainWorker
        self.maxWorkerNum = maxWorkerNum
        self.researchDatas = researchLines
        self.inventionDatas = inventionLines
        LabScientificLinePanel.staffCountText.text = string.format("<color=%s>%d</color>/%d", LabScientificLineCtrl.static.LabRemainStaffColor, remainWorker, maxWorkerNum)
        if type == nil then
            type = LabScientificLineCtrl.static.type or 0
        end
        if type == 0 then
            self:_researchLineOpen()
        else
            self:_inventionLineOpen()
        end
    end)
end
---按钮切页
function LabScientificLineCtrl:_researchLineOpen()
    LabScientificLinePanel._researchToggleState(true)
    LabScientificLinePanel._inventionToggleState(false)
    LabScientificLineCtrl.static.type = 0

    self:onReceiveLabResearchData(self.researchDatas)
end
function LabScientificLineCtrl:_inventionLineOpen()
    LabScientificLinePanel._researchToggleState(false)
    LabScientificLinePanel._inventionToggleState(true)
    LabScientificLineCtrl.static.type = 1

    self:onReceiveLabInventionData(self.inventionDatas)
end
--更新界面员工数
function LabScientificLineCtrl:_updateWorker(remainWorker, maxWorkerNum)
    LabScientificLinePanel.staffCountText.text = string.format("<color=%s>%d</color>/%d", LabScientificLineCtrl.static.LabRemainStaffColor, remainWorker, maxWorkerNum)
end

---滑动复用
--研究
LabScientificLineCtrl.static.researchProvideData = function(transform, idx)
    if idx == 0 then
        LabScientificLineCtrl.researchEmptyBtn = LabScrollEmptyBtn:new(transform, function ()
            --ct.OpenCtrl("LabResearchCtrl", {buildingId = LabScientificLineCtrl.static.buildingId, itemId = 2201003})
            ct.OpenCtrl("AddLineChooseItemCtrl", {type = 0})
        end)
        return
    end
    idx = idx + 1
    local item = LabResearchLineItem:new(LabScientificLineCtrl.researchInfoData[idx], transform)
    LabScientificLineCtrl.static.researchItems[idx] = item
end
LabScientificLineCtrl.static.researchClearData = function(transform)
end
--发明
LabScientificLineCtrl.static.inventionProvideData = function(transform, idx)
    if idx == 0 then
        LabScientificLineCtrl.inventionEmptyBtn = LabScrollEmptyBtn:new(transform, function ()
            --ct.OpenCtrl("LabInventionCtrl", {buildingId = LabScientificLineCtrl.static.buildingId, itemId = 2151003})
            ct.OpenCtrl("AddLineChooseItemCtrl", {type = 1})
        end)
        return
    end
    idx = idx + 1
    local item = LabInventionLineItem:new(LabScientificLineCtrl.inventionInfoData[idx], transform)
    LabScientificLineCtrl.static.inventionItems[idx] = item
end
LabScientificLineCtrl.static.inventionClearData = function(transform)
end
---刷新数据
--研究
function LabScientificLineCtrl:onReceiveLabResearchData(datas)
    self.researchDatas = datas
    local researchInfoData = ct.deepCopy(datas)
    local researchPrefabList = {}
    for i, item in pairs(researchInfoData) do
        researchPrefabList[i] = LabScientificLineCtrl.static.LabResearchItemPath
    end
    --预留第一个数据给按钮
    table.insert(researchInfoData, 1, {})
    table.insert(researchPrefabList, 1, LabScientificLineCtrl.static.EmptyBtnPath)

    LabScientificLineCtrl.researchInfoData = researchInfoData
    LabScientificLinePanel.researchScroll:ActiveDiffItemLoop(self.researchSource, researchPrefabList)

    --特殊情况处理，如果是临时线的话，则打开调整员工状态
    if #researchInfoData >= 2 and not researchInfoData[2].id then
        LabScientificLinePanel.inventTipItem:_hideSelf()
        DataManager.DetailModelRpc(LabScientificLineCtrl.static.buildingId, 'm_GetWorkerCount', function (remainWorker)
            LabScientificLinePanel.researchTipItem:newLineState(researchInfoData[2], remainWorker)
        end)
    else
        LabScientificLinePanel.inventTipItem:_hideSelf()
        LabScientificLinePanel.researchTipItem:_hideSelf()
    end
end
--发明
function LabScientificLineCtrl:onReceiveLabInventionData(datas)
    self.inventionDatas = datas
    local inventionInfoData = ct.deepCopy(datas)
    local inventionPrefabList = {}
    for i, item in pairs(inventionInfoData) do
        inventionPrefabList[i] = LabScientificLineCtrl.static.LabInventionItemPath
    end
    --预留第一个数据给按钮
    table.insert(inventionInfoData, 1, {})
    table.insert(inventionPrefabList, 1, LabScientificLineCtrl.static.EmptyBtnPath)

    LabScientificLineCtrl.inventionInfoData = inventionInfoData
    LabScientificLinePanel.inventionScroll:ActiveDiffItemLoop(self.inventionSource, inventionPrefabList)

    --特殊情况处理，如果是临时线的话，则打开调整员工状态
    if #inventionInfoData >= 2 and not inventionInfoData[2].id then
        LabScientificLinePanel.researchTipItem:_hideSelf()
        DataManager.DetailModelRpc(LabScientificLineCtrl.static.buildingId, 'm_GetWorkerCount', function (remainWorker)
            LabScientificLinePanel.inventTipItem:newLineState(inventionInfoData[2], remainWorker)
        end)
    else
        LabScientificLinePanel.inventTipItem:_hideSelf()
        LabScientificLinePanel.researchTipItem:_hideSelf()
    end
end

---提示框部分
--打开弹框
function LabScientificLineCtrl:_openTip(lineData, itemRect)
    if lineData.type == 0 then
        LabScientificLinePanel.inventTipItem:_hideSelf()
        DataManager.DetailModelRpc(LabScientificLineCtrl.static.buildingId, 'm_GetWorkerCount', function (remainWorker)
            LabScientificLinePanel.researchTipItem:changeStaffCountState(lineData, remainWorker, itemRect)
        end)
    else
        LabScientificLinePanel.researchTipItem:_hideSelf()
        DataManager.DetailModelRpc(LabScientificLineCtrl.static.buildingId, 'm_GetWorkerCount', function (remainWorker)
            LabScientificLinePanel.inventTipItem:changeStaffCountState(lineData, remainWorker, itemRect)
        end)
    end
end