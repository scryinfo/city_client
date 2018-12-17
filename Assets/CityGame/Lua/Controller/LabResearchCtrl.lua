---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/29 17:38
---
LabResearchBtnState =
{
    EnableClick = 0,
    Working = 1,
    NotEnough = 2,
}

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
        if self.backToCompose then
            ct.OpenCtrl("AddLineChooseItemCtrl")
        end
    end)
    self.luaBehaviour:AddClick(LabResearchPanel.researchBtn.gameObject, function()
        self:_researchBtnFunc()
    end)
    self.luaBehaviour:AddClick(LabResearchPanel.progressSuccessBtn.gameObject, function()
        if LabScientificLineCtrl.static.buildingId and self.m_data.lineId then
            DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_ReqLabRoll', self.m_data.lineId)
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
    if not self.m_data then
        return
    end
    if self.m_data.bulbState and self.m_data.bulbState == LabInventionBulbItemState.Working and self.m_data.leftSec > 0 then
        self.remainTime = self.remainTime - UnityEngine.Time.unscaledDeltaTime
        LabResearchPanel.progressWorkingImg.fillAmount = self.remainTime / self.m_data.phaseSec  --设置图片进度

        if self.remainTime <= 0 then
            self.m_data.bulbState = LabInventionBulbItemState.Finish
            LabResearchPanel:setBulbState(self.m_data.bulbState)
            self.remainTime = 0
        end

        local timeTable = getTimeBySec(self.remainTime)
        local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
        LabResearchPanel.timeDownText.text = timeStr
    end
end
--初始化数据
function LabResearchCtrl:_initPanelData()
    self.m_data.type = 0
    self.remainTime = self.m_data.leftSec
    local formularItem = FormularConfig[self.m_data.itemId]
    if #formularItem.materials == 0 then
        ct.log("cycle_w15_laboratory03", "阶段数不为1")
        return
    end
    DataManager.DetailModelRpc(LabScientificLineCtrl.static.buildingId, 'm_GetFormularData', function (data)
        data.backFunc = function(success)
            self.enough = success
        end
        LabResearchPanel:showLine(data)
    end, formularItem.materials)

    --LabResearchPanel.iconImg.mainTexture = Good[self.m_data.itemId].img
    LabResearchPanel.itemNameText.text = Good[self.m_data.itemId].name

    if not self.m_data.id then    --没有id则为临时添加的线
        self.backToCompose = true
        self.m_data.bulbState = LabInventionBulbItemState.Empty
        LabResearchPanel:setBulbState(self.m_data.bulbState)
        if self.enough then
            self:_setResearchBtnState(LabResearchBtnState.EnableClick)
            LabResearchPanel.researchBtn.onClick:RemoveAllListeners()
            LabResearchPanel.researchBtn.onClick:AddListener(function ()
                self:_creatTempLine()
            end)
        else
            self:_setResearchBtnState(LabResearchBtnState.NotEnough)
        end
    else
        self.backToCompose = false
        if self.m_data.leftSec > 0 then    --如果还在倒计时，则正在工作状态
            self.m_data.bulbState = LabInventionBulbItemState.Working
            self:_setResearchBtnState(LabResearchBtnState.Working)
        else
            if self.m_data.roll == 0 then    --没有倒计时结束，且没有roll，则为从暂停的线点进来
                self.m_data.bulbState = LabInventionBulbItemState.Empty
                self:_setResearchBtnState(LabResearchBtnState.EnableClick)
                LabResearchPanel.researchBtn.onClick:RemoveAllListeners()
                LabResearchPanel.researchBtn.onClick:AddListener(function ()
                    self:_launchLine()
                end)
            else
                self:_setResearchBtnState(LabResearchBtnState.NotEnough)
                self.m_data.bulbState = LabInventionBulbItemState.Finish
            end
        end
        LabResearchPanel:setBulbState(self.m_data.bulbState)
    end
end
function LabResearchCtrl:_setResearchBtnState(state)
    if state == LabResearchBtnState.EnableClick then  --默认可以点击
        LabResearchPanel.researchBtn.transform.localScale = Vector3.one
        LabResearchPanel.notEnoughImgTran.localScale = Vector3.zero
        LabResearchPanel.workingImgTran.localScale = Vector3.zero
    elseif state == LabResearchBtnState.NotEnough then  --不够的状态/不可点击状态
        LabResearchPanel.researchBtn.transform.localScale = Vector3.zero
        LabResearchPanel.notEnoughImgTran.localScale = Vector3.one
        LabResearchPanel.workingImgTran.localScale = Vector3.zero
    elseif state == LabResearchBtnState.Working then  --工作中
        LabResearchPanel.researchBtn.transform.localScale = Vector3.zero
        LabResearchPanel.notEnoughImgTran.localScale = Vector3.zero
        LabResearchPanel.workingImgTran.localScale = Vector3.one
    end
end
--添加临时线，返回科技线
function LabResearchCtrl:_creatTempLine(self)
    local data = {itemId = self.m_data.itemId, type = 0, phase = 1, workerNum = 0}
    DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_AddTempLineData', data)
    UIPage.ClosePage()
end
--继续研究，返回科技线
function LabResearchCtrl:_launchLine()
    DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_ReqLabLaunchLine', self.m_data.id, self.m_data.rollTarget + 1)
    UIPage.ClosePage()
end