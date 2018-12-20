---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/11 17:59
---科技线界面改变员工工资item
LabScientificChangeStaffItem = class('LabScientificChangeStaffItem')

function LabScientificChangeStaffItem:initialize(viewRect, parentBtn, gridGroup)
    self.viewRect = viewRect
    self.parentBtn = parentBtn
    self.gridGroup = gridGroup

    self.staffText = viewRect:Find("staffRoot/staffText"):GetComponent("Text")
    self.staffSlider = viewRect:Find("staffRoot/staffSlider"):GetComponent("Slider")
    self.delBtn = viewRect:Find("btnRoot/delBtn"):GetComponent("Button")
    self.okBtn = viewRect:Find("btnRoot/okBtn"):GetComponent("Button")
    self.disableImgTran = viewRect:Find("btnRoot/okBtn/disableImg")

    self.staffSlider.onValueChanged:AddListener(function(value)
        if value > 0 then
            self.disableImgTran.localScale = Vector3.zero
        else
            self.disableImgTran.localScale = Vector3.one
        end
        self.staffText.text = tostring(value)
    end)
    parentBtn.onClick:AddListener(function ()
        self:_hideSelf()
    end)
end
--处于新增线的状态 --需要包含itemId和buildingId
function LabScientificChangeStaffItem:newLineState(lineData, remainWorker)
    --父物体的bgBtn需要解除
    self.gridGroup.enabled = true
    self.viewRect.transform:SetAsLastSibling()
    self.viewRect.localScale = Vector3.one
    self.parentBtn.transform.localScale = Vector3.one
    self.parentBtn.interactable = false
    self.disableImgTran.transform.localScale = Vector3.one
    self.staffText.text = "0"
    self.staffSlider.maxValue = remainWorker

    self.delBtn.onClick:RemoveAllListeners()
    self.delBtn.onClick:AddListener(function ()
        DataManager.DetailModelRpcNoRet(lineData.buildingId, 'm_DelTempLineData', lineData)
        if lineData.type == 0 then
            ct.OpenCtrl("LabResearchCtrl", lineData)
        else
            ct.OpenCtrl("LabInventionCtrl", lineData)
        end
    end)
    self.okBtn.onClick:RemoveAllListeners()
    self.okBtn.onClick:AddListener(function ()
        local workerNum = self.staffSlider.value
        if workerNum > 0 then
            DataManager.DetailModelRpcNoRet(lineData.buildingId, 'm_ReqLabAddLine', lineData.itemId, lineData.type, workerNum, lineData.phase or 1)
            self:_hideSelf()
        end
    end)
end
--改变员工数量状态
function LabScientificChangeStaffItem:changeStaffCountState(data, remainWorker, itemRect)
    self.gridGroup.enabled = false
    self.viewRect.localScale = Vector3.one
    self.viewRect.position = itemRect.transform.position

    self.parentBtn.transform.localScale = Vector3.one
    self.parentBtn.interactable = true
    self.disableImgTran.transform.localScale = Vector3.one
    self.staffText.text = tostring(data.workerNum)
    self.staffSlider.maxValue = remainWorker + data.workerNum
    self.staffSlider.value = data.workerNum

    self.delBtn.onClick:RemoveAllListeners()
    self.delBtn.onClick:AddListener(function ()
        self:_hideSelf()
    end)
    self.okBtn.onClick:RemoveAllListeners()
    self.okBtn.onClick:AddListener(function ()
        local workerNum = self.staffSlider.value
        if workerNum ~= data.workerNum then
            DataManager.DetailModelRpcNoRet(LabScientificLineCtrl.static.buildingId, 'm_ReqSetWorkerNum', data.id, workerNum)
        end
        self:_hideSelf()
    end)
end
--隐藏显示
function LabScientificChangeStaffItem:_hideSelf()
    self.viewRect.localScale = Vector3.zero
    self.parentBtn.interactable = true
    self.parentBtn.transform.localScale = Vector3.zero
end
