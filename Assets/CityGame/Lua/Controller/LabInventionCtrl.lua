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
        if self.backToCompose then
            ct.OpenCtrl("AddLineChooseItemCtrl")
        end
    end, self)
    self.luaBehaviour:AddClick(LabInventionPanel.inventionBtn.gameObject, function()
        self:_inventeBtnClick()
    end, self)
    self.luaBehaviour:AddClick(LabInventionPanel.progressSuccessBtn.gameObject, function()
        if LabScientificLineCtrl.static.buildingId and self.m_data.id then
            DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_ReqLabRoll', self.m_data.id)
            self.m_data.bulbState = LabInventionBulbItemState.Empty
            LabInventionPanel.setBulbState(self.m_data.bulbState)
        end
    end)
    UpdateBeat:Add(self._update, self)
end
function LabInventionCtrl:Refresh()
    Event.AddListener("c_LabRollSuccess", self._backToScientificCtrl)
    self:_initPanelData()
end
function LabInventionCtrl:Hide()
    Event.RemoveListener("c_LabRollSuccess", self._backToScientificCtrl)
    UIPage.Hide(self)
end
function LabInventionCtrl:_update()
    if not self.m_data then
        return
    end
    if self.m_data.bulbState and self.m_data.bulbState == LabInventionBulbItemState.Working then
        self.currentTime = self.currentTime + UnityEngine.Time.unscaledDeltaTime
        local remainTime = self.m_data.finishTime - self.currentTime
        if remainTime < 0 then
            self.m_data.bulbState = LabInventionBulbItemState.Finish
            LabInventionPanel.setBulbState(self.m_data.bulbState)
            LabInventionPanel.progressWorkingImg.fillAmount = 1
            return
        end

        local timeTable = getTimeBySec(remainTime)
        local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
        LabInventionPanel.timeDownText.text = timeStr
        LabInventionPanel.progressWorkingImg.fillAmount = 1 - remainTime / self.m_data.totalTime  --设置图片进度

        if self.currentTime >= self.m_data.finishTime then
            self.m_data.bulbState = LabInventionBulbItemState.Finish
            LabInventionPanel.setBulbState(self.m_data.bulbState)
            LabInventionPanel.progressWorkingImg.fillAmount = 1
            return
        end
    end
end

--初始化数据
function LabInventionCtrl:_initPanelData()
    self.m_data.type = 1
    self.currentTime = os.time()

    --根据itemId判断是不是原料
    if self.m_data.itemId < 2200000 then
        LabInventionPanel.showLine({})
        self.usedData = {}
        self.enough = true
        LabInventionPanel.goodRootTran.localScale = Vector3.zero
        LabInventionPanel.rawRootTran.localScale = Vector3.one
        --LabInventionPanel.matIconImg.mainTexture = Good[self.m_data.itemId].img
        LabInventionPanel.itemNameText.text = Material[self.m_data.itemId].name
    else
        local formularItem = FormularConfig[1][self.m_data.itemId]
        self.usedData = formularItem
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
        self.backToCompose = true
        self.m_data.bulbState = LabInventionBulbItemState.Empty
        LabInventionPanel.setBulbState(self.m_data.bulbState)
        if self.enough then
            self:_setInventBtnState(LabResearchBtnState.EnableClick)
        else
            self:_setInventBtnState(LabResearchBtnState.NotEnough)
        end
    else
        self.backToCompose = false
        if self.m_data.run and self.m_data.leftSec > 0 then    --如果在工作状态
            self.m_data.bulbState = LabInventionBulbItemState.Working
            self:_setInventBtnState(LabResearchBtnState.Working)
        else
            if self.m_data.roll > 0 then
                self.m_data.bulbState = LabInventionBulbItemState.Finish
            else
                self.m_data.bulbState = LabInventionBulbItemState.Empty
            end
            self:_setInventBtnState(LabResearchBtnState.NotEnough)
        end
        LabInventionPanel.setBulbState(self.m_data.bulbState)
    end
end

function LabInventionCtrl:_setInventBtnState(state)
    if state == LabResearchBtnState.EnableClick then  --默认可以点击
        LabInventionPanel.inventionBtn.transform.localScale = Vector3.one
        LabInventionPanel.notEnoughImgTran.localScale = Vector3.zero
        LabInventionPanel.workingImgTran.localScale = Vector3.zero
    elseif state == LabResearchBtnState.NotEnough then  --不够的状态/不可点击状态
        LabInventionPanel.inventionBtn.transform.localScale = Vector3.zero
        LabInventionPanel.notEnoughImgTran.localScale = Vector3.one
        LabInventionPanel.workingImgTran.localScale = Vector3.zero
    elseif state == LabResearchBtnState.Working then  --工作中
        LabInventionPanel.inventionBtn.transform.localScale = Vector3.zero
        LabInventionPanel.notEnoughImgTran.localScale = Vector3.zero
        LabInventionPanel.workingImgTran.localScale = Vector3.one
    end
end
--点了发明按钮
function LabInventionCtrl:_inventeBtnClick()
    local data = {itemId = self.m_data.itemId, type = 1, rollTarget = 1, workerNum = 0}
    DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_AddTempLineData', data)
    DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_UpdateLabStore', self.usedData)  --更新仓库库存
    UIPage.ClosePage()
end
--关闭自己，返回科技线界面
function LabInventionCtrl:_backToScientificCtrl()
    local info = {}
    info.titleInfo = "SUCCESS"
    info.contentInfo = "Stage of success!"
    info.tipInfo = ""
    info.btnCallBack = function ()
        UIPage.ClosePage()
    end
    ct.OpenCtrl("BtnDialogPageCtrl", info)
end