---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/27 17:10
---
LaboratoryModel = class('LaboratoryModel',ModelBase)
local pbl = pbl

function LaboratoryModel:initialize(insId)
    self.insId = insId
    self:_addListener()
end

--启动事件--
function LaboratoryModel:_addListener()
    --网络回调注册
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailLaboratory","gs.Laboratory",self.n_OnReceiveLaboratoryDetailInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","labLineAdd","gs.Laboratory.Line",self.n_OnReceiveLabLineAdd)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","labLaunchLine","gs.LabLaunchLine",self.n_OnReceiveLaunchLine)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","labLineDel","gs.LabDelLine",self.n_OnReceiveDelLine)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","labLineChange","gs.Laboratory.Line",self.n_OnReceiveLineChange)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","newItem","gs.IdNum",self.n_OnReceiveNewItem)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","labRoll","",self.n_OnReceiveLabRoll)

    --本地的回调注册
    Event.AddListener("m_ReqLaboratoryDetailInfo", self.m_ReqLaboratoryDetailInfo)
    Event.AddListener("m_ReqAddLine", self.m_ReqAddLine)
    Event.AddListener("m_ReqLabLaunchLine", self.m_ReqLabLaunchLine)
    Event.AddListener("m_ReqDeleteLine", self.m_ReqDeleteLine)
    Event.AddListener("m_ReqSetWorkerNum", self.m_ReqSetWorkerNum)
    Event.AddListener("m_ReqLabRoll", self.m_ReqLabRoll)

    Event.AddListener("m_ReqLabStoreInfo", self.m_ReqLabRoll)
end

--- 客户端请求 ---
--获取建筑详情
function LaboratoryModel:m_ReqLaboratoryDetailInfo()
    DataManager.ModelSendNetMes("gscode.OpCode", "detailLaboratory","gs.Id",{ id = self.insId})
end
--添加线
function LaboratoryModel:m_ReqAddLine(itemId, type, workerNum, rollTarget)
    --记录一个临时的线
    self.tempLine = { itemId = itemId, type = type, workerNum = workerNum, phase = rollTarget}

    --研究的时候，必须已经有等级才行
    if type == 0 then
        local level = DataManager.GetMyGoodLv()
        if level and level[itemId] then
            local lMsg = { buildingId = self.insId, itemId = itemId, type = type, workerNum = workerNum }
            DataManager.ModelSendNetMes("gscode.OpCode", "labLineAdd","gs.LabAddLine",lMsg)
        end
    else
        local lMsg = { buildingId = self.insId, itemId = itemId, type = type, workerNum = workerNum }
        DataManager.ModelSendNetMes("gscode.OpCode", "labLineAdd","gs.LabAddLine",lMsg)
    end
end
--开工
function LaboratoryModel:m_ReqLabLaunchLine(lineId, rollTarget)
    local lMsg = { buildingId = self.insId, lineId = lineId, phase = rollTarget }
    DataManager.ModelSendNetMes("gscode.OpCode", "labLaunchLine","gs.LabLaunchLine",lMsg)
end
--删除线
function LaboratoryModel:m_ReqDeleteLine(lineId)
    local lMsg = { buildingId = self.insId, lineId = lineId }
    DataManager.ModelSendNetMes("gscode.OpCode", "labLineDel","gs.LabDelLine",lMsg)
end
--改变员工数
function LaboratoryModel:m_ReqSetWorkerNum(lineId, staffCount)
    local lMsg = { buildingId = self.insId, lineId = lineId, n = staffCount }
    DataManager.ModelSendNetMes("gscode.OpCode", "labLineSetWorkerNum","gs.LabSetLineWorkerNum",lMsg)
end
--roll
function LaboratoryModel:m_ReqLabRoll(lineId)
    local lMsg = { buildingId = self.insId, lineId = lineId }
    DataManager.ModelSendNetMes("gscode.OpCode", "labRoll","gs.LabRoll",lMsg)
end

--- 回调 ---
--研究所详情
function LaboratoryModel:n_OnReceiveLaboratoryDetailInfo(data)
    self.info = data.info

    self.hashLineData = {}  --以lineId为key存储所有的线的信息
    self.orderLineData = {}  --由创建时间排序的所有line信息
    self.remainWorker = 0
    if data.line then
        for i, lineInfo in pairs(data.line) do
            self.hashLineData[lineInfo.id] = lineInfo
            self.orderLineData[#self.orderLineData + 1] = lineInfo
        end
        table.sort(self.orderLineData, function (m, n) return m.createTs > n.createTs end)

        for i, lineItem in pairs(data.line) do
            self.remainWorker = self.remainWorker + lineItem.workerNum
        end
    end
    self.maxWorkerNum = PlayerBuildingBaseData[data.info.mId].maxWorkerNum
    self.remainWorker = self.maxWorkerNum - self.remainWorker

    self.store = getItemStore(data.store)  --获取item个数的表
    DataManager.ControllerRpcNoRet(self.insId,"LaboratoryCtrl", '_receiveLaboratoryDetailInfo', self.orderLineData, data.info.mId, data.info.ownerId)
end
--添加研究发明线
function LaboratoryModel:n_OnReceiveLabLineAdd(data)
    table.insert(self.orderLineData, 1, data)
    if not self.hashLineData[data.id] then
        self.hashLineData[data.id] = data
    end
    self.remainWorker = self.remainWorker - data.workerNum
    self:m_ReqLabLaunchLine(self.insId, data.id, self.tempLine.rollTarget)
end
--开工
function LaboratoryModel:n_OnReceiveLaunchLine(data)
    --DataManager.ControllerRpcNoRet(self.insId,"LabScientificLineCtrl", '_onReceiveLabAddLine', self.line[1])
    --应该是更新数据

    self.tempLine = nil
end
--删除line
function LaboratoryModel:n_OnReceiveDelLine(data)
    local type
    if self.hashLineData[data.lineId] then
        type = self.hashLineData[data.lineId].type
        self.hashLineData[data.lineId] = nil
    else
        ct.log("cycle_w15_laboratory03", "不存在线但是请求删除")
        return
    end
    for i, item in ipairs(self.orderLineData) do
        if item.id == data.lineId then
            table.remove(self.orderLineData, i)
        end
    end
    self:_getScientificLine()
    if type == 0 then
        DataManager.ControllerRpcNoRet(self.insId,"LabScientificLineCtrl", 'onReceiveLabResearchData', type, self.researchLines)
    else
        DataManager.ControllerRpcNoRet(self.insId,"LabScientificLineCtrl", 'onReceiveLabInventionData', type, self.inventionLines)
    end
end
--更新某条线的具体数据
function LaboratoryModel:n_OnReceiveLineChange(data)
    local line = self.hashLineData[data.id]
    if line then
        line.lv = data.lv
        line.leftSec = data.leftSec
        line.phase = data.phase
        line.run = data.run
        line.roll = data.roll
        Event.Brocast("c_LabLineInfoUpdate", line)  --某条线信息更新
    else
        ct.log("", "找不到对应lineId的线路")
    end
end
--发明成功  --用来更新玩家数据
function LaboratoryModel:n_OnReceiveNewItem(data)
    --DataManager.ControllerRpcNoRet(self.insId,"LabScientificLineCtrl", '_onReceiveLabAddLine', data)
end
--roll
function LaboratoryModel:n_OnReceiveLabRoll(data)
    --DataManager.ControllerRpcNoRet(self.insId,"LabScientificLineCtrl", '_onReceiveLabAddLine', data)
end

---本地消息---
--根据id获取库存量 --传入单个itemId
function LaboratoryModel:m_GetItemStoreCount(itemId)
    return self.store[itemId] or 0
end
--根据传入的原料合成表返回包含仓库含量的表
function LaboratoryModel:m_GetFormularData(matTable)
    for i, item in ipairs(matTable) do
        item.haveCount = self.store[item.matId] or 0
    end
    return matTable
end
--获取空闲员工数
function LaboratoryModel:m_GetWorkerCount()
    return self.remainWorker
end

--获取科技线界面所需要的信息 --研究线，发明线以及员工数量
function LaboratoryModel:m_GetScientificData()
    if (not self.researchLines) or (not self.inventionLines) then
        self:_getScientificLine()
    end

    return self.researchLines, self.inventionLines, self.maxWorkerNum, self.remainWorker, self.tempType or 0
end
--获取最新的科技线信息
function LaboratoryModel:_getScientificLine()
    self.researchLines = {}
    self.inventionLines = {}
    for i, lineItem in ipairs(self.orderLineData) do
        if lineItem.type == 0 then
            self.researchLines[#self.researchLines + 1] = lineItem
        else
            self.inventionLines[#self.inventionLines + 1] = lineItem
        end
    end
end
--客户端显示 --添加临时线
function LaboratoryModel:m_AddTempLineData(data)
    local tempLine = {}
    tempLine.itemId = data.itemId
    tempLine.rollTarget = data.rollTarget
    tempLine.workerNum = data.workerNum
    tempLine.type = data.type
    tempLine.buildingId = self.insId
    self.tempType = data.type

    if data.type == 0 then
        table.insert(self.researchLines, 1, tempLine)
    else
        table.insert(self.inventionLines, 1, tempLine)
    end
end
--客户端显示 --删除临时线
function LaboratoryModel:m_DelTempLineData(data)
    if data.type == 0 then
        if self.researchLines[1].lineId then
            ct.log("", "错误错误错误")
        end
        table.remove(self.researchLines, 1)
        --DataManager.ControllerRpcNoRet(self.insId,"LabScientificLineCtrl", 'onReceiveLabResearchData', self.researchLines)
    else
        if self.inventionLines[1].lineId then
            ct.log("", "错误错误错误")
        end
        table.remove(self.inventionLines, 1)
        --DataManager.ControllerRpcNoRet(self.insId,"LabScientificLineCtrl", 'onReceiveLabInventionData', self.inventionLines)
    end
end
--更新ctrl 线的信息
function LaboratoryModel:m_UpdateCtrlLineInfo()

end
