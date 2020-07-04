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

LabResearchCtrl = class('LabResearchCtrl',UIPanel)
UIPanel:ResgisterOpen(LabResearchCtrl)

LabResearchCtrl.static.EmptyBtnPath = "View/Items/LaboratoryItems/EmptyBtn"  --Button prefabrication

function LabResearchCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end
function LabResearchCtrl:bundleName()
    return "Assets/CityGame/Resources/View/LabResearchPanel.prefab"
end
function LabResearchCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end
function LabResearchCtrl:Awake(go)
    self.gameObject = go
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(LabResearchPanel.backBtn.gameObject, function()
        UIPanel.ClosePage()
        if self.backToCompose then
            ct.OpenCtrl("AddLineChooseItemCtrl")
        end
    end)
    self.luaBehaviour:AddClick(LabResearchPanel.progressSuccessBtn.gameObject, function()
        if LabScientificLineCtrl.static.buildingId and self.m_data.id then
            DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_ReqLabRoll', self.m_data.id)
            --Reduce the number of rolls after roll and set run to false
            self.m_data.roll = 0
            self.m_data.run = false
            DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_UpdateLabLineInfoAfterRoll', self.m_data)

            self.m_data.bulbState = LabInventionBulbItemState.Empty
            LabResearchPanel.setBulbState(self.m_data.bulbState)
            if self.enough then
                self:_setResearchBtnState(LabResearchBtnState.EnableClick)
            else
                self:_setResearchBtnState(LabResearchBtnState.NotEnough)
            end
        end
    end)
    UpdateBeat:Add(self._update, self)
end
function LabResearchCtrl:Refresh()
    Event.AddListener("c_LabRollSuccess", self._backToScientificCtrl)
    self:_initPanelData()
end
function LabResearchCtrl:Hide()
    Event.RemoveListener("c_LabRollSuccess", self._backToScientificCtrl)
    UIPanel.Hide(self)
end

function LabResearchCtrl:_update()
    if not self.m_data then
        return
    end
    if self.m_data.bulbState and self.m_data.bulbState == LabInventionBulbItemState.Working then
        self.currentTime = self.currentTime + UnityEngine.Time.unscaledDeltaTime
        local remainTime = self.m_data.finishTime - self.currentTime
        if remainTime < 0 then
            self.m_data.bulbState = LabInventionBulbItemState.Finish
            LabResearchPanel.setBulbState(self.m_data.bulbState)
            LabResearchPanel.progressWorkingImg.fillAmount = 1
            return
        end

        local timeTable = getTimeBySec(remainTime)
        local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
        LabResearchPanel.timeDownText.text = timeStr
        LabResearchPanel.progressWorkingImg.fillAmount = 1 - remainTime / self.m_data.totalTime  --Set picture progress

        if self.currentTime >= self.m_data.finishTime then
            self.m_data.bulbState = LabInventionBulbItemState.Finish
            LabResearchPanel.setBulbState(self.m_data.bulbState)
            LabResearchPanel.progressWorkingImg.fillAmount = 1
            return
        end
    end
end
--Initialization data
function LabResearchCtrl:_initPanelData()
    self.m_data.type = 0
    self.currentTime = os.time()
    LabResearchPanel.levelText.text = "Lv"..tostring(DataManager.GetMyGoodLvByItemId(self.m_data.itemId))

    local formularItem = FormularConfig[0][self.m_data.itemId]
    self.usedData = formularItem
    if #formularItem.materials == 0 then
        ct.log("cycle_w15_laboratory03", "阶段数不为1")
        return
    end
    DataManager.DetailModelRpc(LabScientificLineCtrl.static.buildingId, 'm_GetFormularData', function (data)
        data.backFunc = function(success)
            self.enough = success
        end
        LabResearchPanel.showLine(data)
    end, formularItem.materials)

    LoadSprite(Good[self.m_data.itemId].img, LabResearchPanel.iconImg,true)
    LabResearchPanel.iconImg:SetNativeSize()
    LabResearchPanel.itemNameText.text = Good[self.m_data.itemId].name

    if not self.m_data.id then    --No id is the temporarily added line
        self.backToCompose = true
        self.m_data.bulbState = LabInventionBulbItemState.Empty
        LabResearchPanel.setBulbState(self.m_data.bulbState)
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
        if self.m_data.run then    --If it is still counting down, it is working
            self.m_data.bulbState = LabInventionBulbItemState.Working
            self:_setResearchBtnState(LabResearchBtnState.Working)
        else
            if self.m_data.roll == 0 then    --If there is no end of the countdown and there is no roll, it will come in from the paused line.
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
        LabResearchPanel.setBulbState(self.m_data.bulbState)
    end
end
function LabResearchCtrl:_setResearchBtnState(state)
    if state == LabResearchBtnState.EnableClick then  --Clickable by default
        LabResearchPanel.researchBtn.transform.localScale = Vector3.one
        LabResearchPanel.notEnoughImgTran.localScale = Vector3.zero
        LabResearchPanel.workingImgTran.localScale = Vector3.zero
    elseif state == LabResearchBtnState.NotEnough then  --Insufficient state/not clickable state
        LabResearchPanel.researchBtn.transform.localScale = Vector3.zero
        LabResearchPanel.notEnoughImgTran.localScale = Vector3.one
        LabResearchPanel.workingImgTran.localScale = Vector3.zero
    elseif state == LabResearchBtnState.Working then  --at work
        LabResearchPanel.researchBtn.transform.localScale = Vector3.zero
        LabResearchPanel.notEnoughImgTran.localScale = Vector3.zero
        LabResearchPanel.workingImgTran.localScale = Vector3.one
    end
end
--Add temporary line, return to technology line
function LabResearchCtrl:_creatTempLine()
    local data = {itemId = self.m_data.itemId, type = 0, phase = 1, workerNum = 0}
    DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_AddTempLineData', data, self.usedData)
    UIPanel.ClosePage()
end
--Continue research and return to the technology line
function LabResearchCtrl:_launchLine()
    DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_ReqLabLaunchLine', self.m_data.id, 1)
    DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_UpdateLabStore', self.usedData)  --Update warehouse inventory
    UIPanel.ClosePage()
end
--Close yourself and return to the tech line interface
function LabResearchCtrl:_backToScientificCtrl()
    local info = {}
    info.titleInfo = "SUCCESS"
    info.contentInfo = "Stage of success!"
    info.tipInfo = ""
    info.btnCallBack = function ()
        UIPanel.ClosePage()
    end
    ct.OpenCtrl("BtnDialogPageCtrl", info)
end