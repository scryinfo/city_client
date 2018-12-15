---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/3 10:14
---
LabInventionCtrl = class('LabInventionCtrl',UIPage)
UIPage:ResgisterOpen(LabInventionCtrl)
LabInventionCtrl.static.InventionBulbItemPath = "View/Items/LaboratoryItems/LabInventionBulbItem"  --灯泡的预制

function LabInventionCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end
function LabInventionCtrl:bundleName()
    return "LabInventionPanel"
end
function LabInventionCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end
function LabInventionCtrl:Awake(go)
    self.gameObject = go
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(LabInventionPanel.backBtn.gameObject, function()
        UIPage.ClosePage()
    end)
    self.luaBehaviour:AddClick(LabInventionPanel.inventionBtn.gameObject, function()
        self:_inventeBtnClick()
    end)
    self.luaBehaviour:AddClick(LabInventionPanel.progressSuccessBtn.gameObject, function()
        if LabScientificLineCtrl.static.buildingId and self.m_data.lineId then
            DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_ReqLabRoll', self.m_data.lineId)
        end
    end)
    UpdateBeat:Add(self._update, self)
end
function LabInventionCtrl:Refresh()
    self:_initPanelData()
end
function LabInventionCtrl:Hide()
    UIPage.Hide(self)
end
function LabInventionCtrl:_update()
    if not self.m_data then
        return
    end
    if self.m_data.bulbState and self.m_data.bulbState == LabInventionBulbItemState.Working and self.m_data.leftSec > 0 then
        self.remainTime = self.remainTime - UnityEngine.Time.unscaledDeltaTime
        LabInventionPanel.progressWorkingImg.fillAmount = self.remainTime / self.m_data.phaseSec  --设置图片进度

        if self.remainTime <= 0 then
            self.m_data.bulbState = LabInventionBulbItemState.Finish
            LabInventionPanel.setBulbState(self.m_data.bulbState)
            self.remainTime = 0
        end

        local timeTable = getTimeBySec(self.remainTime)
        local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
        LabInventionPanel.timeDownText.text = timeStr
    end
end

--初始化数据
function LabInventionCtrl:_initPanelData()
    self.m_data.type = 1
    self.remainTime = self.m_data.leftSec
    local formularItem = FormularConfig[self.m_data.itemId]
    if formularItem.phase ~= 5 then
        ct.log("cycle_w15_laboratory03", "阶段数不为5")
        return
    end
    if #formularItem.materials == 0 then  --判断是否为原料
        LabInventionPanel.showLine({})
        self.enough = true
        LabInventionPanel.goodRootTran.localScale = Vector3.zero
        LabInventionPanel.rawRootTran.localScale = Vector3.one
        --LabInventionPanel.matIconImg.mainTexture = Good[self.m_data.itemId].img
        LabInventionPanel.itemNameText.text = Material[self.m_data.itemId].name
    else
        DataManager.DetailModelRpc(LabScientificLineCtrl.static.buildingId, 'm_GetFormularData', function (data)
            data.backFunc = function(success)
                self.enough = success
            end
            LabInventionPanel.showLine(data)
            LabInventionPanel.goodRootTran.localScale = Vector3.one
            LabInventionPanel.rawRootTran.localScale = Vector3.zero
            --LabInventionPanel.goodIconImg.mainTexture = Good[self.m_data.itemId].img
            LabInventionPanel.itemNameText.text = Good[self.m_data.itemId].name
        end, formularItem.materials)
    end

    if not self.m_data.id then    --没有id则为临时添加的线
        self.m_data.bulbState = LabInventionBulbItemState.Empty
        LabInventionPanel.setBulbState(self.m_data.bulbState)
        if self.enough then
            LabInventionPanel.inventionBtn.transform.localScale = Vector3.one
        else
            LabInventionPanel.inventionBtn.transform.localScale = Vector3.zero
        end
    else
        if self.m_data.run and self.m_data.leftSec > 0 then    --如果在工作状态
            self.m_data.bulbState = LabInventionBulbItemState.Working
            LabInventionPanel.inventionBtn.transform.localScale = Vector3.zero
        else
            if self.m_data.roll > 0 then
                self.m_data.bulbState = LabInventionBulbItemState.Finish
                LabInventionPanel.inventionBtn.transform.localScale = Vector3.zero
            else
                self.m_data.bulbState = LabInventionBulbItemState.Empty
                LabInventionPanel.inventionBtn.transform.localScale = Vector3.zero
                ct.log("cycle_w15_laboratory03", "状态不对")
            end
        end
        LabInventionPanel.setBulbState(self.m_data.bulbState)
    end
end
--点了发明按钮
function LabInventionCtrl:_inventeBtnClick()
    local data = {itemId = self.m_data.itemId, type = 1, rollTarget = 1, workerNum = 0}
    DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_AddTempLineData', data)
    UIPage.ClosePage()
end