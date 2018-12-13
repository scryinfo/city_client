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
    return "LabScientificLinePanel"
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

    self:_addListener()

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

function LabScientificLineCtrl:_addListener()
    --Event.AddListener("c_OnReceiveLabLineAdd", self._onReceiveLabAddLine, self)
end
function LabScientificLineCtrl:_removeListener()
    --Event.RemoveListener("c_onExchangeSort", self._exchangeSortByValue, self)
end

function LabScientificLineCtrl:_initPanelData()
    LabScientificLineCtrl.researchItems = {}
    LabScientificLineCtrl.inventionItems = {}
    --有个问题，这个脚本并没有重写hide方法，为什么m_data会清空
    if self.m_data then
        self.buildingId = self.m_data.buildingId
        LabScientificLineCtrl.static.buildingId = self.buildingId
    end
    LabScientificLinePanel.changeStaffCountBtn.transform.localScale = Vector3.zero

    DataManager.DetailModelRpc(self.buildingId, 'm_GetScientificData', function (researchLines, inventionLines, maxWorkerNum, remainWorker)
        self.remainWorker = remainWorker
        self.maxWorkerNum = maxWorkerNum
        self.researchDatas = researchLines
        self.inventionDatas = inventionLines
        LabScientificLinePanel.staffCountText.text = string.format("<color=%s>%d</color>/%d", LabScientificLineCtrl.static.LabRemainStaffColor, remainWorker, maxWorkerNum)
        self:_researchLineOpen()
    end)
end
---按钮切页
function LabScientificLineCtrl:_researchLineOpen()
    LabScientificLinePanel._researchToggleState(true)
    LabScientificLinePanel._inventionToggleState(false)

    self:onReceiveLabResearchData(self.researchDatas)
end
function LabScientificLineCtrl:_inventionLineOpen()
    LabScientificLinePanel._researchToggleState(false)
    LabScientificLinePanel._inventionToggleState(true)

    self:onReceiveLabInventionData(self.inventionDatas)
end

---滑动复用
--研究
LabScientificLineCtrl.static.researchProvideData = function(transform, idx)
    if idx == 0 then
        LabScientificLineCtrl.researchEmptyBtn = LabScrollEmptyBtn:new(transform, function ()
            ct.OpenCtrl("LabResearchCtrl", {buildingId = LabScientificLineCtrl.static.buildingId, itemId = 2201003})
        end)
        return
    end

    idx = idx + 1
    if idx == 2 and (not LabScientificLineCtrl.researchInfoData[idx].lineId) then  --新增临时线
        DataManager.DetailModelRpc(LabScientificLineCtrl.static.buildingId, 'm_GetWorkerCount', function (remainWorker)
            LabScientificLinePanel.researchTipItem:newLineState(LabScientificLineCtrl.researchInfoData[idx], remainWorker, transform:GetComponent("RectTransform").anchoredPosition)
        end)
    end
    local item = LabResearchLineItem:new(LabScientificLineCtrl.researchInfoData[idx], transform)
    LabScientificLineCtrl.researchItems[idx] = item
end
--发明
LabScientificLineCtrl.static.inventionProvideData = function(transform, idx)
    if idx == 0 then
        LabScientificLineCtrl.inventionEmptyBtn = LabScrollEmptyBtn:new(transform, function ()
            ct.OpenCtrl("LabInventionCtrl", {buildingId = LabScientificLineCtrl.static.buildingId, itemId = 2201003})
        end)
        return
    end

    idx = idx + 1
    if idx == 2 and (not LabScientificLineCtrl.inventionInfoData[idx].lineId) then  --新增临时线
        DataManager.DetailModelRpc(LabScientificLineCtrl.static.buildingId, 'm_GetWorkerCount', function (remainWorker)
            LabScientificLinePanel.researchTipItem:newLineState(LabScientificLineCtrl.inventionInfoData[idx], remainWorker, transform:GetComponent("RectTransform").anchoredPosition)
        end)
    end
    local item = LabInventionLineItem:new(LabScientificLineCtrl.inventionInfoData[idx], transform)
    LabScientificLineCtrl.inventionItems[idx] = item
end
---刷新数据
--研究
function LabScientificLineCtrl:onReceiveLabResearchData(datas)
    local researchInfoData = BaseTools.TableCopy(datas)
    local researchPrefabList = {}
    for i, item in pairs(researchInfoData) do
        researchPrefabList[i] = LabScientificLineCtrl.static.LabResearchItemPath
    end
    --预留第一个数据给按钮
    table.insert(researchInfoData, 1, {})
    table.insert(researchPrefabList, 1, LabScientificLineCtrl.static.EmptyBtnPath)

    LabScientificLineCtrl.researchInfoData = researchInfoData
    LabScientificLinePanel.researchScroll:ActiveDiffItemLoop(self.researchSource, researchPrefabList)
end
--发明
function LabScientificLineCtrl:onReceiveLabInventionData(datas)
    local inventionInfoData = BaseTools.TableCopy(datas)
    local inventionPrefabList = {}
    for i, item in pairs(inventionInfoData) do
        inventionPrefabList[i] = LabScientificLineCtrl.static.LabInventionItemPath
    end
    --预留第一个数据给按钮
    table.insert(inventionInfoData, 1, {})
    table.insert(inventionPrefabList, 1, LabScientificLineCtrl.static.EmptyBtnPath)

    LabScientificLineCtrl.inventionInfoData = inventionInfoData
    LabScientificLinePanel.inventionScroll:ActiveDiffItemLoop(self.inventionSource, inventionPrefabList)
end

---提示框部分
--打开弹框
function LabScientificLineCtrl:_showSetStaffTip(lineItem)
    self.tempLine = lineItem

    LabScientificLinePanel.showNewLineStaffTip(lineItem.viewRect)
end
--点击弹窗以外的地方，关闭弹窗，不改变员工数量
function LabScientificLineCtrl:_cancelChangeStaffCount()
    LabScientificLinePanel.changeStaffCountBtn.transform.localScale = Vector3.zero
end
--点击确认按钮，向服务器发送消息
function LabScientificLineCtrl:_sureChangeStaffCount()
    local staffCount = tonumber(LabScientificLinePanel.staffText.text)
    if staffCount <= 0 then
        return
    end

    if self.isNewLine then
        Event.Brocast("m_ReqAddLine", self.buildingId, self.tempLine.itemId, self.tempLine.type, staffCount)  --如果是新添加的线，则发送addLine
    else
        Event.Brocast("m_ReqSetWorkerNum", self.buildingId, self.tempLine.lineId, staffCount)  --一般的改变员工，则需要发送setWorkerNum
    end

    LabScientificLinePanel.changeStaffCountBtn.transform.localScale = Vector3.zero
end