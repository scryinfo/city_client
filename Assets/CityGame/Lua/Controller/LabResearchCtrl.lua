---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/29 17:38
---
LabResearchCtrl = class('LabResearchCtrl',UIPage)
UIPage:ResgisterOpen(LabResearchCtrl)

LabResearchCtrl.static.EmptyBtnPath = "View/Items/LaboratoryItems/EmptyBtn"  --按钮的预制

function LabResearchCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end
function LabResearchCtrl:bundleName()
    return "LabResearchPanel"
end
function LabResearchCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end
function LabResearchCtrl:Awake(go)
    self.gameObject = go
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(LabResearchPanel.backBtn.gameObject, function()
        UIPage.ClosePage()
    end)
    self.luaBehaviour:AddClick(LabResearchPanel.researchBtn.gameObject, function()
        self:_researchBtnFunc()
    end)
    self.luaBehaviour:AddClick(LabResearchPanel.progressSuccessBtn.gameObject, function()
        if self.m_data.buildingId and self.m_data.lineId then
            DataManager.DetailModelRpcNoRet(self.m_data.buildingId, 'm_ReqLabRoll', self.m_data.lineId)
        end
    end)
    UpdateBeat:Add(self._update, self)
end
function LabResearchCtrl:Refresh()
    self:_initPanelData()
end
function LabResearchCtrl:Hide()
    UIPage.Hide(self)
end

function LabResearchCtrl:_update()
    if self.m_data.bulbState and self.m_data.bulbState == LabInventionBulbItemState.Working and self.m_data.leftSec then
        if self.remainTime then
            self.remainTime = self.m_data.leftSec
        else
            self.remainTime = self.remainTime - UnityEngine.Time.unscaledDeltaTime
        end
        LabResearchPanel.progressWorkingImg.fillAmount = self.remainTime / self.m_data.phaseSec  --设置图片进度

        if self.remainTime <= 0 then
            self.m_data.bulbState = LabInventionBulbItemState.Finish
            LabResearchPanel:setBulbState(self.m_data.bulbState)
            return
        end

        local timeTable = getTimeBySec(self.remainTime)
        local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
        LabResearchPanel.timeDownText.text = timeStr
    end
end
--初始化数据
function LabResearchCtrl:_initPanelData()
    self.m_data.type = 0
    local formularItem = FormularConfig[self.m_data.itemId]
    if formularItem.phase ~= 1 or #formularItem.materials == 0 then
        ct.log("cycle_w15_laboratory03", "阶段数不为1")
        return
    end
    DataManager.DetailModelRpc(self.m_data.buildingId, 'm_GetFormularData', function (data)
        LabResearchPanel:showLine(data)
    end, formularItem.materials)

    --LabResearchPanel.iconImg.mainTexture = Good[self.m_data.itemId].img
    LabResearchPanel.itemNameText.text = Good[self.m_data.itemId].name

    if not self.m_data.id then    --没有id则为临时添加的线
        self.m_data.bulbState = LabInventionBulbItemState.Empty
        LabResearchPanel:setBulbState(self.m_data.bulbState)
        LabResearchPanel.researchBtn.localScale = Vector3.one

        LabResearchPanel.researchBtn.onClick:RemoveAllListeners()
        LabResearchPanel.researchBtn.onClick:AddListener(function ()
            self:_creatTempLine(self)
        end)
    else
        if self.m_data.leftSec > 0 then    --如果还在倒计时，则正在工作状态
            self.m_data.bulbState = LabInventionBulbItemState.Working
            LabResearchPanel.researchBtn.localScale = Vector3.zero
        else
            self.m_data.bulbState = LabInventionBulbItemState.Finish
            if self.m_data.roll == 0 then    --没有倒计时结束，且没有roll，则为从暂停的线点进来
                LabResearchPanel.researchBtn.localScale = Vector3.one
                LabResearchPanel.researchBtn.onClick:RemoveAllListeners()
                LabResearchPanel.researchBtn.onClick:AddListener(function ()
                    self:_launchLine(self)
                end)
            else
                LabResearchPanel.researchBtn.localScale = Vector3.zero    --没有id则为临时添加的线
            end
        end
        LabResearchPanel:setBulbState(self.m_data.bulbState)
    end
end
--添加临时线，返回科技线
function LabResearchCtrl:_creatTempLine(ins)
    local data = {itemId = ins.m_data.itemId, phase = 1, workerNum = 0}
    DataManager.DetailModelRpcNoRet(ins.m_data.buildingId, 'm_AddTempLineData', data)
    UIPage.ClosePage()
end
--继续研究，返回科技线
function LabResearchCtrl:_launchLine(ins)
    DataManager.DetailModelRpcNoRet(ins.m_data.buildingId, 'm_ReqLabLaunchLine', ins.m_data.lineId, ins.m_data.rollTarget + 1)
    UIPage.ClosePage()
end